//
//  BoardView.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var boardToDraw: Board
    var fieldViews: [Array<FieldView>] = []
    var characters: [CharacterView] = []
    var openedFieldViews: [FieldView] = []
    var activeCharacter: CharacterView?
    
    init(boardToDraw: Board, fieldSideSize: Int){
        
        self.boardToDraw = boardToDraw
        
        super.init(frame: CGRect(x: 0, y: 0, width: (fieldSideSize+2)*boardToDraw.field.count + 2, height: (fieldSideSize+2)*boardToDraw.field.count + 2))
        
        for numberOfFieldsOnX in 0..<boardToDraw.field.count{
            self.fieldViews.append([])
            for numberOfFieldsOnY in 0..<boardToDraw.field[0].count{
                
                let fieldView = FieldView(x: 2+((2+fieldSideSize)*numberOfFieldsOnX), y: 2+((2+fieldSideSize)*numberOfFieldsOnY), side: fieldSideSize, field: boardToDraw.field[numberOfFieldsOnX][numberOfFieldsOnY],handler: handleFieldViewTap)
                
                self.addSubview(fieldView)
                self.fieldViews[numberOfFieldsOnX].append(fieldView)
            }
        }
    }
    
    func handleFieldViewTap(){
        if activeCharacter != nil && FieldView.activeFieldView!.field.isOpened{
            openedFieldTap()
        }else if FieldView.activeFieldView!.field.isOccupide{
            for character in characters{
                if character.character.coordinate == FieldView.activeFieldView!.field.coordinate{
                    if character.character.isActive{
                        character.deactivate()
                        activeCharacter = nil
                        closeAllOpenedFieldViews()
                    }else if activeCharacter != nil && activeCharacter!.character.team != character.character.team{
                        activeCharacter!.character.attack(character.character)
                        character.label.text = "\(character.character.damage)/\(character.character.healt)"
                        print("attack")
                    }else if activeCharacter != nil{
                        activeCharacter!.deactivate()
                        closeAllOpenedFieldViews()
                        character.activate()
                        activeCharacter = character
                        scanFieldsToMoveCharacter(activeCharacter!)
                    }else if activeCharacter == nil{
                        character.activate()
                        activeCharacter = character
                        scanFieldsToMoveCharacter(activeCharacter!)
                    }
                }
            }
        }
    
    }
    
    
   
    func addCharacter(x: Int, y: Int, team: Team){
        let charView = CharacterView(x: x, y: y, side: 43, character: self.boardToDraw.addCharacter(x, y: y, team: team), fieldView: fieldViews[x][y])
        occupideField(fieldViews[x][y])
        self.characters.append(charView)
        self.addSubview(charView)
    }
    
    //------------------------------------------------------------------------

    func scanFieldsToMoveCharacter(character: CharacterView){
        var tempFieldViews: [Double:Array<FieldView>] = [:]
        var stepsLeft = character.character.speed
        var step = 1.0
    
        tempFieldViews[step] = openFieldsOneStepFromCoodinates(character.character.coordinate)
        for field in tempFieldViews[step]!{
            openedFieldViews.append(field)}
        stepsLeft -= 1
        if stepsLeft != 0{
            tempFieldViews[step+0.5] = openFieldsOneAndHalfStepFromCoodinates(character.character.coordinate)
            for field in tempFieldViews[step+0.5]!{
                openedFieldViews.append(field)}
        }
    
        while stepsLeft != 0 {
            if tempFieldViews[step+1] != nil{
                tempFieldViews[step+1]?.appendContentsOf(self.openFieldsOneStepFromArray(tempFieldViews[step]!))
            }else{
                tempFieldViews[step+1] = self.openFieldsOneStepFromArray(tempFieldViews[step]!)
            }
            for field in tempFieldViews[step+1]!{
                openedFieldViews.append(field)}
            stepsLeft -= 1
            if stepsLeft != 0{
                tempFieldViews[step+1.5] = openFieldsOneAndHalfStepFromArray(tempFieldViews[step]!)
                tempFieldViews[step+1.5]?.appendContentsOf(openFieldsOneStepFromArray(tempFieldViews[step+0.5]!))
                for field in tempFieldViews[step+1.5]!{
                    openedFieldViews.append(field)}
                tempFieldViews[step+2] = openFieldsOneAndHalfStepFromArray(tempFieldViews[step+0.5]!)
                for field in tempFieldViews[step+2]!{
                    openedFieldViews.append(field)}
            }
            step += 1

        }
    }
 
    //------------------------------------------------------------------------

    
    func openFieldsOneStepFromArray(inputArray:Array<FieldView>)->(Array<FieldView>){
        var outputArray:Array<FieldView> = []
        
        func openAndAddFieldView(x: Int, y: Int){
            if !fieldViews[x][y].field.isOccupide && !fieldViews[x][y].field.isOpened{
                fieldViews[x][y].open()
                outputArray.append(fieldViews[x][y])
            }
        }
        
        for field in inputArray{
            let x = field.field.coordinate.x
            let y = field.field.coordinate.y
            
            if  x+1 < fieldViews.count{
                openAndAddFieldView(x+1, y: y)
            }
            if x-1 >= 0 {
                openAndAddFieldView(x-1, y: y)
            }
            if y+1 < fieldViews[0].count{
                openAndAddFieldView(x, y: y+1)
            }
            if y-1 >= 0{
                openAndAddFieldView(x, y: y-1)
            }
        }
        return outputArray
    }
    //------------------------------------------------------------------------
    
    
    func openFieldsOneAndHalfStepFromArray(inputArray:Array<FieldView>)->(Array<FieldView>){
        var outputArray:Array<FieldView> = []
        
        func openAndAddFieldView(x: Int, y: Int){
            if !fieldViews[x][y].field.isOccupide && !fieldViews[x][y].field.isOpened{
                fieldViews[x][y].open()
                outputArray.append(fieldViews[x][y])
            }
        }
        
        for field in inputArray{
            let x = field.field.coordinate.x
            let y = field.field.coordinate.y
            
            if  x+1 < fieldViews.count && y+1 < fieldViews[0].count{
                openAndAddFieldView(x+1, y: y+1)
            }
            if x-1 >= 0 && y+1 < fieldViews[0].count{
                openAndAddFieldView(x-1, y: y+1)
            }
            if x+1 < fieldViews.count && y-1 >= 0{
                openAndAddFieldView(x+1, y: y-1)
            }
            if x-1 >= 0 && y-1 >= 0{
                openAndAddFieldView(x-1, y: y-1)
            }
        }
        return outputArray
    }
    
