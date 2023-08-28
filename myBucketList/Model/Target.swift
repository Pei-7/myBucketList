//
//  Target.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/27.
//

import Foundation

struct Target: Codable {
    var name: String?
    var status: Bool
    var remarks: String?
    var imageName: String?
    
    static func saveTarget(target: [Target]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(target) else {return}
        UserDefaults.standard.set(data, forKey: "targets")
        
        if let dataString = String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
    
    static func loadTarget() -> [Target]? {
        let decoder = JSONDecoder()
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "targets")
        else { return nil }
        return try? decoder.decode([Target].self, from: data)

    }
}
