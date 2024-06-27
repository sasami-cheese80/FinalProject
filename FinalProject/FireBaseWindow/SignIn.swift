import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: FirebaseModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Sign In") {
                    viewModel.signIn(email: email, password: password)
                }

                if viewModel.isAuthenticated {
                    // ログイン後のページに遷移
                    ContentView(viewModel: FirebaseModel())
                }
                // 新規登録画面への遷移ボタン
                NavigationLink(destination: SignUp(viewModel: viewModel)) {
                    Text("Create Account")
                        .padding(.top, 16)
                }
                }
            }
        }
    }

