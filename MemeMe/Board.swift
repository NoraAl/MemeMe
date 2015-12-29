//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////
//Edited to basic functionality by Nora,                                                //
//for the original source, visit: https://github.com/zhangao0086/DrawingBoard           //
//////////////////////////////////////////////////////////////////////////////////////////


import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {
    
    private class DBUndoManager {
        class DBImageFault: UIImage {}
        private static let INVALID_INDEX = -1
        private var images = [UIImage]()
        private var index = INVALID_INDEX
        
        var canUndo: Bool {
            get {
                return index != DBUndoManager.INVALID_INDEX }
        }
        
        func addImage(image: UIImage) {
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            images.append(image)
            index = images.count - 1
        }
        
        func imageForUndo() -> UIImage? {
            if canUndo {
                --index
                if !canUndo {
                    return nil
                } else {
                    return images[index]
                }
            } else {
                return nil
            }
        }
    }
    
    var brush: PencilBrush?
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    var drawingStateChangedBlock: ((state: DrawingState) -> ())?
    private var realImage: UIImage?
    private var boardUndoManager = DBUndoManager()
    private var drawingState: DrawingState!
    
    override init(frame: CGRect) {
        strokeColor = UIColor.blackColor()
        strokeWidth = 2
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        strokeColor = UIColor.blackColor()
        strokeWidth = 2
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public methods
    var canUndo: Bool {
        get {
            return boardUndoManager.canUndo
        }
    }
    
    func undo() {
        if !canUndo {
            return
        }
        image = boardUndoManager.imageForUndo()
        realImage = image
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        backgroundColor?.setFill()
        UIRectFill(bounds)
        self.image?.drawInRect(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - touches methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = brush {
            brush.lastPoint = nil
            brush.beginPoint = touches.first!.locationInView(self)
            brush.endPoint = brush.beginPoint
            drawingState = .Began
            drawingImage()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = brush {
            brush.endPoint = touches.first!.locationInView(self)
            drawingState = .Moved
            drawingImage()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let brush = brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = brush {
            brush.endPoint = touches.first!.locationInView(self)
            drawingState = .Ended
            drawingImage()
        }
    }
    
    // MARK: - drawing
    private func drawingImage() {
        if let brush = brush {
            if let drawingStateChangedBlock = drawingStateChangedBlock {
                drawingStateChangedBlock(state: drawingState)
            }
            
            UIGraphicsBeginImageContext(bounds.size)
            let context = UIGraphicsGetCurrentContext()
            UIColor.clearColor().setFill()
            UIRectFill(bounds)
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, strokeWidth)
            CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
            if let realImage = realImage {
                realImage.drawInRect(bounds)
            }
            brush.strokeWidth = strokeWidth
            brush.drawInContext(context!)
            CGContextStrokePath(context)
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if drawingState == .Ended || brush.supportedContinuousDrawing() {
                realImage = previewImage
            }
            UIGraphicsEndImageContext()
            if drawingState == .Ended {
                boardUndoManager.addImage(image!)
            }
            image = previewImage
            brush.lastPoint = brush.endPoint
        }
    }
}
