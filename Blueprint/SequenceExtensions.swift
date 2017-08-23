//
//  SequenceExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

extension Sequence {
    
    public func filter(where isIncluded: (Iterator.Element) -> Bool, limit: Int) -> [Iterator.Element] {
        
        var result : [Iterator.Element] = []
        result.reserveCapacity(limit)
        var count = 0
        var it = makeIterator()
        
        // While limit not reached and there are more elements ...
        while count < limit, let element = it.next() {
            if isIncluded(element) {
                result.append(element)
                count += 1
            }
        }
        return result
    }
    
}
