//
//  Task.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Task {
    var id: String
    var title: String?
    var memo: String?
    var coordinate: GeoPoint?
    var createAt: Timestamp
    var updateAt: Timestamp
    
    init(id: String, value: [String: Any?]) {
        self.id = id
        self.title = value["title"] as? String ?? nil
        self.memo = value["memo"] as? String ?? nil
        self.coordinate = value["coordinate"] as? GeoPoint ?? nil
        self.createAt = value["create_at"] as? Timestamp ?? Timestamp(date: Date())
        self.updateAt = value["update_at"] as? Timestamp ?? Timestamp(date: Date())
    }
    
//    var latitude: Double?
//    var longitude: Double?
    
    init(id: String, value: [String: Any?]) {
        self.id = id
        self.title = value["title"] as? String ?? nil
        self.memo = value["memo"] as? String ?? nil
        self.coordinate = value["coordinate"] as? GeoPoint ?? nil
        self.createAt = value["create_at"] as? Timestamp ?? Timestamp(date: Date())
        self.updateAt = value["update_at"] as? Timestamp ?? Timestamp(date: Date())
    }
    //5-2
    func toValueDict() -> [String: Any] {
        return [
            "title": self.title as Any,
            "memo": self.memo as Any,
            "coordinate": self.coordinate as Any,
            "create_at": self.createAt,
            "update_at": self.updateAt,
        ]
    }
}

