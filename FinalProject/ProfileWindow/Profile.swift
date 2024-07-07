//
//  Account.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct Profile: View {
    @Binding var tabSelection: Int
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchProfile = FetchProfile()
    
    @State var selectedImages: UIImage? = UIImage(named: "unknown4.png")
    @State var selectedItems: [PhotosPickerItem] = []
    @State var name: String = ""
    @State var nickname: String = ""
    @State var gender: String = ""
    @State var department: String = ""
    @State var division: String = ""
    @State var address :String = ""
    @State var addressOfHouse: String = ""
    @State var hobby: String = ""
    @State var message: String = ""
    @State var tags: Array<String> = [""]
    @State var stringTag: String = ""
    
    //一時保存用
    @State var tempName: String = ""
    @State var tempNickname: String = ""
    @State var tempGender: String = ""
    @State var tempDepartment: String = ""
    @State var tempDivision: String = ""
    @State var tempAddress: String = ""
    @State var tempAddressOfHouse: String = ""
    @State var tempHobby: String = ""
    @State var tempMessage: String = ""
    @State var tempTag: String = ""
    @State var tempSelectedImages: UIImage?
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        
        
        NavigationStack{
            ZStack{
                Color.customlightGray
                    .ignoresSafeArea()
                VStack{
                    
                    if let userId = viewModel.userId{
                            //Icon
                            getImage2(id: userId, size: 130)
                                .padding(.bottom, 10)
                    } else {}
                    
                    ForEach(fetchProfile.profiles) { profile in
                        
                            Text(profile.name)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom, 5)
                                .foregroundColor(Color.customTextColor)
                            Text(profile.nickname)
                                .fontWeight(.medium)
                                .foregroundColor(Color.customTextColor)
                                .padding(.bottom, 30)
                            
                            
                            HStack{
                                Image(systemName: "figure.baseball")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 20))
                                    .foregroundColor(Color.customTextColor)
                                Text(profile.hobby)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.customTextColor)
                                    .fontWeight(.medium)
                            }.padding(.bottom, 30)
                            
                            HStack{
                                Image(systemName: "message.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 20))
                                    .foregroundColor(Color.customTextColor)
                                Text(profile.message)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.customTextColor)
                                    .fontWeight(.medium)
                            }.padding(.bottom, 30)
                            
                            HStack{
                                Image(systemName: "building.2.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 20))
                                    .foregroundColor(Color.customTextColor)
                                VStack{
                                    Text(profile.department)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.medium)
                                    Text(profile.division)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(Color.customTextColor)
                            }.padding(.bottom, 30)
                            
                            HStack{
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 20))
                                    .foregroundColor(Color.customTextColor)
                                Text(profile.address)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.customTextColor)
                                    .fontWeight(.medium)
                            }.padding(.bottom, 30)
                            
                            
                            Tag(alignment: .leading, spacing: 7) {
                                ForEach(profile.tags, id: \.self) { oneTag in
                                    Text(oneTag)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 12)
                                        .background(Color.customMainColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                        .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                                }
                            }
                            .padding()
                        }
                    
                    Spacer()
                    
                    NavigationLink(destination: {
                        EditProfile(
                            viewModel: viewModel,
                            tabSelection: $tabSelection,
                            selectedImages: $selectedImages,
                            selectedItems: $selectedItems,
                            name: $name,
                            nickname: $nickname,
                            gender: $gender,
                            department: $department,
                            division: $division,
                            address: $address,
                            addressOfHouse: $addressOfHouse,
                            hobby: $hobby,
                            message: $message,
                            tags: $tags,
                            stringTag: $stringTag,
                            tempName: $tempName,
                            tempNickname: $tempNickname,
                            tempGender: $tempGender,
                            tempDepartment: $tempDepartment,
                            tempDivision: $tempDivision,
                            tempAddress: $tempAddress,
                            tempAddressOfHouse: $tempAddressOfHouse,
                            tempHobby: $tempHobby,
                            tempMessage: $tempMessage,
                            tempTag: $tempTag,
                            tempSelectedImages: $tempSelectedImages
                        )
                    },label: {
                        Text("編集する")
                            .fontWeight(.bold)
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.customMainColor)
                            .fontWeight(.semibold)
                            .background(Color.customTextColor)
                            .cornerRadius(24)
                            .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    })
                    .padding(.bottom, 20)
                    .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
                }
                .background(Color.customlightGray)
                .onAppear{
                    print("onApper!!!!")
                    Task {
                        if let userId = viewModel.userId{
                            try await fetchProfile.getProfile(userId: userId)
                        } else {
                            print("userIdがありませんでした。getProfileできません。")
                        }
                    }
                    tempName = ""
                    tempNickname = ""
                    tempGender = ""
                    tempDepartment = ""
                    tempDivision = ""
                    tempAddress = ""
                    tempAddressOfHouse = ""
                    tempHobby=""
                    tempMessage=""
                    tempTag=""
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            tabSelection = 1
                            viewModel.signOut()
                        } label: {
                            Text("LOGOUT")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
                .frame(maxWidth:.infinity)
                Spacer()
            }
        }
    }
    
}


//icon画像アップロード
func UploadImage(selectedImages: UIImage?, id:Int) async throws{
    let storageRef = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
    let uploadMetadata = StorageMetadata.init()
    uploadMetadata.contentType = "image/jpeg"
    let image = selectedImages
    let data = image!.jpegData(compressionQuality: 0.7)! as NSData
    
    storageRef.putData(data as Data, metadata: uploadMetadata) { (data, error) in
        if error != nil {
            return
        }
    }
}

//icon画像取得
func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) async throws {
    let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
    storageref.getData(maxSize: 4 * 1024 * 1024){ (data,error) in
        if let error = error {
            print("Got an error fetching data: \(error.localizedDescription)")
            completion(nil)
            return
        }
        if let data = data {
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Could not convert data to UIImage.")
                completion(nil)
            }
        } else {
            print("Data was nil.")
            completion(nil)
        }
    }
}
