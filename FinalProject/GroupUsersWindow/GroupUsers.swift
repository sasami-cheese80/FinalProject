//
//  GroupMember.swift
//  FinalProject
//
//  Created by user on 2024/06/25.
//



import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage


struct GroupUsers: View {
    var planId: Int
    var userId: Int
//    private let tags = ["アイドル", "旅行", "サウナ"]
    @ObservedObject var viewModel: FirebaseModel
    @ObservedObject var fetchUsers = FetchUsers()
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack{
            NavigationStack {
                
                
                List(fetchUsers.users, id: \.id) { user in
                    
                    NavigationLink {
                        MemberProfile(id: user.user_id,
                                      name: user.name,
                                      nickname: user.nickname,
                                      gender: user.gender,
                                      department: user.department,
                                      division: user.division,
                                      hobby: user.hobby,
                                      message: user.message,
                                      tags: user.tags
                        )
                    } label : {
                        
                        HStack{
                            
                            //Icon
                            getImage(id: user.user_id, size: 75)
                                .padding(.init(top: 0, leading: 25, bottom: 0, trailing: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text(user.nickname)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 3)
                                HStack{
                                    Text("趣味 : ")
                                        .foregroundColor(Color.customTextColor)
                                        .fontWeight(.medium)
                                    Text("\(user.hobby)")
                                }
                                .padding(.bottom, 3)
                                HStack{
                                    Text("一言 : ")
                                        .foregroundColor(Color.customTextColor)
                                        .fontWeight(.medium)
                                    Text("\(user.message)")
                                }
                                
                                Tag(alignment: .leading, spacing: 7) {
                                    ForEach(user.tags, id: \.self) { tag in
                                        Text(tag)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 12)
                                            .background(Color.customMainColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                    }
                                }
                                
                            }
                            .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 10))
                            
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 300)
                        }
                        .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        
                    }
                    .navigationBarTitle(Text("相乗りメンバー"))
                    .frame(width: 400)
                    .foregroundColor(Color.customTextColor)
                    .background(Color.white.opacity(0.3))
                    .background(Color.white)
                    .cornerRadius(10)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.customlightGray)
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke( Color.clear, lineWidth: 1.0)
                    )
                }
                .listStyle(.plain)
                .background(Color.customlightGray)
            }
            .onAppear() {
                fetchUsers.getUsers(planId: planId)
            }
            .onDisappear() {
                dismiss()
            }
            
            Text("のりば : 豊田市駅西口タクシー乗り場")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 15, leading: 20, bottom: 15, trailing: 20))
                .background(.white)
                .cornerRadius(8)
                .foregroundColor(Color.customTextColor)
                .padding(.init(top: 0, leading: 50, bottom: 10, trailing: 50))
                .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            
            NavigationLink(destination: {
                testMap(viewModel:viewModel, fetchUsers:$fetchUsers.users )
            }, label: {
                Text("料金を確認する")
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
            
            Button(action: {
                //                print("ここでdeleteします")
                fetchUsers.deletePlan(user_id: userId, plan_id: planId)
                dismiss() //現在のビューを閉じる
            }, label: {
                Text("相乗りをキャンセル")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 50)
                    .foregroundColor(Color.customMainColor)
                    .fontWeight(.semibold)
                    .background(Color.customTextColor)
                    .cornerRadius(24)
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                //                    .frame(maxWidth: 200, alignment: .center)
                //                    .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                //                    .background(Color.customlightGray)
                //                    .cornerRadius(15)
                //                    .foregroundColor(Color(red: 0.104, green: 0.551, blue: 1.0))
                //                    .padding(.init(top: 0, leading: 50, bottom: 15, trailing: 50))
                //                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            })
            .padding(.bottom,20)
        }
        .background(Color.customlightGray)
    }
    
}


struct getImage: View {
    
    let id: Int
    let size: CGFloat
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
            } else {
                ProgressView()
                    .frame(width: 90, height: 90)
            }
        }
        .onAppear {
            fetchImage(fetchId: id) { fetchedImage in
                self.image = fetchedImage
            }
        }
    }
}

func fetchImage(fetchId: Int, completion: @escaping (UIImage?) -> Void) {
    let storageRef = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com")
        .child("images")
        .child("\(fetchId).jpg")
    
    storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
        if let error = error {
            print("Error downloading image: \(error.localizedDescription)")
            completion(nil)
            return
        }
        guard let data = data, let image = UIImage(data: data) else {
            print("Error converting data to image")
            completion(nil)
            return
        }
        completion(image)
    }
}


#Preview {
    GroupUsers(planId: 1, userId: 6,viewModel: FirebaseModel())
}
