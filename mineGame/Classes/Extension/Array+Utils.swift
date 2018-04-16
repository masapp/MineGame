//
//  Array+Utils.swift
//  mineGame
//
//  Created by masapp on 2018/04/16.
//  Copyright © 2018 masapp. All rights reserved.
//

extension Array where Element: ExpressibleByArrayLiteral {
    
    private mutating func append(to i: Int) {
        while self.count <= i {
            self.append([])
        }
    }
    
    subscript(autoAppendTo i: Int) -> Element {
        mutating get {
            self.append(to: i)
            return self[i]
        }
        set {
            self.append(to: i)
            self[i] = newValue
        }
    }
}
