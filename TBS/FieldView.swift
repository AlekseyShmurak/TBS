//
//  FieldView.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import UIKit


class FieldView: UIView{
    
    static var activeFieldView: FieldView?
    
    let field: Field!
    var tapGesture: UITapGestureRecognizer!
    var handler: ()->()!
    var stateView: UIView!
    
    init (x: Int, y: Int, side: Int, field: Field, handler:()->()){
        self.handler = handler
        self.field = field
        super.init(frame: CGRect(x: x, y: y, width: side , height: side))
        self.backgroundColor = UIColor.grayColor()
        let view = UIView(frame: CGRect(x: 1, y: 1, width: side-2, height: side-2))
        view.backgroundColor = UIColor.whiteColor()
        self.stateView = view
        self.addSubview(view)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action:#selector(FieldView.handlerTapGesture))

        self.addGestureRecognizer(self.tapGesture)

    }
    
    func handlerTapGesture(){
        FieldView.activeFieldView = self
        self.handler()
        FieldView.activeFieldView = nil
    }
    
    func open(){
        if !self.field.isOccupide{
            self.field.isOpened = true
            self.stateView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
    }
    
    func close(){
        self.field.isOpened = false
        self.stateView.backgroundColor = UIColor.whiteColor()
    }
    
    func select() {
        self.field.isSelected = true
        self.stateView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
    }
    
    func deselect(){
        self.field.isSelected = false
        self.open()
    }
    

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}









