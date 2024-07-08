//
//  EditProfile.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/07/04.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct EditProfile: View {
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchProfile = FetchProfile()
    @Environment(\.dismiss) var dismiss
    
    @Binding var tabSelection: Int
    @State private var isProgress = false
    
    @Binding var selectedImages: UIImage?
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var name: String
    @Binding var nickname: String
    @Binding var gender: String
    @Binding var department: String
    @Binding var division: String
    @Binding var address: String
    @Binding var addressOfHouse: String
    @Binding var hobby: String
    @Binding var message: String
    @Binding var tags: Array<String>
    @Binding var stringTag: String
    
    //一時保存用
    @Binding var tempName: String
    @Binding var tempNickname: String
    @Binding var tempGender: String
    @Binding var tempDepartment: String
    @Binding var tempDivision: String
    @Binding var tempAddress: String
    @Binding var tempAddressOfHouse: String
    @Binding var tempHobby: String
    @Binding var tempMessage: String
    @Binding var tempTag: String
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
                            TextField("住所", text: $addressOfHouse)
                                .onAppear {
                                    addressOfHouse = profile.addressOfHouse
                                    if tempAddressOfHouse != "" {
                                        addressOfHouse = tempAddressOfHouse
                                    }
                                }
                                .onDisappear{
                                    tempAddressOfHouse = addressOfHouse
                                }
                        } header: {
                            Text("家の住所")
                        }
                        
                        Section {
                            TextField("趣味(任意)", text: $hobby)
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
                        }
                        
                        Section {
                            TextField("アイノリ相手へ一言メッセージ(任意)", text: $message)
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
                        }
                        
                        Section {
                            TextField("タグ ※全角スペース区切り(任意)", text: $stringTag)
                                .onAppear {
                                    stringTag = profile.tags.joined(separator: "　")
                                    if tempTag != "" {
                                        stringTag = tempTag
                                    }
                                }
                                .onDisappear{
                                    tempTag = stringTag
                                }
                        } header: {
                            Text("タグ付け ※全角スペース区切り")
                        }
                    }

                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .font(.system(size: 18))
                    .listSectionSpacing(5)
                    .scrollContentBackground(.hidden)
                    .background(Color.customlightGray)
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
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            let tagConvert = stringTag.components(separatedBy: "　")
                            let patchData = ProfilePatchType(name: name, nickname: nickname, gender: gender, department: department, division: division, address: address,addressOfHouse: addressOfHouse,hobby: hobby, message: message, tags: tagConvert)
                            
                            if let userId = viewModel.userId{
                                try await fetchProfile.patchProfile(patchData: patchData, userId: userId)
                                try await UploadImage(selectedImages: selectedImages, id:userId)
                                try await fetchProfile.getProfile(userId: userId)
                            } else {
                                print("userIdがありませんでした。patchProfileできません。")
                            }
                        }
                        //loading表示
                        manageProgress()
                        
                    }, label: {
                        Text("保存")
                            .frame(width: 300, height: 50)
                            .background(Color.customMainColor)
                            .foregroundColor(Color.customTextColor)
                            .fontWeight(.semibold)
                            .cornerRadius(24)
                    })
                    .padding(.bottom, 20)
                    .shadow(color: .gray.opacity(0.7), radius: 1, x: 2, y: 2)
                    
                } //VStack
                if isProgress {
                    Color.gray.opacity(0.5)
                        .ignoresSafeArea(.all)
                    ProgressView("Loading…")
                }
            } //ZStack
        } //NavigationStack
        
        .onAppear{
            Task {
                if let userId = viewModel.userId{
                    try await fetchProfile.getProfile(userId: userId)
                    try await fetchImage(id: userId) { image in
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
            tempHobby=""
            tempMessage=""
            tempTag=""
        }
        .onDisappear{
            dismiss()
        }
        
    }//View
    //loading2秒表示
    private func manageProgress() {
        // ProgressView 表示
        isProgress = true
        // 3秒後に非表示に
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isProgress = false
            dismiss()
        }
    }
    
    
}
