//
//  Cars.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

typealias Cars = [Car]

extension Cars {
    
    var title: String {
        return "Car's list"
    }
    
    static func loadSample() -> Cars {
        
        return [
            Car(yearOfIssue: 2002, manufacturer: "BMW", model: "Z4", bodyType: .coupe, description: "Выпускается в настоящее время (2019)"),
            Car(yearOfIssue: 1995, manufacturer: "Mercedes-Benz", model: "W210", bodyType: .sedan, description: "Год окончания производства - 2002. Длиное описание на несколько строк, для проверки адаптивной высоты у ячейки"),
            Car(yearOfIssue: 1988, manufacturer: "Opel", model: "Vectra", bodyType: .sedan, description: "Год окончания производства - 2008")
        ].sorted()
        
    }
    
}

// MARK: - Codable
extension Cars {
    
    init?(from data: Data) {
        guard let cars = try? PropertyListDecoder().decode(Cars.self, from: data) else { return nil }
        
        self = cars
    }
    
    var encoded: Data? {
        try? PropertyListEncoder().encode(self)
    }
    
}

