//
//  otamesi2.swift
//  FinalProject
//
//  Created by Yuta Sasaki  on 2024/07/01.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct otamesi2: View {
    @State var users:[String] = ["user1","user2","user3","user4"]
    @State var images:[String] = ["unknown1","unknown2","unknown3","unknown4"]
    @State var userImages:[UIImage?] = []
    @State var getUserIds:[Int?] = []
    @State var userIds:[Int] = [1,2,3,4]
    
    
    var body: some View {
        HStack{
            VStack{
                ForEach(users,id:\.self){ user in
                    Spacer()
                    Text(user)
                    Spacer()
                }
            }
            .frame(height: 500)
            VStack{
                ForEach(images,id:\.self){ image in
                    Spacer()
                    Image(uiImage:UIImage(named: image)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white,lineWidth: 4))
                        .shadow(radius: 10)
                    Spacer()
                }
            }
            .frame(height: 500)
            VStack{
                ForEach(getUserIds,id:\.self){ num in
                    Spacer()
                    Text("firebase\(String(num!))")
                    Spacer()
                    }
                }
            .frame(height: 500)
            VStack{
                ForEach(userImages,id:\.self){ image in
                    Spacer()
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white,lineWidth: 4))
                        .shadow(radius: 10)
                    Spacer()
                }
            }
            .frame(height: 500)
        }
        .onAppear(){
            fetchImage()
        }
    }
    
    func fetchImage(){
        getUserIds = []
        userImages = []
        self.userIds.forEach{id in
            let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
            storageref.getData(maxSize: 4 * 1024 * 1024){ (data,error) in
                if let error = error{
                    print("Got an error fetching data: \(error.localizedDescription)")
                    return
                }
                if let data = data{
                    self.getUserIds.append(id)
                    print(getUserIds)
                    self.userImages.append(
                        UIImage(data:data)
                    )
                    
                }
            }
        }
    }
}



#Preview {
    otamesi2()
}
