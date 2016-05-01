//
//  Character.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import UIKit

class Character{
    var coordinate = (x: Int(), y: Int())
    let speed = 3
    var isActive = false
    let team: Team
    var damage = 5
    var healt = 10
    
    
    
    init(x: Int, y: Int, team: Team){
        self.team = team
        self.coordinate.x = x
        self.coordinate.y = y
    }
    
    func attack(character: Character){
        character.healt = character.healt - self.damage
    }
    
}

enum Team{
    case One
    case Two
}
