//
//  DrawingView.swift
//  MemeMe
//
//  Created by Nora on 11/20/15.
//  Copyright © 2015 Nora. All rights reserved.
//

//
//  ViewController.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    //var board: Board
    
    //@IBOutlet var undoButton: UIButton!
    //@IBOutlet var redoButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        
        let board = Board(frame: frame)
        
        
        board.brush = PencilBrush()
        
        print("DrawingView init")
        board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state != .Moved {
                print("here")
                UIView.beginAnimations(nil, context: nil)
                /*if state == .Began {
                
                
                self.undoButton.alpha = 0
                self.redoButton.alpha = 0
                } else if state == .Ended {
                UIView.setAnimationDelay(1.0)
                self.undoButton.alpha = 1
                self.redoButton.alpha = 1
                }*/
                UIView.commitAnimations()
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /*@IBAction func undo(sender: UIButton) {
        self.board.undo()
    }
    
    @IBAction func redo(sneder: UIButton) {
        self.board.redo()
    }
    */
    
    
}


