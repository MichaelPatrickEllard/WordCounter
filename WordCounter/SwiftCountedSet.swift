//
//  SwiftCountedSet.swift
//  WordCountWizard
//
//  Created by Rescue Mission Software on 11/10/14.
//  Copyright (c) 2014 Rescue Mission Software. All rights reserved.
//

//  Limitations:  If we exceed the number of items in an integer, we're going to be sorry...

import UIKit

class SwiftCountedSet<T: Hashable> {
    
    private var dataDictionary = [T : Int]()
    
    var allObjects: [T] {
        return [T](dataDictionary.keys)
    }
    
    func countForObject(object: T) -> Int {
        
        var rawCount: Int?
        
        //  The autorelease pool reduces the peak memory usage, but the total memory allocated is still much greater with this approach. 
        
        autoreleasepool {
        
            rawCount = self.dataDictionary[object]
        }
        
        return rawCount == nil ? 0 : rawCount!
    }
    
    func addObject(object : T) {
        
        var currentCount = dataDictionary[object]
        
        if currentCount == nil {
            dataDictionary[object] = 1
        } else {
            dataDictionary[object] = ++currentCount!
        }
    }
}
