//
//  Board.swift
//  DrawingBoard
//
//  Created by ZhangAo on 15-2-15.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//


import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {
    
    // UndoManager，用于实现 Undo 操作和维护图片栈的内存
    private class DBUndoManager {
        class DBImageFault: UIImage {}  // 一个 Fault 对象，与 Core Data 中的 Fault 设计类似
        
        private static let INVALID_INDEX = -1
        private var images = [UIImage]()    // 图片栈
        private var index = INVALID_INDEX   // 一个指针，指向 images 中的某一张图
        
        var canUndo: Bool {
            get {
                return index != DBUndoManager.INVALID_INDEX
            }
        }
        
        func addImage(image: UIImage) {
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            
            images.append(image)
            
            index = images.count - 1
            
           // setNeedsCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                --index
                if self.canUndo == false {
                    return nil
                } else {
                    //setNeedsCache()
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
    private var boardUndoManager = DBUndoManager() // 缓存或Undo控制器
    
    private var drawingState: DrawingState!
    
    override init(frame: CGRect) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 2
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 2
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public methods
    
    var canUndo: Bool {
        get {
            return self.boardUndoManager.canUndo
        }
    }
    
    // undo 和 redo 的逻辑都有所简化
    func undo() {
        if self.canUndo == false {
            return
        }
        
        self.image = self.boardUndoManager.imageForUndo()
        
        self.realImage = self.image
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        self.image?.drawInRect(self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - touches methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            
            brush.beginPoint = touches.first!.locationInView(self)
            brush.endPoint = brush.beginPoint
            
            self.drawingState = .Began
            
            self.drawingImage()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.locationInView(self)
            
            self.drawingState = .Moved
            
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.locationInView(self)
            
            self.drawingState = .Ended
            
            self.drawingImage()
        }
    }
    
    // MARK: - drawing
    
    private func drawingImage() {
        if let brush = self.brush {
            // hook
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(state: self.drawingState)
            }
            
            UIGraphicsBeginImageContext(self.bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds)
            
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, self.strokeWidth)
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
            
            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context!)
            CGContextStrokePath(context)
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            // 用 Ended 事件代替原先的 Began 事件
            if self.drawingState == .Ended {
                self.boardUndoManager.addImage(self.image!)
            }
            
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
}
