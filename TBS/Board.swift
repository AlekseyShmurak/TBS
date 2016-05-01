//
//  Board.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import Foundation

class Board {
    var field:[Array<Field>] = []
    var chararcters: Array<Character> = []
    
    init (numberOfFieldsOnX x: Int, numberOfFieldsOnY y: Int){
        for x in 0..<x{
            self.field.append([])
            for y in 0..<y{
                self.field[x].append(Field(x: x, y: y))
            }
        }
    }
//MARK: temp
    func addCharacter(x: Int, y: Int, team: Team)->(Character){
        let char = Character(x: x, y: y, team: team)
        self.chararcters.append(char)
        return char
    }
}