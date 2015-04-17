//  SignupView.swift
//  biin
//  Created by Esteban Padilla on 2/6/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class SignupView:UIView, UITextFieldDelegate {
    
    var delegate:SignupView_Delegate?
    
    var biinLogo:BNUIBiinView?
    var backBtn:BNUIButton_Back_SignupView?
    
    var firstNameTxt:BNUITexfield_Top?
    var lastNameTxt:BNUITexfield_Center?
    var genderTxt:BNUITexfield_Center?
    var emailTxt:BNUITexfield_Center?
    var passwordTxt:BNUITexfield_Bottom?
    
    var singupBtn:BNUIButton_Loging?
    var signupLbl:UILabel?
    var welcomeLbl:UILabel?
    
    var isKeyboardUp = false
    
    var femaleBtn:BNUIButton_Gender?
    var maleBtn:BNUIButton_Gender?
    var genderStr:String?
    
//    override init() {
//        super.init()
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.biinColor()
        //        self.layer.cornerRadius = 5
        //        self.layer.masksToBounds = true
        //        self.becomeFirstResponder()
        
        var screenWidth = SharedUIManager.instance.screenWidth
        var ypos:CGFloat = 20
        biinLogo = BNUIBiinView(frame: CGRectMake(((screenWidth - 110) / 2), ypos, 110, 65))
        self.addSubview(biinLogo!)
        //biinLogo!.setNeedsDisplay()
        
        ypos += (10 + biinLogo!.frame.height)
        welcomeLbl = UILabel(frame: CGRectMake(0, ypos, screenWidth, 18))
        welcomeLbl!.text = "Well comeback, we miss you!"
        welcomeLbl!.textAlignment = NSTextAlignment.Center
        welcomeLbl!.textColor = UIColor.appMainColor()
        welcomeLbl!.font = UIFont(name: "Lato-Light", size: 16)
        self.addSubview(welcomeLbl!)
        
        ypos += (20 + welcomeLbl!.frame.height)
        firstNameTxt = BNUITexfield_Top(frame: CGRectMake(20, ypos, (screenWidth - 40), 40), placeHolderText:"Name")
        firstNameTxt!.textField!.delegate = self
        //emailTxt!.textField!.becomeFirstResponder()
        self.addSubview(firstNameTxt!)
        
        ypos += (2 + firstNameTxt!.frame.height)
        lastNameTxt = BNUITexfield_Center(frame: CGRectMake(20, ypos, (screenWidth - 40), 40), placeHolderText:"Last name")
        lastNameTxt!.textField!.delegate = self
        self.addSubview(lastNameTxt!)
        
        ypos += (2 + lastNameTxt!.frame.height)
        genderTxt = BNUITexfield_Center(frame: CGRectMake(20, ypos, (screenWidth - 40), 40), placeHolderText:"I am ...")
        genderTxt!.textField!.enabled = false
        genderTxt!.textField!.delegate = self
        self.addSubview(genderTxt!)
        
        femaleBtn = BNUIButton_Gender(frame: CGRectMake(genderTxt!.frame.width - 90, 5, 30, 30), iconType: BNIconType.femaleSmall)
        femaleBtn!.addTarget(self, action: "femaleBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        genderTxt!.addSubview(femaleBtn!)
        genderStr = ""
        
        maleBtn = BNUIButton_Gender(frame: CGRectMake(genderTxt!.frame.width - 55, 5, 30, 30), iconType: BNIconType.maleSmall)
        maleBtn!.addTarget(self, action: "maleBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        genderTxt!.addSubview(maleBtn!)
        
        ypos += (2 + genderTxt!.frame.height)
        emailTxt = BNUITexfield_Center(frame: CGRectMake(20, ypos, (screenWidth - 40), 40), placeHolderText:"Email")
        emailTxt!.textField!.delegate = self
        emailTxt!.textField!.autocapitalizationType = UITextAutocapitalizationType.None
        self.addSubview(emailTxt!)
        
        
        ypos += (2 + emailTxt!.frame.height)
        passwordTxt = BNUITexfield_Bottom(frame: CGRectMake(20, ypos, (screenWidth - 40), 40), placeHolderText:"Password")
        passwordTxt!.textField!.delegate = self
        passwordTxt!.textField!.secureTextEntry = true
        passwordTxt!.textField!.autocapitalizationType = UITextAutocapitalizationType.None
        self.addSubview(passwordTxt!)
        

        ypos += (20 + passwordTxt!.frame.height)
        singupBtn = BNUIButton_Loging(frame: CGRect(x:((screenWidth - 195) / 2), y: ypos, width: 195, height: 65), color:UIColor.bnYellow(), text:"Let's get started!")
        singupBtn!.addTarget(self, action: "singup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(singupBtn!)
        
        ypos += (10 + singupBtn!.frame.height)
        signupLbl = UILabel(frame: CGRectMake(20, ypos, (screenWidth - 40), 16))
        signupLbl!.text = "Don’t forget to check your inbox and verify your email address later on."
        signupLbl!.textAlignment = NSTextAlignment.Left
        signupLbl!.textColor = UIColor.appMainColor()
        signupLbl!.numberOfLines = 0
        signupLbl!.font = UIFont(name: "Lato-Light", size: 14)
        signupLbl!.sizeToFit()
        self.addSubview(signupLbl!)
        

        backBtn = BNUIButton_Back_SignupView(frame: CGRect(x: 10, y: 10, width: 40, height: 20))
        backBtn!.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backBtn!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide", name: UIKeyboardDidHideNotification, object: nil)

    }
    

    
    func femaleBtnAction(sender:BNUIButton_Gender){
        genderTxt!.textField!.text = "I am a female."
        genderTxt!.textField!.textColor = UIColor.appTextColor()
        genderStr = "female"
        femaleBtn!.showSelected()
        maleBtn!.showEnable()
        genderTxt!.hideError()
    }

    func maleBtnAction(sender:BNUIButton_Gender){
        genderTxt!.textField!.text = "I am a male."
        genderTxt!.textField!.textColor = UIColor.appTextColor()
        genderStr = "male"
        maleBtn!.showSelected()
        femaleBtn!.showEnable()
        genderTxt!.hideError()
    }
    
    func singup(sender:BNUIButton_Loging){
        //1. show progress
        //2. disable buttons
        //3. send request
        
        
        var ready = false
        
        if firstNameTxt!.isValid() &&
           lastNameTxt!.isValid() &&
            emailTxt!.isValid() &&
            passwordTxt!.isValid() {
                
            if genderStr!.isEmpty {
                genderTxt!.showError()
            }
                
            if SharedUIManager.instance.isValidEmail(emailTxt!.textField!.text) {
                ready = true
            }else{
                emailTxt!.showError()
            }
        }
        
        
        if ready {
            var user = Biinie(identifier:emailTxt!.textField!.text, firstName: firstNameTxt!.textField!.text, lastName: lastNameTxt!.textField!.text, email: emailTxt!.textField!.text, gender:genderStr!)
            user.password = passwordTxt!.textField!.text
            BNAppSharedManager.instance.networkManager.register(user)
            
            delegate!.showProgress!(self)
            self.endEditing(true)
            //singupBtn!.showDisable()
        }
    }
    
    func back(sender:BNUIButton_Back_SignupView){
        delegate!.showLoginView!(self)
    }
    
    func keyboardDidShow() {

        if !isKeyboardUp {
            isKeyboardUp = true
            println("keyboardDidShow")
            UIView.animateWithDuration(0.35, animations: {() -> Void in
                self.firstNameTxt!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_1
                self.lastNameTxt!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_1
                self.genderTxt!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_1
                self.emailTxt!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_1
                self.passwordTxt!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_1
                self.singupBtn!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_2
                self.signupLbl!.frame.origin.y -= SharedUIManager.instance.signupView_ypos_2
                
                self.backBtn!.alpha = 0
                self.biinLogo!.alpha = 0
                self.welcomeLbl!.alpha = 0
            })
        }
    }
    
    func keyboardDidHide() {
        
        if isKeyboardUp {
            isKeyboardUp = false
            println("keyboardDidShow")
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.firstNameTxt!.frame.origin.y += SharedUIManager.instance.signupView_ypos_1
                self.lastNameTxt!.frame.origin.y += SharedUIManager.instance.signupView_ypos_1
                self.genderTxt!.frame.origin.y += SharedUIManager.instance.signupView_ypos_1
                self.emailTxt!.frame.origin.y += SharedUIManager.instance.signupView_ypos_1
                self.passwordTxt!.frame.origin.y += SharedUIManager.instance.signupView_ypos_1
                self.singupBtn!.frame.origin.y += SharedUIManager.instance.signupView_ypos_2
                self.signupLbl!.frame.origin.y += SharedUIManager.instance.signupView_ypos_2

                self.backBtn!.alpha = 1
                self.biinLogo!.alpha = 1
                self.welcomeLbl!.alpha = 1
            })
        }
    }
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.endEditing(true)
//    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.endEditing(true)
    }
    
    //UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        println("textFieldShouldBeginEditing")
        
