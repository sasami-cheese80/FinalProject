import SwiftUI

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: FirebaseModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                viewModel.signUp(email: email, password: password)
            }

            if viewModel.isAuthenticated {
                // ログイン後のページに遷移
                if viewModel.isAuthenticated {
//                    HelloPage(viewModel: viewModel)
                    ContentView(viewModel: FirebaseModel())
                }

            }
        }
    }
}
