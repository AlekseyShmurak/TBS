//
//  Field.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import Foundation

class Field {
    var coordinate = (x: Int(), y: Int())
    var isOccupide = false
    var isOpened = false
    var isSelected = false
    var isOpenedToMeleeAttack = false
    
    init (x: Int, y: Int){
        self.coordinate.x = x
        self.coordinate.y = y
        
    }
}
