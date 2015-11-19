//
//  TextField.swift
//  MemeMe
//
//  Created by Nora on 11/17/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import Foundation
import UIKit

extension NSParagraphStyle {
    func centerParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}

class TextField: NSObject, UITextFieldDelegate {
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -3.0,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSParagraphStyleAttributeName: NSParagraphStyle().centerParagraphStyle()
    ]
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if (textField.restorationIdentifier == "bottomTextField"){
            bottomTextFieldIsBeingEdited = true
            
            if (textField.text == "BOTTOM"){
                textField.text = ""
            } else {
                textField.text = textField.text!
            }
            
        } else {
            bottomTextFieldIsBeingEdited = false
            
            if (textField.text == "TOP"){
                textField.text = ""
            } else {
                textField.text = textField.text!
            }
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if((textField.textInputView.frame.maxX > framWidth)){
            return false
        }
        
        return true
    }
    func textFieldDidEndEditing(textField: UITextField){
        if (textField.restorationIdentifier == "bottomTextField"){
            if (textField.text == ""){
                textField.text = "BOTTOM"
            }
        } else {
            if (textField.text == ""){
                textField.text = "TOP"
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}