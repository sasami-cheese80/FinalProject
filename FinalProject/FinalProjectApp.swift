//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by sakaguchi on 2024/06/24.
//
//
//import SwiftUI
//
//@main
//struct FinalProjectApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


import SwiftUI
import Firebase
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FinalProjectApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var viewModel = FirebaseModel()



  var body: some Scene {
    WindowGroup {
        // ログイン状態によって画面遷移するページを変更する
        if viewModel.isAuthenticated && viewModel.userId != nil {
            ContentView(viewModel: viewModel)
        }else if viewModel.isSignedUp{
            CreateProfile(viewModel: viewModel)

        } else {
            SignIn(viewModel: viewModel)
        }
    }
  }
}
