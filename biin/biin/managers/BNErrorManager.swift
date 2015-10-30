//  BNErrorManager.swift
//  Biin
//  Created by Esteban Padilla on 6/3/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import UIKit

class BNErrorManager:NSObject, UIAlertViewDelegate
{
    var delegateNM:BNErrorManagerDelegate?
    var currentViewController:UIViewController?
    var isAlertOn:Bool = false
    
    override init(){
        super.init()
//        println("BNErrorManager init")
    }
    
    func showAlert(error:NSError?) {
        if !self.isAlertOn {
            //TODO: change UIAlert to UIController.
//            println("Error:" + error!.localizedDescription )
//        
//            var alertView = UIAlertView()
//            alertView.addButtonWithTitle("Ok")
//            alertView.title = "Error"
//            alertView.message = error!.localizedDescription
//            alertView.show()
            
            let vc = ErrorViewController()
            vc.addInternet_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
            
            
            let bnError = BNError(code: "\(error!.code)", title: error!.description, errorDescription: error!.localizedDescription, proximityUUID: "none", region: "none", errorType:BNErrorType.none)
            delegateNM!.manager!(self, saveError: bnError)
            
            isAlertOn = true
        }
    }
    
    func showAlertOnStart(error:NSError?) {
        if !self.isAlertOn {
            //TODO: change UIAlert to UIController.
//            println("Error:" + error!.localizedDescription )
//            
//            var alertView = UIAlertView()
//            alertView.addButtonWithTitle("Ok")
//            alertView.title = "Error"
//            alertView.message = error!.localizedDescription
//            alertView.show()
            
            let vc = ErrorViewController()
            vc.addInternet_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
        
            //var bnError = BNError(code: "\(error!.code)", title: error!.description, errorDescription: error!.localizedDescription, proximityUUID: "none", region: "none", errorType:BNErrorType.none)
            //delegateNM!.manager!(self, saveError: bnError)
            
            isAlertOn = true
        }
    }
    

    func showLocationServiceError(){
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ICLocalizedString(@"LocationServicesPermissionTitle")
            message:ICLocalizedString(@"LocationPermissionGeoFenceMessage")
            delegate:self
            cancelButtonTitle:@"Settings"
        otherButtonTitles:nil];
        [alert show];
        */
        
        if !self.isAlertOn {
            
            
            isAlertOn = true
            
//            let alertController = UIAlertController(title: "Location services required.", message: "Biin needs to use location services to work properly.", preferredStyle: .Alert)
//
//            let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
//                
//                println("Goto settings...")
//                self.isAlertOn = false
//                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//            
//            })
//            
//            alertController.addAction(settingsAction)
//
//            
//            BNAppSharedManager.instance.appDelegate!.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
//
//            
            let vc = ErrorViewController()
            vc.addLocation_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
            
            
        }
    }
    
    
    
    
    func showInternetError(){

        if !self.isAlertOn {
            
            isAlertOn = true
            
            
            let vc = ErrorViewController()
            vc.addInternet_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
            
            
//            let alertController = UIAlertController(title: "Internet required.", message: "Biin needs to use the internet to work properly.", preferredStyle: .Alert)
//  
//            let settingsAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
//                
//                println("")
//                self.isAlertOn = false
//                BNAppSharedManager.instance.networkManager.checkConnectivity()
//                
//            })
//            
//            alertController.addAction(settingsAction)
//            
//            BNAppSharedManager.instance.appDelegate!.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
//            
            
            
            
            
        }
    }

    
    func showHardwareNotSupportedError(){
        
        if !self.isAlertOn {
            
            isAlertOn = true
            
//            let alertController = UIAlertController(title:  NSLocalizedString("DevideNotSupported", comment: "DevideNotSupported"), message: NSLocalizedString("BiinIsNotAbleToRun", comment: "BiinIsNotAbleToRun"), preferredStyle: .Alert)
//            
//            let closeAction = UIAlertAction(title:NSLocalizedString("Close", comment: "Close"), style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
//                
//                println("")
//                self.isAlertOn = false
//                (self.currentViewController as! LoadingViewController).loadingView!.showHardwareError()
//                
//            })
//            
//            alertController.addAction(closeAction)
//            
//            BNAppSharedManager.instance.appDelegate!.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            
            let vc = ErrorViewController()
            vc.addHardware_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
        }
    }
    
    
    func showBluetoothError(){
        
        if !self.isAlertOn {
            
            isAlertOn = true
            
//            let alertController = UIAlertController(title: "Bluetooth required.", message: "Biin needs to use the bluetooth to work properly.", preferredStyle: .Alert)
//            
//            let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
//                
//                println("")
//                self.isAlertOn = false
//                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//                
//                
//            })
//            
//            alertController.addAction(settingsAction)
//            
//            BNAppSharedManager.instance.appDelegate!.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
//            
            
            let vc = ErrorViewController()
            vc.addBluetooth_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
        }
    }
    
    
    
    func showNotBiinieError(){
        
        if !self.isAlertOn {
            
            isAlertOn = true
            
            let vc = ErrorViewController()
            vc.addNotBiinie_ErrorView()
            vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            currentViewController!.presentViewController(vc, animated: true, completion: nil)
            BNAppSharedManager.instance.errorManager.currentViewController = vc
        }
    }

    
    // before animation and hiding view
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        isAlertOn = false
    }

}

@objc protocol BNErrorManagerDelegate:NSObjectProtocol {
    optional func manager(manager:BNErrorManager!, saveError error:BNError)
}
