//
//  Car.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

struct Car: Codable {
    
    enum BodyType: String, Codable, CaseIterable {
        case buggy = "Buggy"
        case convertible = "Convertible"
        case coupe = "Coupé"
        case flowerCar = "Flower car"
        case hatchback = "Hatchback"
        case hearse = "Hearse"
        case kombi = "Kombi"
        case limousine = "Limousine"
        case microvan = "Microvan"
        case minivan = "Minivan"
        case panelVan = "Panel van"
        case pickupTruck = "Pickup truck"
        case roadster = "Roadster"
        case sedan = "Sedan"
        case shootingBrake = "Shooting-brake"
        case stationWagon = "Station wagon"
        case targaTop = "Targa top"
        case ute = "Ute"
    }
    
    private var cteatedAt: TimeInterval
    
    var yearOfIssue: Int
    var manufacturer: String
    var model: String
    var bodyType: BodyType
    var description: String
    
    init(yearOfIssue: Int = 2000, manufacturer: String = "", model: String = "", bodyType: BodyType = .sedan, description: String = "") {
        
        self.cteatedAt = Date().timeIntervalSince1970
        
        self.yearOfIssue = yearOfIssue
        self.manufacturer = manufacturer
        self.model = model
        self.bodyType = bodyType
        self.description = description
    }
    
}

extension Car: Comparable {
    
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.manufacturer == rhs.manufacturer
    }
    
    static func < (lhs: Car, rhs: Car) -> Bool {
        lhs.manufacturer < rhs.manufacturer
    }
    
}
