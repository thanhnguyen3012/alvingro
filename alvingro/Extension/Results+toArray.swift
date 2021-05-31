//
//  Realm+toArray.swift
//  alvingro
//
//  Created by Thành Nguyên on 30/05/2021.
//

import UIKit
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

