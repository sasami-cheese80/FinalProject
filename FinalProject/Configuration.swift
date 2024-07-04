//
//  Configuration.swift
//  FinalProject
//
//  Created by Yuta Sasaki  on 2024/07/04.
//

import Foundation

struct Configuration {
    static let shared = Configuration()

    private let config: [AnyHashable: Any] = {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        return plist["AppConfig"] as! [AnyHashable: Any]
    }()

    let apiUrl: String

    private init() {
        apiUrl = config["ApiUrl"] as! String
    }
}
