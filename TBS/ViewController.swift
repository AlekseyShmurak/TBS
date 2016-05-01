//
//  ViewController.swift
//  TBS
//
//  Created by Aleksey Shmurak on 03.04.16.
//  Copyright © 2016 Aleksey Shmurak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var testBoard: BoardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testBoard = Board(numberOfFieldsOnX: 8, numberOfFieldsOnY: 8)
        let testBoardView = BoardView(boardToDraw: testBoard, fieldSideSize: 45)
       
        testBoardView.addCharacter(0, y: 0, team: .One)
        testBoardView.addCharacter(7, y: 7, team: .Two)
        testBoardView.addCharacter(0, y: 7, team: .Two)
        testBoardView.addCharacter(7, y: 0, team: .One)
        self.testBoard = testBoardView


        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.testBoard.center = self.view.center

        self.view.addSubview(self.testBoard)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

