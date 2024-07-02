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
    
    @State private var name: String = ""
    @State private var nickname:String = ""
    @State private var gender:String = ""
    @State private var department:String = ""
    @State private var division:String = ""
    @State private var address:String = ""
    
    var body: some View {

            VStack{
                NavigationStack {
                    //-----------------------------------------------------------------------------
                    ZStack{
                        Color.customlightGray
                            .ignoresSafeArea(.all)
                        VStack{
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
                            }
                            
                            // ピッカーを表示するビュー
                            PhotosPicker(
                                selection: $selectedItems,
                                maxSelectionCount: 1,
                                selectionBehavior: .default,
                                matching: .images
                            ) {
                                Text("画像を変更")
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
                        }
                    }
                    .frame(height: 100)
                    //-----------------------------------------------------------------------------
                    
                    List(fetchProfile.profiles) { profile in
                        Section {
                            TextField("名前", text: $name)
                                .onAppear {
                                    name = profile.name
                                }
                        } header: {
                            Text("名前")
                        }
                        
                        Section {
                            TextField("ニックネーム",text:$nickname)
                                .onAppear {
                                    nickname = profile.nickname
                                }
                        } header: {
                            Text("ニックネーム（任意）")
                        }
                        
                        Section{
                            TextField("所属部署名（部）",text:$department)
                                .onAppear {
                                    department = profile.department
                                }
                            TextField("所属部署名（室/課）",text:$division)
                                .onAppear {
                                    division = profile.division
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
                            }
                        } header: {
                            Text("帰宅方面")
                        }
                    }
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .font(.system(size: 18))
                    .listSectionSpacing(5)
                    .scrollContentBackground(.hidden)
                    .background(Color.customlightGray)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("プロフィール設定")
                                .font(.system(size: 30))
                                .foregroundColor(Color.customTextColor)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.init(top: 40, leading: 10, bottom: 0, trailing: 0))
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button {
                                    viewModel.signOut()
                                } label: {
                                    Text("LOGOUT")
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                }
                            } label: {
                                if let selectedImages = selectedImages {
                                    Image(uiImage: selectedImages)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .trailing)
                                        .clipShape(Circle())
                                        .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
                                }
                            }
                            .padding(.init(top: 40, leading: 0, bottom: 0, trailing: 15))
                        }
                    }
                }
                
                .onAppear() {
                    Task {
                        if let userId = viewModel.userId{
                            try await fetchProfile.getProfile(userId: userId)
                            //                        fetchImage(id: userId) { image in
                            //                            if let image = image {
                            //                                selectedImages = image
                            //                            } else {
                            //                                print("画像が取れませんでした。")
                            //                            }
                            //                        }
                            //                    } else {
                            //                        print("userIdがありませんでした。getProfileできません。")
                        }
                    }
                }
                
                
                
                Button(action: {
                    Task {
                        let patchData = ProfilePatchType(name: name, nickname: nickname, gender: gender, department: department, division: division, address: address)
                        
                        if let userId = viewModel.userId{
                            try await fetchProfile.patchProfile(patchData: patchData, userId: userId)
                            try await UploadImage(selectedImages: selectedImages, id:userId)
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
            }
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




//#Preview {
//    Profile(viewModel: FirebaseModel())
//}
