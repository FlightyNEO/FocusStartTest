//
//  DataManager.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

struct DataManager {
    private init() { }
    
    private struct Path {
        private init() { }
        
        static var component = "cars_Dictionary"
        static var `extension` = "plist"
    }
    
    private static var url: URL {
        let documentDerictory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDerictory.appendingPathComponent(Path.component).appendingPathExtension(Path.extension)
        
        return archiveURL
    }
    
    enum DataManagerError: Error {
        case canNotFetchCars(message: String)
    }
    
    static func writeCarsDictionary() throws {
        try reWriteCars(Cars.loadSample())
    }
    
    static func fetchCars() throws -> Cars {
        
        do {
            let data = try Data(contentsOf: url)
            guard let cars = Cars(from: data) else { throw DataManagerError.canNotFetchCars(message: "Can't fetch cars from derictory")}
            return cars
        } catch let error {
            throw error
        }
        
    }
    
    static func reWriteCars(_ cars: Cars) throws {
        
        guard let data = cars.encoded else { return }
        
        try data.write(to: url, options: .noFileProtection)
        
    }
    
}
