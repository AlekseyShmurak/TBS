//
//  CharacterView.swift
//  TBS
//
//  Created by Aleksey Shmurak on 04.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import UIKit

class CharacterView: UIView {
    
    var view: UIView!
    var label: UILabel!
    let character: Character!
    
    init (x: Int, y: Int, side: Int, character: Character, fieldView: FieldView){
        self.character = character
        super.init(frame: CGRect(x: x, y: y, width: side , height: side))
        self.userInteractionEnabled = false
        self.view = self
        self.center = fieldView.center
        self.layer.cornerRadius = CGFloat( side/2)
        if self.character.team == Team.One{
            self.backgroundColor = UIColor.blueColor()
        }else{
            self.backgroundColor = UIColor.redColor()
        }
        self.label = UILabel(frame: CGRect(x: 5, y: 0, width: side, height: side))
        self.label.text = "\(self.character.damage)/\(self.character.healt)"
        self.label.adjustsFontSizeToFitWidth = true
        self.label.textColor = UIColor.whiteColor()
        self.view.addSubview(self.label)
    }
    
    func activate(){
        self.character.isActive = true
        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2)
    }
    func deactivate(){
        self.character.isActive = false
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