//        if !isKeyboardUp {
//            
//            isKeyboardUp = true
//            
//            UIView.animateWithDuration(0.35, animations: {() -> Void in
//                self.nameTxt!.frame.origin.y -= 150
//                self.lastNameTxt!.frame.origin.y -= 150
//                self.genderTxt!.frame.origin.y -= 150
//                self.emailTxt!.frame.origin.y -= 150
//                self.passwordTxt!.frame.origin.y -= 150
//                self.singupBtn!.frame.origin.y -= 175
//                self.signupLbl!.frame.origin.y -= 175
//                
//                self.biinLogo!.alpha = 0
//                self.welcomeLbl!.alpha = 0
//            })
//        }
        
        return true
    }// return NO to disallow editing.
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("textFieldDidBeginEditing")
    }// became first responder
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing")
        
//        if textField.placeholder == "Password" {
//            if countElements(textField.text) <= 7 {
//                passwordTxt!.showError()
//            }
//        }
        
        return true
    }// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("textFieldDidEndEditing")
        
//        if isKeyboardUp {
//
//            isKeyboardUp = false
//            
//            UIView.animateWithDuration(0.25, animations: {() -> Void in
//                self.nameTxt!.frame.origin.y += 150
//                self.lastNameTxt!.frame.origin.y += 150
//                self.genderTxt!.frame.origin.y += 150
//                self.emailTxt!.frame.origin.y += 150
//                self.passwordTxt!.frame.origin.y += 150
//                self.singupBtn!.frame.origin.y += 175
//                self.signupLbl!.frame.origin.y += 175
//                
//                self.biinLogo!.alpha = 1
//                self.welcomeLbl!.alpha = 1
//            })
//        }
        
    }// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("textField")
        
        textField.textColor = UIColor.appTextColor()
        
        if !textField.text.isEmpty {
            
            textField.text = SharedUIManager.instance.removeSpecielCharacter(textField.text)
            
//            if !passwordTxt!.textField!.text.isEmpty {
//                singupBtn!.showEnable()
//            }else{
//                singupBtn!.showDisable()
//            }
        }
        
        return true
    }// return NO to not change text
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        println("textFieldShouldClear")
        //singupBtn!.showDisable()
        return false
    }// called when clear button pressed. return NO to ignore (no notifications)
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("textFieldShouldReturn")
    
        return false
    }// called when 'return' key pressed. return NO to ignore.
}

@objc protocol SignupView_Delegate:NSObjectProtocol {
    optional func showLoginView(view:UIView)
    optional func enableSignup(view:UIView)
    optional func showProgress(view:UIView)
}