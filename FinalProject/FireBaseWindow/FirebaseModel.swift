import SwiftUI
import FirebaseAuth
import Combine

struct UserId: Codable{
    let id: Int
}

class FirebaseModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var uid: String? = nil // UIDを保存するプロパティ
    @Published var errorMessage: String? = nil // エラーメッセージを保存するプロパティ
    @Published var userId: Int? = nil //GETした情報を保存するプロパ
    
    
    //メールドメインの指定
    let allowedDomain = "mail.toyota.co.jp"
    
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
                        self?.sendGetId(uid: user.uid)
                    } else {
                        self?.isAuthenticated = false
                        self?.uid = nil
                        self?.userId = nil
                    }
                }
            }
        }
    // ログインするメソッド
    func signIn(email: String, password: String) {
        guard isAllowedDomain(email: email) else {
            errorMessage = "このメールドメインは許可されません"
            return
        }
        
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let user = result?.user, error == nil {
                        self?.isAuthenticated = true
                        self?.uid = user.uid // UIDを保存
                        self?.errorMessage = nil
                        self?.sendGetId(uid: user.uid)
                    } else {
                        self?.errorMessage = "メールアドレス又はパスワードが一致しません"
                    }
                }
            }
        }
    // 新規登録するメソッド
    func signUp(email: String, password: String) {
        guard isAllowedDomain(email: email) else {
            errorMessage = "このメールドメインは許可されません"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let user = result?.user, error == nil {
                    self?.isAuthenticated = true
                    self?.uid = user.uid // UIDを保存
                    self?.errorMessage = nil
                }else {
                    self?.errorMessage = error?.localizedDescription
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
    
    //ドメインチェックのメソッド
    private func isAllowedDomain(email: String) -> Bool {
        guard let domain = email.split(separator: "@").last else { return false }
        return domain == allowedDomain
    }
    
    //ユーザーIDをGETする為のメソッド
    private func sendGetId(uid:String){
        guard let url = URL(string: "http://localhost:3000/users/firebase_id/\(uid)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ [weak self] data,response,error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("GET request to \(url) returned status code \(httpResponse.statusCode)")
            }
            
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(UserId.self, from: data)
                    DispatchQueue.main.async {
                        self?.userId = user.id // レスポンスデータを保存
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
}
