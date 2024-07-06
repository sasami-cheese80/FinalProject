import SwiftUI
import MapKit

struct testMap: View {
    @State private var route: MKRoute?
    @State private var isShowingRoutes = false
    @State private var distance:String? = nil
    @State private var travelTime:String? = nil
    @State private var usersAddress:[String:CLLocationCoordinate2D] = [
        "0":CLLocationCoordinate2D (latitude: 35.07254029230496, longitude:137.15790836568544),
        "1":CLLocationCoordinate2D(latitude: 35.07487219994566, longitude: 137.15407159405302),
        "2":CLLocationCoordinate2D(latitude: 35.077062190460744, longitude: 137.15647373667156),
        "3":CLLocationCoordinate2D(latitude: 35.070513820992964, longitude: 137.16078363735534)
    ]
    @State private var usersDistance:[String?:Double?] = [:]
    @State private var sortNearUsers:[String] = []
    @State private var sortNearRoutes:[Double] = []
    @State private var newUsersDistance:[String?:Double?] = [:]
    @State private var newUsers:[String] = []
    @State private var newRoutes:[Double] = []
    @State private var testRoutes:[MKRoute?] = []
    
    var body: some View {
        VStack {
            if let travelTime = travelTime{
                Text(travelTime)
            }
            if let distance = distance{
                Text(distance)
            }
            
            VStack{
                HStack{
                    ForEach(sortNearUsers,id: \.self){ item in
                        Text(item)
                    }
                }
                HStack{
                    ForEach(sortNearRoutes,id: \.self){ item in
                        Text("\(String(item))km")
                    }
                }
                HStack{
                    ForEach(newUsers,id: \.self){ item in
                        Text(item)
                    }
                }
                HStack{
                    ForEach(newRoutes,id: \.self){ item in
                        Text("\(String(item))km")
                    }
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
                            await calculateRoute(transportType: .automobile,source: CLLocationCoordinate2D.toyotaStation,distination: usersAddress[sortNearUsers[0]]!,id: sortNearUsers[0])
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
                            await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[0]]! ,distination: usersAddress[sortNearUsers[1]]!,id: sortNearUsers[1])
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
                            await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[1]]! ,distination: usersAddress[sortNearUsers[2]]!,id: sortNearUsers[2])
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
                            await calculateRoute(transportType: .automobile,source:usersAddress[sortNearUsers[2]]! ,distination: usersAddress[sortNearUsers[3]]!,id: sortNearUsers[3])
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
                for (key,address) in usersAddress{
                    
                        print("index\(key)")
                        await closeToStation(transportType:.automobile, distination: address,key:key)
                    
                }
                for(key,value) in usersDistance.sorted(by: {$0.value! < $1.value!}){
                    sortNearUsers.append(key!)
                    sortNearRoutes.append(value!)
                }
                
                await calculateRoute(transportType: .automobile,source: CLLocationCoordinate2D.toyotaStation, distination: usersAddress[sortNearUsers[0]]!,id:sortNearUsers[0])
                
                for index in sortNearUsers.indices {
                    if index == 0{
                        await nextStop(transportType: .automobile, source: CLLocationCoordinate2D.toyotaStation, distination: usersAddress[sortNearUsers[index]]!,key:sortNearUsers[index])
                    }else{
                        await nextStop(transportType: .automobile, source: usersAddress[sortNearUsers[index-1]]!, distination: usersAddress[sortNearUsers[index]]!,key:sortNearUsers[index])
                    }
                }
                
                for(key,value) in newUsersDistance{
                    newUsers.append(key!)
                    newRoutes.append(value!)
                }
            }
            
        }
    }

//    func calculateRoute(transportType: MKDirectionsTransportType,distination:CLLocationCoordinate2D) async {
//        let sourceCoordinate = CLLocationCoordinate2D.toyotaStation
//        let destinationCoordinate = distination
//
//        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: sourcePlacemark)
//        request.destination = MKMapItem(placemark: destinationPlacemark)
//        request.transportType = transportType
//        do {
//            let directions = MKDirections(request: request)
//            let response = try await directions.calculate()
//            let routes = response.routes
//            route = routes.first
//            if let route = route{
//                travelTime =
//                "約\(Int(ceil(route.expectedTravelTime / 60)))分かかります"
//                distance = "\(round(route.distance*10 / 1000)/10)kmあります"
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
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
    
}
//
//#Preview {
//    testMap()
//}
