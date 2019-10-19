//
//  Array+Extension.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

extension Array {
    
    func insertionIndexOf(_ element: Element, by isOrderedBefore: (Element, Element) -> Bool) -> Int {
        
        var lo = 0
        var hi = count - 1
        
        while lo <= hi {
            let mid = (lo + hi) / 2
            
            if isOrderedBefore(self[mid], element) {
                lo = mid + 1
            } else if isOrderedBefore(element, self[mid]) {
                hi = mid - 1
            } else {
                return mid
            }
        }
        
        return lo
    }
    
    mutating func insert(_ element: Element, by isOrderedBefore: (Element, Element) -> Bool) -> Int {
        let insertionIndex = self.insertionIndexOf(element, by: isOrderedBefore)
        self.insert(element, at: insertionIndex)
        return insertionIndex
    }
    
}