//------------------------------------------------------------------------
    
    func openFieldsOneStepFromCoodinates(coordinate: (x: Int, y: Int))->(Array<FieldView>){
        let x = coordinate.x
        let y = coordinate.y
        var outputArray:Array<FieldView> = []
        
        func openAndAddFieldView(x: Int, y: Int){
            if !fieldViews[x][y].field.isOccupide && !fieldViews[x][y].field.isOpened{
                fieldViews[x][y].open()
                outputArray.append(fieldViews[x][y])
            }
        }
        
        if  x+1 < fieldViews.count{
            openAndAddFieldView(x+1, y: y)
        }
        if x-1 >= 0 {
            openAndAddFieldView(x-1, y: y)
        }
        if y+1 < fieldViews[0].count{
            openAndAddFieldView(x, y: y+1)
        }
        if y-1 >= 0{
            openAndAddFieldView(x, y: y-1)
        }
        
        return outputArray
    }
    
    //------------------------------------------------------------------------
    
    func openFieldsOneAndHalfStepFromCoodinates(coordinate: (x: Int, y: Int))->(Array<FieldView>){
        let x = coordinate.x
        let y = coordinate.y
        var outputArray:Array<FieldView> = []
        
        func openAndAddFieldView(x: Int, y: Int){
            if !fieldViews[x][y].field.isOccupide && !fieldViews[x][y].field.isOpened{
                fieldViews[x][y].open()
                outputArray.append(fieldViews[x][y])
            }
        }
        
        if  x+1 < fieldViews.count && y+1 < fieldViews[0].count{
            openAndAddFieldView(x+1, y: y+1)
        }
        if x-1 >= 0 && y+1 < fieldViews[0].count{
            openAndAddFieldView(x-1, y: y+1)
        }
        if x+1 < fieldViews.count && y-1 >= 0{
            openAndAddFieldView(x+1, y: y-1)
        }
        if x-1 >= 0 && y-1 >= 0{
            openAndAddFieldView(x-1, y: y-1)
        }
        
        return outputArray
    }
    
    //------------------------------------------------------------------------

    func scanFieldsToMeleeAttack(coordinate: (x: Int, y: Int))->(Array<FieldView>){
        let x = coordinate.x
        let y = coordinate.y
        var outputArray:Array<FieldView> = []
        
        func openAndAddFieldView(x: Int, y: Int){
            if !fieldViews[x][y].field.isOccupide && fieldViews[x][y].field.isOpened{
                fieldViews[x][y].field.isOpenedToMeleeAttack = true
                fieldViews[x][y].backgroundColor = UIColor.greenColor()
                outputArray.append(fieldViews[x][y])
            }
        }
        if  x+1 < fieldViews.count{
            openAndAddFieldView(x+1, y: y)
        }
        if x-1 >= 0 {
            openAndAddFieldView(x-1, y: y)
        }
        if y+1 < fieldViews[0].count{
            openAndAddFieldView(x, y: y+1)
        }
        if y-1 >= 0{
            openAndAddFieldView(x, y: y-1)
        }
        if  x+1 < fieldViews.count && y+1 < fieldViews[0].count{
            openAndAddFieldView(x+1, y: y+1)
        }
        if x-1 >= 0 && y+1 < fieldViews[0].count{
            openAndAddFieldView(x-1, y: y+1)
        }
        if x+1 < fieldViews.count && y-1 >= 0{
            openAndAddFieldView(x+1, y: y-1)
        }
        if x-1 >= 0 && y-1 >= 0{
            openAndAddFieldView(x-1, y: y-1)
        }
        
        return outputArray
    }
    
    //------------------------------------------------------------------------

    func closeAllOpenedFieldViews(){
        for field in openedFieldViews{
            field.close()
        }
        openedFieldViews = []
    }
    
    //------------------------------------------------------------------------

    func occupideField(field: FieldView){
        field.field.isOccupide = true
    }
    
    //------------------------------------------------------------------------

    func leaveField(field: FieldView){
        field.field.isOccupide = false
    }
    //-------------------------------------------------------------------------
    
    func openedFieldTap(){
        if FieldView.activeFieldView!.field.isSelected{
            leaveField(fieldViews[activeCharacter!.character.coordinate.x][activeCharacter!.character.coordinate.y])
            UIView.animateWithDuration(0.5, animations: {
                self.activeCharacter!.center = FieldView.activeFieldView!.center
                }, completion: {(Bool) in
                    print("move")
                    self.scanFieldsToMoveCharacter(self.activeCharacter!)
            })
            for field in self.openedFieldViews{
                field.deselect()
            }
            closeAllOpenedFieldViews()
            occupideField(FieldView.activeFieldView!)
            activeCharacter!.character.coordinate = (FieldView.activeFieldView?.field.coordinate)!
        }else{
            for field in self.openedFieldViews{
                field.deselect()
            }
            FieldView.activeFieldView!.select()
        }
        
    }
    
    //--------------------------------------------------------------------------

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









