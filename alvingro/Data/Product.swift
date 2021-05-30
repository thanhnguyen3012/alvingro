//
//  Product.swift
//  alvingro
//
//  Created by Thành Nguyên on 20/05/2021.
//

import Foundation
import Firebase

class Product: Codable {
    dynamic var id: String?
    dynamic var photos: [String]?
    dynamic var name: String?
    dynamic var amount: Int?
    dynamic var price: Float?
    dynamic var unit: String?
    dynamic var details: String?
    dynamic var nutrition: [String]?
    dynamic var rate: Float?
    dynamic var categories: [String]?
    dynamic var brand: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photos
        case name
        case amount
        case price
        case unit
        case details
        case nutrition
        case rate
        case categories
        case brand
    }
    
    init(id: String?, photos: [String]?, name: String?, amount: Int?, price: Float?, unit: String?, details: String?, nutrition: [String]?, rate: Float?, categories: [String]?, brand: String?) {
        self.id = id
        self.photos = photos
        self.name = name
        self.amount = amount
        self.price = price
        self.unit = unit
        self.details = details
        self.nutrition = nutrition
        self.rate = rate
        self.categories = categories
        self.brand = brand
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        self.id = snapshot.documentID
        self.photos = snapshot.get("photos") as? [String]
        self.name = snapshot.get("name") as? String
        self.amount = snapshot.get("amount") as? Int
        self.price = snapshot.get("price") as? Float
        self.unit = snapshot.get("unit") as? String
        self.details = snapshot.get("details") as? String
        self.nutrition = snapshot.get("nutrition") as? [String]
        self.rate = snapshot.get("rate") as? Float
        self.categories = snapshot.get("categories") as? [String]
        self.brand = snapshot.get("brand") as? String
    }
}
