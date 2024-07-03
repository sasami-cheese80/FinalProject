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
    @State var nickname:String = ""
    @State var gender:String = ""
    @State var department:String = ""
    @State var division:String = ""
    @State var address:String = ""
    @State var hobby:String = ""
    @State var message:String = ""
    //    @State private var tag:String = ""
    
    //一時保存用
    @State var tempName: String = ""
    @State var tempNickname: String = ""
    @State var tempGender: String = ""
    @State var tempDepartment: String = ""
    @State var tempDivision: String = ""
    @State var tempAddress: String = ""
    @State var tempHobby: String = ""
    @State var tempMessage: String = ""
    //    @State private var tag: String = ""
    @State var tempSelectedImages: UIImage?
    
    var body: some View {
        
        VStack{

            EditProfile(
                viewModel: viewModel,
                selectedImages: $selectedImages,
                selectedItems: $selectedItems,
                name: $name,
                nickname: $nickname,
                gender: $gender,
                department: $department,
                division: $division,
                address: $address,
                hobby: $hobby,
                message: $message,
                tempName: $tempName,
                tempNickname: $tempNickname,
                tempGender: $tempGender,
                tempDepartment: $tempDepartment,
                tempDivision: $tempDivision,
                tempAddress: $tempAddress,
                tempHobby: $tempHobby,
                tempMessage: $tempMessage,
                tempSelectedImages: $tempSelectedImages
            )
            
            Button(action: {
                Task {
                    let patchData = ProfilePatchType(name: name, nickname: nickname, gender: gender, department: department, division: division, address: address,hobby: hobby, message: message)
                    
                    if let userId = viewModel.userId{
                        try await fetchProfile.patchProfile(patchData: patchData, userId: userId)
                        UploadImage(selectedImages: selectedImages, id:userId)
                        try await fetchProfile.getProfile(userId: userId)
                        
                        
                    } else {
                        print("userIdがありませんでした。patchProfileできません。")
                    }
                    print("patchしました。")
                    
                    tabSelection = 1
                }
            }, label: {
                Text("変更")
                    .frame(width: 300, height: 50)
                    .background(Color.customMainColor)
                    .foregroundColor(Color.customTextColor)
                    .fontWeight(.semibold)
                    .cornerRadius(24)
            })
            .padding(.bottom, 20)
            .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
        } //VStack
        .background(Color.customlightGray)
    }
    
}

func UploadImage(selectedImages: UIImage?, id:Int){
    let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
    let uploadMetadata = StorageMetadata.init()
    uploadMetadata.contentType = "image/jpeg"
    let image = selectedImages
    let data = image!.jpegData(compressionQuality: 0.7)! as NSData
    
    storageref.putData(data as Data, metadata: uploadMetadata) { (data, error) in
        if error != nil {
            return
        }
    }
}

