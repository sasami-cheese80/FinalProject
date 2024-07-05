//
//  MemberProfile.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/07/02.
//

import SwiftUI

struct MemberProfile: View {
    
    var id: Int
    var name: String
    var nickname: String
    var gender: String
    var department: String
    var division: String
    var hobby: String
    var message: String
    var tags: Array<String>
    
    var body: some View {

            VStack{
                //Icon
                getImage2(id: id, size: 130)
                    .padding(.bottom, 10)
                
                
                Text(name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 5)
                    .foregroundColor(Color.customTextColor)
                Text(nickname)
                    .fontWeight(.medium)
                    .foregroundColor(Color.customTextColor)
                    .padding(.bottom, 40)
                
                HStack{
                    Image(systemName: "figure.baseball")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 20))
                        .foregroundColor(Color.customTextColor)
                    Text(hobby)
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
                    Text(message)
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
                        Text(department)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.medium)
                        Text(division)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(Color.customTextColor)
                }.padding(.bottom, 100)
                
                Tag(alignment: .leading, spacing: 7) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 12)
                            .background(Color.customMainColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                    }

                }
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .frame(maxWidth:.infinity)
            Spacer()
    }
}

struct getImage2: View {
    
    let id: Int
    let size: CGFloat
    @State var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                ZStack{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.7), radius: 3, x: 2, y: 2)
                        .foregroundColor(.white)
                }

                
            } else {
                ProgressView()
                    .frame(width: 90, height: 90)
            }
        }
        .onAppear {
            Task{
                try await fetchImage(fetchId: id) { fetchedImage in
                    if (fetchedImage == nil) {
                        image = UIImage(named: "unknown4.png")
                    } else {
                        self.image = fetchedImage
                    }

                }
            }
        }
    }
}
