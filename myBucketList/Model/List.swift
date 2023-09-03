//
//  List.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/9/2.
//

import Foundation

struct List: Codable {
    var title: String?
    var uuid: String
    var content: [Target] = []
    
    static func saveList(list: [List]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(list) else {return}
        UserDefaults.standard.set(data, forKey: "lists")
        
        if let dataString = String(data: data, encoding: .utf8) {
            print("*struct",dataString)
        }
    }
    
    static func saveContent(content: List,uuid: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(content) else {return}
        UserDefaults.standard.set(data, forKey: "list\(uuid)")
    }
}