func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) {
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


//-----------------------------------------------

struct EditProfile: View {
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchProfile = FetchProfile()
    @Binding var selectedImages: UIImage?
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var name: String
    @Binding var nickname: String
    @Binding var gender: String
    @Binding var department: String
    @Binding var division: String
    @Binding var address: String
    @Binding var hobby: String
    @Binding var message: String
    //    @State private var tag:String = ""
    
    //一時保存用
    @Binding var tempName: String
    @Binding var tempNickname: String
    @Binding var tempGender: String
    @Binding var tempDepartment: String
    @Binding var tempDivision: String
    @Binding var tempAddress: String
    @Binding var tempHobby: String
    @Binding var tempMessage: String
    //    @State private var tag: String
    @Binding var tempSelectedImages: UIImage?
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                Color.customlightGray
                    .ignoresSafeArea(.all)
                VStack{
                    // ピッカーを表示するビュー
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 1,
                        selectionBehavior: .default,
                        matching: .images
                    ) {
                        // 配列内にUIImageデータが存在すれば表示
                        if let selectedImages = selectedImages {
                            Image(uiImage: selectedImages)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90,height: 90)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white,lineWidth: 1))
                                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                        .background(Color.customTextColor)
                                        .foregroundColor(Color.customMainColor)
                                        .cornerRadius(100)
                                        .padding(.init(top: 60, leading: 60, bottom: 0, trailing: 0))
                                )
                        }
                    }
                    .onChange(of: selectedItems) { items in
                        // 複数選択されたアイテムをUIImageに変換してプロパティに格納していく
                        Task {
                            for item in items {
                                guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                                guard let uiImage = UIImage(data: data) else { continue }
                                selectedImages = uiImage
                            }
                        }
                    }
                    
                    List(fetchProfile.profiles) { profile in
                        Section {
                            TextField("名前", text: $name)
                                .onAppear {
                                    print("ここここ\(profile)")
                                    name = profile.name
                                    if tempName != "" {
                                        name = tempName
                                    }
                                }
                                .onDisappear{
                                    tempName = name
                                }
                        } header: {
                            Text("名前")
                        }
                        
                        Section {
                            TextField("ニックネーム",text:$nickname)
                                .onAppear {
                                    nickname = profile.nickname
                                    if tempNickname != "" {
                                        nickname = tempNickname
                                    }
                                }
                                .onDisappear{
                                    tempNickname = nickname
                                }
                        } header: {
                            Text("ニックネーム（任意）")
                        }
                        
                        Section{
                            TextField("所属部署名（部）",text:$department)
                                .onAppear {
                                    department = profile.department
                                    if tempDepartment != "" {
                                        department = tempDepartment
                                    }
                                }
                                .onDisappear{
                                    tempDepartment = department
                                }
                            TextField("所属部署名（室/課）",text:$division)
                                .onAppear {
                                    division = profile.division
                                    if tempDivision != "" {
                                        division = tempDivision
                                    }
                                }
                                .onDisappear{
                                    tempDivision = division
                                }
                        } header: {
                            Text("所属部署")
                        }
                        
                        Section{
                            Picker("性別",selection:$gender) {
                                Text("男性").tag("男性")
                                Text("女性").tag("女性")
                            }
                            .pickerStyle(.segmented)
                            .onAppear {
                                gender = profile.gender
                                if tempGender != "" {
                                    gender = tempGender
                                }
                            }
                            .onDisappear{
                                tempGender = gender
                            }
                        } header: {
                            Text("性別")
                        }
                        
                        Section{
                            Picker("帰宅方面", selection: $address) {
                                Text("岡崎方面").tag("岡崎方面")
                                Text("名古屋・日進方面").tag("名古屋・日進方面")
                                Text("知立・安城方面").tag("知立・安城方面")
                                Text("長久手方面").tag("長久手方面")
                                Text("瀬戸方面").tag("瀬戸方面")
                                Text("岐阜方面").tag("岐阜方面")
                                Text("碧南・西尾方面").tag("碧南・西尾方面")
                                Text("豊川・豊橋方面").tag("豊川・豊橋方面")
                                Text("新城方面").tag("新城方面")
                            }
                            .onAppear {
                                address = profile.address
                                if tempAddress != "" {
                                    address = tempAddress
                                }
                            }
                            .onDisappear{
                                tempAddress = address
                            }
                        } header: {
                            Text("帰宅方面")
                        }
                        
                        Section {
                            TextField("趣味", text: $hobby)
                                .onAppear {
                                    hobby = profile.hobby
                                    if tempHobby != "" {
                                        hobby = tempHobby
                                    }
                                }
                                .onDisappear{
                                    tempHobby = hobby
                                }
                        } header: {
                            Text("趣味")
                                .foregroundStyle(Color.customMainColor)
                        }
                        
                        Section {
                            TextField("アイノリ相手へ一言メッセージ", text: $message)
                                .onAppear {
                                    message = profile.message
                                    if tempMessage != "" {
                                        message = tempMessage
                                    }
                                }
                                .onDisappear{
                                    tempMessage = message
                                }
                        } header: {
                            Text("アイノリ相手へ一言メッセージ")
                                .foregroundStyle(Color.customMainColor)
                        }
                        
                        Section {
                            TextField("タグ", text: $name)
                                .onAppear {
                                    name = profile.name
                                    if tempName != "" {
                                        name = tempName
                                    }
                                }
                                .onDisappear{
                                    tempName = name
                                }
                        } header: {
                            Text("タグ※一つずつスペースを開けてください")
                                .foregroundStyle(Color.customMainColor)
                        }
                        
                    }
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .font(.system(size: 18))
                    .listSectionSpacing(5)
                    .scrollContentBackground(.hidden)
                    .background(Color.customlightGray)
                    //                .navigationTitle("Profile")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.signOut()
                            } label: {
                                Text("LOGOUT")
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                    
                    
                } //VStack
            } //ZStack
        } //NavigationStack
        
        .onAppear{
            //                    print("aaaaaaaa\(tempName)")
            Task {
                if let userId = viewModel.userId{
                    try await fetchProfile.getProfile(userId: userId)
                    fetchImage(id: userId) { image in
                        if let image = image {
                            selectedImages = image
                        } else {
                            print("画像が取れませんでした。")
                        }
                    }
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
        }
    }
}

//-----------------------------------------------


//#Preview {
//    Profile(viewModel: FirebaseModel())
//}
