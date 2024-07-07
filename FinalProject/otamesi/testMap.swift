import SwiftUI
import MapKit

struct testMap: View {
    @Environment(\.dismiss) var dismiss
    @State private var route: MKRoute?
    @State private var isShowingRoutes = false
    @State private var distance:String? = nil
    @State private var travelTime:String? = nil
    @State private var usersPlaces:[String?:String?] = [
        "0":"愛知県豊田市トヨタ町５３０",
        "1":"愛知県豊田市錦町２丁目５７",
        "2":"愛知県豊田市金谷町２丁目",
        "3":"愛知県豊田市小坂本町８丁目５−１"
    ]
    //    @State private var usersAddress:[String:CLLocationCoordinate2D] = [
    //        "0":CLLocationCoordinate2D (latitude: 35.07254029230496, longitude:137.15790836568544),
    //        "1":CLLocationCoordinate2D(latitude: 35.07487219994566, longitude: 137.15407159405302),
    //        "2":CLLocationCoordinate2D(latitude: 35.077062190460744, longitude: 137.15647373667156),
    //        "3":CLLocationCoordinate2D(latitude: 35.070513820992964, longitude: 137.16078363735534)
    //    ]
    @State private var usersAddress:[String?:CLLocationCoordinate2D?] = [:]
    @State private var usersDistance:[String?:Double?] = [:]
    @State private var sortNearUsers:[String] = []
    @State private var sortNearRoutes:[Double] = []
    @State private var newUsersDistance:[String?:Double?] = [:]
    @State private var newUsers:[String] = []
    @State private var newRoutes:[Double] = []
    @State private var testRoutes:[MKRoute?] = []
    @State private var isProgress = false
    @State private var myTotalDistance:Double = 0
    @State private var myTotalFare:Int = 0
    @State private var myNumber:String = "2"
    @State private var shareTotalDistance:Double = 0.0
    @State private var shareTotalFare:Int = 0
    @State private var shareAddTotalFare:Int = 0
    @State private var myShareTotalFare:Int = 0
    @State private var myShareTotalDistance:Double = 0.0
    
