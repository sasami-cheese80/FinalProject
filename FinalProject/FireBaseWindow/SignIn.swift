import SwiftUI

struct SignIn: View {
    @ObservedObject var viewModel: FirebaseModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    //テキストフィールドのフォーカス(borderの色変える)用
    @FocusState var focusedEmail: Bool
    @FocusState var focusedPass: Bool
    //password表示非表示用
    @State var passHidden = true
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.customlightGray
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("ログイン")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top, 120)
                        .padding(.bottom, 100)
                        .foregroundColor(Color.customTextColor)
                    
                    //email-----------------------------------------------------------------
                    TextField("Email", text: $email)
                        .frame(width: 300,height: 56, alignment: .center)
                        .padding(.horizontal, 16)
                        .background(.white)
                        .cornerRadius(12)
                        .accentColor(Color.customTextColor)
                        .foregroundColor(Color.customTextColor)
                        .focused($focusedEmail)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(focusedEmail ? Color.customTextColor.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
                        }.onTapGesture {
                            focusedEmail = true
                        }
                        .padding()
                    //email-----------------------------------------------------------------
                    
                    //password--------------------------------------------------------------
                    ZStack {
                        HStack {
                            if self.passHidden {
                                // 非表示
                                SecureField("password", text: self.$password)
                                    .frame(width: 300, height: 56, alignment: .center)
                                    .padding(.horizontal, 16)
                                    .background(.white)
                                    .cornerRadius(12)
                                    .accentColor(Color.customTextColor)
                                    .foregroundColor(Color.customTextColor)
                                    .focused($focusedPass)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(focusedPass ? Color.customTextColor.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
                                    }.onTapGesture {
                                        focusedPass = true
                                    }
                                    .frame(width: 300, height: 56, alignment: .center)
                                    .offset(x: 15, y:0)
                                    .padding()
                                
                            } else {
                                // 表示
                                TextField("password", text: self.$password)
                                    .frame(width: 300,height: 56, alignment: .center)
                                    .padding(.horizontal, 16)
                                    .background(.white)
                                    .cornerRadius(12)
                                    .accentColor(Color.customTextColor)
                                    .foregroundColor(Color.customTextColor)
                                    .focused($focusedPass)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(focusedPass ? Color.customTextColor.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
                                    }.onTapGesture {
                                        focusedPass = true
                                    }
                                    .frame(width: 300, height: 56, alignment: .center)
                                    .offset(x: 15, y:0)
                                    .padding()
                            }
                            
                            Button(action: {self.passHidden.toggle() }) {
                                Image(systemName: self.passHidden ? "eye.slash.fill": "eye.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                                    .foregroundColor((self.passHidden == true) ? Color.secondary : Color.gray)
                            }
                            .offset(x: -32, y:0)
                        }
                    }
                    //password--------------------------------------------------------------
                    
                    //エラー文表示-----------------------------------
                    if let errorMessage = viewModel.errorMessage{
                        Text("※\(errorMessage)")
                            .foregroundColor(.red)
                    }else {
                        Text(" ")
                    }
                    //エラー文表示-----------------------------------
                    
                    //button------------------------------------------------
                    Button(action: {
                        viewModel.signIn(email: email, password: password)
                    }) {
                        Text("ログイン")
                            .frame(width: 300, height: 50)
                            .background(Color.customMainColor)
                            .foregroundColor(Color.customTextColor)
                            .fontWeight(.semibold)
                            .cornerRadius(24)
                    }
                    .padding(.top, 50)
                    //button------------------------------------------------
                    
                    if viewModel.isAuthenticated  && viewModel.userId != nil {
                        // ログイン後のページに遷移
                        ContentView(viewModel:viewModel)
                    }
                    // 新規登録画面への遷移ボタン
                    NavigationLink(destination: SignUp(viewModel: viewModel)) {
                        Text("新規登録はこちら")
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.customTextColor)
                            .fontWeight(.semibold)
                            .background(.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.customMainColor, lineWidth: 1.0)
                            )
                    }
                    .padding(.top,30)
                    .accentColor(Color.customTextColor)
                    
                    Spacer()
                }
                
            }

            .accentColor(Color.customTextColor)
            .onAppear {
                       viewModel.errorMessage = nil
                   }
        }
    }
}


