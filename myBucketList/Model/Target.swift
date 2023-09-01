//
//  Target.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/27.
//

import Foundation

struct List: Codable {
    var title: String?
    var content: [Target] = []
    
    static func saveList(list: [List]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(list) else {return}
        UserDefaults.standard.set(data, forKey: "lists")
        
        if let dataString = String(data: data, encoding: .utf8) {
            print("******struct",dataString)
        }
    }
    
    
    static func saveListContent(list: [List],index: Int) {
        //        let encoder = JSONEncoder()
        //        guard let data = try? encoder.encode(list) else {return}
        //        UserDefaults.standard.set(data, forKey: "lists\(index)")
        //
        //        if let dataString = String(data: data, encoding: .utf8) {
        //            print("******structForContent",dataString)
        //        }
        //    }
        
    }
}
    
    struct Target: Codable {
        var name: String?
        var status: Bool
        var remarks: String?
        var imageName: String?
        
        //    static func saveTarget(target: [Target]) {
        //        let encoder = JSONEncoder()
        //        guard let data = try? encoder.encode(target) else {return}
        //        UserDefaults.standard.set(data, forKey: "targets")
        //    }
        //
        //    static func loadTarget() -> [Target]? {
        //        let decoder = JSONDecoder()
        //        let userDefaults = UserDefaults.standard
        //        guard let data = userDefaults.data(forKey: "targets")
        //        else { return nil }
        //        return try? decoder.decode([Target].self, from: data)
        //
        //    }
    }
    
    
    //static func saveListContent(listContent: List) {
    //    let encoder = JSONEncoder()
    //    guard let data = try? encoder.encode(listContent) else {return}
    //    UserDefaults.standard.set(data, forKey: "listContent")
    //}
    //
    //static func loadListContent() -> List? {
    //    let decoder = JSONDecoder()
    //    guard let data = UserDefaults.standard.data(forKey: "listContent") else {return nil}
    //    return try? decoder.decode(List.self, from: data)
    //
    //}

