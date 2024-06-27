import SwiftUI
import FirebaseAuth

class FirebaseModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var uid: String? = nil // UIDを保存するプロパティ
    // イニシャライザメソッドを呼び出して、アプリの起動時に認証状態をチェックする
    init() {
            observeAuthChanges()
        }

        private func observeAuthChanges() {
            Auth.auth().addStateDidChangeListener { [weak self] _, user in
                DispatchQueue.main.async {
                    if let user = user {
                        self?.isAuthenticated = true
                        self?.uid = user.uid
                    } else {
                        self?.isAuthenticated = false
                        self?.uid = nil
                    }
                }
            }
        }
    // ログインするメソッド
    func signIn(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let user = result?.user, error == nil {
                        self?.isAuthenticated = true
                        self?.uid = user.uid // UIDを保存
                    }
                }
            }
        }
    // 新規登録するメソッド
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let user = result?.user, error == nil {
                    self?.isAuthenticated = true
                    self?.uid = user.uid // UIDを保存
                }
            }
        }
    }
    // ログアウトするメソッド
    func signOut() {
            do {
                try Auth.auth().signOut()
                isAuthenticated = false
                uid = nil
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
}
