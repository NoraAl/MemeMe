//
//  PencilBrush.swift
//  DrawingBoard
//
//  Created by 张奥 on 15/3/18.
//  Copyright (c) 2015年 zhangao. All rights reserved.
//

import UIKit

class PencilBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    
    var strokeWidth: CGFloat!
    
    func drawInContext(context: CGContextRef) {
        if let lastPoint = self.lastPoint {
            print(lastPoint)
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        } else {
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        }
    }
    
    func supportedContinuousDrawing() -> Bool {
        return true
    }
}