    var body: some View {
            VStack {
                VStack{
                    Text("ようこそ\(myNumber)様")
                    HStack{
                        Text("おひとり")
                        Text("距離:\(String(myTotalDistance))km")
                        Text("料金:\(String(myTotalFare))円")
                        }
                    HStack{
                        Text("相乗り")
                        Text("距離:\(String(myShareTotalDistance))km")
                        Text("料金:\(String(myShareTotalFare))円")
                        }

                }
                
                Map() {
                    if !testRoutes.isEmpty{
                        ForEach(testRoutes,id: \.self){ route in
                            if let routePolyline = route?.polyline {
                                MapPolyline(routePolyline)
                                    .stroke(.blue, lineWidth: 8)
                            }
                        }
                    }else{
                        if let routePolyline = route?.polyline {
                            MapPolyline(routePolyline)
                                .stroke(.blue, lineWidth: 8)
                        }
                    }
                    
                }
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 32) {
                        Spacer()
                        Button {
                            Task {
                                await calculateRoute(transportType: .automobile,source: CLLocationCoordinate2D.toyotaStation,distination: usersAddress[sortNearUsers[0]]!!,id: sortNearUsers[0])
                            }
                        } label: {
                            Image(systemName: "figure.walk")
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                )
                                .padding(.top, 8)
                        }
                        
                        Button {
                            Task {
                                await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[0]]!! ,distination: usersAddress[sortNearUsers[1]]!!,id: sortNearUsers[1])
                            }
                        } label: {
                            Image(systemName: "car.fill")
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                )
                                .padding(.top, 8)
                        }
                        
                        Button {
                            Task {
                                await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[1]]!! ,distination: usersAddress[sortNearUsers[2]]!!,id: sortNearUsers[2])
                            }
                        } label: {
                            Image(systemName: "bicycle")
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                )
                                .padding(.top, 8)
                        }
                        
                        Button {
                            Task {
                                await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[2]]!! ,distination: usersAddress[sortNearUsers[3]]!!,id: sortNearUsers[3])
                            }
                        } label: {
                            Image(systemName: "bicycle")
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                )
                                .padding(.top, 8)
                        }
                        Spacer()
                    }
                    .background(.thinMaterial)
                }
                
            }
            
            //        .task {
            //            await calculateRoute(transportType: .automobile,source: CLLocationCoordinate2D.toyotaStation, distination: usersAddress[sortNearUsers[0]]!)
            //        }
            .onAppear(){
                Task{
                    usersDistance = [:]
                    sortNearUsers = []
                    sortNearRoutes = []
                    newUsers = []
                    newRoutes = []
                    testRoutes = []
                    
                    for (key,place) in usersPlaces{
                        var placemark = try await getGeocode(place: place!)
                        print(placemark.location?.coordinate ?? "Unknown")
                        usersAddress[key] = placemark.location?.coordinate
                    }
                    
                    
                    for (key,address) in usersAddress{
                        await closeToStation(transportType:.automobile, distination: address!,key:key!)
                        
                    }
                    for(key,value) in usersDistance.sorted(by: {$0.value! < $1.value!}){
                        sortNearUsers.append(key!)
                        sortNearRoutes.append(value!)
                        if key == myNumber{
                            oneTaxiFare(distance: value!)
                        }
                    }
                    
                    await calculateRoute(transportType: .automobile,source: CLLocationCoordinate2D.toyotaStation, distination: usersAddress[sortNearUsers[0]]!!,id:sortNearUsers[0])
                    
                    for index in sortNearUsers.indices {
                        if index == 0{
                            await nextStop(transportType: .automobile, source: CLLocationCoordinate2D.toyotaStation, distination: usersAddress[sortNearUsers[index]]!!,key:sortNearUsers[index])
                        }else{
                            await nextStop(transportType: .automobile, source: usersAddress[sortNearUsers[index-1]]!!, distination: usersAddress[sortNearUsers[index]]!!,key:sortNearUsers[index])
                        }
                    }
                    
                    for(key,value) in newUsersDistance{
                        newUsers.append(key!)
                        newRoutes.append(value!)
                    }
                    for(key,value) in newUsersDistance{
                        if key == myNumber{
                            shareTaxiFare(key:key!,value:value!)
                        }
                    }
                    
                    //                let address = "愛知県豊田市広路町３丁目１８"
                    //                let pracemarks:[CLPlacemark] = try await CLGeocoder().geocodeAddressString(address)
                    //                let test = pracemarks.first
                    //                if let res = test{
                    //                    print(res.location?.coordinate.latitude)
                    //                    print(res.location?.coordinate.longitude)
                    //                }
                }
            
        }
    }
    
    func calculateRoute(transportType: MKDirectionsTransportType,source:CLLocationCoordinate2D,distination:CLLocationCoordinate2D,id:String) async {
        testRoutes = []
        let sourceCoordinate = source
        let destinationCoordinate = distination
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = transportType
        do {
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            let routes = response.routes
            route = routes.first
            if let route = route{
                travelTime =
                "約\(Int(ceil(route.expectedTravelTime / 60)))分かかります"
                distance = "\(round(route.distance*10 / 1000)/10)kmあります"
                newUsersDistance[id] = round(route.distance*10 / 1000)/10
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func closeToStation(transportType: MKDirectionsTransportType,distination:CLLocationCoordinate2D,key:String) async {
        let sourceCoordinate = CLLocationCoordinate2D.toyotaStation
        let destinationCoordinate = distination
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = transportType
        do {
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            let routes = response.routes
            if let route = routes.first{
                usersDistance[key] = (round(route.distance*10 / 1000)/10)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func nextStop(transportType: MKDirectionsTransportType,source:CLLocationCoordinate2D,distination:CLLocationCoordinate2D,key:String) async {
        let sourceCoordinate = source
        let destinationCoordinate = distination
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = transportType
        do {
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            let routes = response.routes
            if let route = routes.first{
                testRoutes.append(route)
                newUsersDistance[key] = (round(route.distance*10 / 1000)/10)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func getGeocode(place:String) async throws -> CLPlacemark {
        let geocoder = CLGeocoder()
        
        guard let placemark = try await geocoder.geocodeAddressString(place).first else {
            throw CLError(.geocodeFoundNoResult)
        }
        
        return placemark
    }
    
    func oneTaxiFare(distance:Double){
        let startingFare = 630
        let startingDistance = 1.124
        
        let addCharge = 100
        let addChargeDistance = 0.253
        
        let myAddDistance = distance - startingDistance
        let myAddCharge = Int(ceil((myAddDistance/addChargeDistance) * Double(addCharge)))
        
        myTotalDistance = distance
        myTotalFare = startingFare + myAddCharge
        print("走行距離は\(distance)km")
        print("タクシー料金は：\(myTotalFare)円です")
    }
    
    func shareTaxiFare(key:String,value:Double){
        print(sortNearUsers)
        print(sortNearRoutes)
        let startingFare = 630
        let startingDistance = 1.124
        let addCharge = 100
        let addChargeDistance = 0.253
                
        var totalNumber = sortNearUsers.count
        print("\(totalNumber)人の乗客が乗っています")
        let firstIndex = sortNearUsers.firstIndex(of:key)
        
        print("\(key)番さんは\(firstIndex! + 1)番目に近いです")
        print(key,value)
        
        for number in 1...totalNumber {
            
            print("現在の乗客数\(totalNumber)")
            print("\(number)人目が降車する時の計算を開始します")
            let stepOutUser = sortNearUsers[number - 1]
            print("\(stepOutUser)さんが降車します")
            let nextDistance = newUsersDistance[stepOutUser]!!
//            一人目が目的地に着くまでにかかった距離を求める
            shareTotalDistance += nextDistance
            print("現在の走行距離\(shareTotalDistance)km")
            print("次の目的地まで\(nextDistance)km")

            var shareAddDistance:Double = 0
            if (number == 1){
                print("初乗り料金を上乗せします")
//                初乗りを考慮した加算距離の算出
                shareAddDistance = nextDistance - startingDistance
                print("初乗りは\(startingDistance)km")
                print("加算距離は\(shareAddDistance)km")
                let shareAddCharge = Int(ceil((shareAddDistance/addChargeDistance) * Double(addCharge)))
                print("加算料金は\(shareAddCharge)円です")
                shareTotalFare = startingFare
                shareTotalFare += shareAddCharge
                print("精算する合計料金は\(shareTotalFare)円です")
    //            一人目が目的地に着くまでにかかった金額を乗客数で割る
                let onePersonFare = shareTotalFare/totalNumber
                print("乗客数\(totalNumber)人で割った時の一人当たりの金額は\(onePersonFare)円です")
                shareAddTotalFare += onePersonFare
                print("現在のあなたの利用料金は\(shareAddTotalFare)円です")
            }else{
                print("加算料金のみ計算します")
                shareAddDistance = nextDistance
                print("加算距離は\(shareAddDistance)km")
                let shareAddCharge = Int(ceil((shareAddDistance/addChargeDistance) * Double(addCharge)))
                print("加算料金は\(shareAddCharge)円です")
                shareTotalFare = shareAddCharge
                print("精算する合計料金は\(shareTotalFare)円です")
    //            一人目が目的地に着くまでにかかった金額を乗客数で割る
                let onePersonFare = shareTotalFare/totalNumber
                print("乗客数\(totalNumber)人で割った時の一人当たりの金額は\(onePersonFare)円です")
                shareAddTotalFare += onePersonFare
                print("現在の利用料金は\(shareAddTotalFare)円です")
            }

            if(String(stepOutUser) == myNumber){
                myShareTotalFare = shareAddTotalFare
                myShareTotalDistance = ceil(shareTotalDistance)
                print("あなたのお支払い金額をお伝えします")
                print("おひとり時の走行距離は\(myTotalDistance)km")
                print("おひとり時のタクシー料金は：\(myTotalFare)円です")
                print("相乗り時の走行距離は\(myShareTotalDistance)km")
                print("相乗り時のタクシー料金は：\(myShareTotalFare)円です")
                
            }
            totalNumber -= 1
            print("計算終了")
            
        }
        
        let newUsersIndex = newUsers.firstIndex(of: key)
        print(newUsers)
        print(newRoutes)
        print(newRoutes[newUsersIndex!])
        
    }
    
    
}
//
//#Preview {
//    testMap()
//}
