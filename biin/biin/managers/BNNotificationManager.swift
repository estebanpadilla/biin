//  BNNotificationManager.swift
//  biin
//  Created by Esteban Padilla on 6/18/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class BNNotificationManager:NSObject, NSCoding {

    var currentNotification:BNLocalNotification?
    var localNotifications:[BNLocalNotification] = [BNLocalNotification]()
    var lastNotificationObjectId:String = ""
    var didSendNotificationOnAppDown = false
    
    override init(){
        super.init()
    }
    
    deinit{
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        self.localNotifications =  aDecoder.decodeObjectForKey("localNotifications") as! [BNLocalNotification]
        self.lastNotificationObjectId = aDecoder.decodeObjectForKey("lastNotificationObjectId") as! String
        self.didSendNotificationOnAppDown = aDecoder.decodeBoolForKey("didSendNotificationOnAppDown")
        
        if didSendNotificationOnAppDown {
            self.findNotificationByObjectId()
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(localNotifications, forKey: "localNotifications")
        aCoder.encodeObject(lastNotificationObjectId, forKey:"lastNotificationObjectId")
        aCoder.encodeBool(didSendNotificationOnAppDown, forKey: "didSendNotificationOnAppDown")
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey:"notificationManager")
    }
    
    func clear() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("notificationManager")
    }
    
    class func loadSaved() -> BNNotificationManager? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("notificationManager") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? BNNotificationManager
        }
        return nil
    }
    
    func findNotificationByObjectId(){
        NSLog("BIIN - findNotificationByObjectId()")

        for notification in localNotifications {
            if notification.objectIdentifier! == lastNotificationObjectId {
                currentNotification = notification
                lastNotificationObjectId = ""
                NSLog("BIIN - Notification Pending to show: \(currentNotification!.objectIdentifier!)")
                break
            }
        }
    }
    
    func clearCurrentNotification(){
        self.currentNotification = nil
        didSendNotificationOnAppDown = false
        lastNotificationObjectId = ""
        save()
    }
    
    ///identifier: object identifier on the biin.
    ///
    func addLocalNotification(object:BNBiinObject, notificationText:String, notificationType:BNLocalNotificationType, siteIdentifier:String, biinIdentifier:String, elementIdentifier:String){
        
        var isNotificationSaved = false

        
        for var i = 0; i < localNotifications.count; i++ {
            
            //println("\(localNotifications[i].objectIdentifier!) : \(i)")
            
            if localNotifications[i].objectIdentifier == object._id! {
                
                localNotifications[i].notificationText = notificationText
                isNotificationSaved = true
                //TEMPORAL: USE TO GET NOTIFICATION WHILE APP IS DOWN
                localNotifications[i].onMonday = object.onMonday
                localNotifications[i].onTuesday = object.onTuesday
                localNotifications[i].onWednesday = object.onWednesday
                localNotifications[i].onThursday = object.onThursday
                localNotifications[i].onFriday = object.onFriday
                localNotifications[i].onSaturday = object.onSaturday
                localNotifications[i].onSunday = object.onSunday
                localNotifications[i].endTime = object.endTime
                localNotifications[i].startTime = object.startTime
                //localNotifications[i].isUserNotified = object.isUserNotified
                localNotifications[i].major = object.major
                localNotifications[i].minor = object.minor
                
                //HACK
                localNotifications[i].isUserNotified = false
                
                break
            }
        }
        
        if !isNotificationSaved {
            let notification = BNLocalNotification(objectIdentifier:object._id!, notificationText:notificationText, notificationType:notificationType, siteIdentifier:siteIdentifier, biinIdentifier:biinIdentifier, elementIdentifier:elementIdentifier)
            
            //TEMPORAL: USE TO GET NOTIFICATION WHILE APP IS DOWN
            notification.onMonday = object.onMonday
            notification.onTuesday = object.onTuesday
            notification.onWednesday = object.onWednesday
            notification.onThursday = object.onThursday
            notification.onFriday = object.onFriday
            notification.onSaturday = object.onSaturday
            notification.onSunday = object.onSunday
            notification.endTime = object.endTime
            notification.startTime = object.startTime
            //notification.isUserNotified = object.isUserNotified
            notification.major = object.major
            notification.minor = object.minor
            notification.fireDate = NSDate(timeIntervalSince1970: 0)
            localNotifications.append(notification)
            
            //HACK
            notification.isUserNotified = false
            
        }
        
        save()
        
        //println("localNotification count: \(localNotifications.count)")
    }
    
    func removeLocalNotification(objectIdentifier:String) {
        for var i = 0; i < localNotifications.count; i++ {
            if localNotifications[i].objectIdentifier == objectIdentifier {
                localNotifications.removeAtIndex(i)
                return
            }
        }
        save()
    }
    
    func clearLocalNotifications() {
        localNotifications.removeAll(keepCapacity: false)
        save()
    }

    func activateNotificationForSite(siteIdentifier:String, major:Int) {
        
        NSLog("BIIN - activateNotificationForSite()")
        NSLog("BIIN - localNotifications: \(localNotifications.count)")
        
        self.currentNotification = nil
        didSendNotificationOnAppDown = false
        
        if BNAppSharedManager.instance.IS_APP_DOWN {
            NSLog("BIIN - activateNotificationForSite() - WHEN APP IS DOWN")
            setCurrentNotificationWhenAppIsDown(siteIdentifier, major: major)
            sendCurrentNotification()
        } else {
            if let site = BNAppSharedManager.instance.dataManager.sites[siteIdentifier] {
                NSLog("BIIN - site: \(site.title!)")
                
                for biin in site.biins {
                    NSLog("BIIN - biin: \(biin.identifier!)")
                    if biin.biinType == BNBiinType.EXTERNO {
                        for localNotification in localNotifications {
                            NSLog("BIIN - notification id: \(localNotification.objectIdentifier!)")
                            NSLog("BIIN - current biin object: \(biin.currectObject()._id!)")
                            if localNotification.objectIdentifier == biin.currectObject()._id! {
                                self.currentNotification = localNotification
                                sendCurrentNotification()
                                return
                            }
                        }
                    }
                }
            }
            
            if  self.currentNotification == nil {
                NSLog("BIIN - NOTIFICATION NOT FOUND FOR BIIN in SITE: \(siteIdentifier)")
//                self.currentNotification = BNLocalNotification(objectIdentifier: "TEST", notificationText: "TEST", notificationType: BNLocalNotificationType.EXTERNAL, siteIdentifier: "TEST", biinIdentifier: "TEST", elementIdentifier: "TEST")
//                sendCurrentNotification()
            }
        }
    }

    func activateNotificationForBiin(biinIdentifier:String) {
        
        NSLog("BIIN - activateNotificationForBiin - \(biinIdentifier)")

        //Get the closes local notification asociates to the biin
        for localNotification in localNotifications {

            NSLog("BIIN - biin: \(biinIdentifier)")
            NSLog("BIIN - notification-biin: \(localNotification.biinIdentifier!)")
            
            if localNotification.biinIdentifier == biinIdentifier {
                self.currentNotification = localNotification
                break
            } else {
                self.currentNotification = nil
                NSLog("BIIN - NOTIFICATION NOT FOUND FOR BIIN: \(biinIdentifier)")
            }
        }
        
        if BNAppSharedManager.instance.IS_APP_DOWN {

        } else {
            if currentNotification != nil {
                if let site = BNAppSharedManager.instance.dataManager.sites[self.currentNotification!.siteIdentifier!] {
                    for biin in site.biins {
                        if biin.identifier! == biinIdentifier {
                            
                            for localNotification in localNotifications {
                                if localNotification.objectIdentifier == biin.currectObject()._id! {
                                    self.currentNotification = localNotification
                                    break
                                }
                            }
                            
                            break
                        }
                    }
                }
            }
        }
    
        sendCurrentNotification()
    }
    
    func setCurrentNotificationWhenAppIsDown(siteIdentifier:String, major:Int){
        
        NSLog("BIIN - setCurrentNotificationWhenAppIsDown()")
        NSLog("BIIN - ")
        
        didSendNotificationOnAppDown = true
        var siteNotifications:Array<BNLocalNotification> = Array<BNLocalNotification>()
        
        for notification in localNotifications {
            if notification.notificationType == .EXTERNAL && major == notification.major {
                NSLog("BIIN - Site identifier: \(notification.siteIdentifier!)")
                NSLog("BIIN - major: \(notification.major)")
                NSLog("BIIN - minor: \(notification.minor)")
                siteNotifications.append(notification)
            } else {
                NSLog("BIIN - Site identifier: \(siteIdentifier) major:\(major) NOT IN LIST")
            }
        }
        
        assingCurrectNotificationByDate(siteNotifications)
        
    }
    
    
    func assingCurrectNotificationByDate(siteNotifications:Array<BNLocalNotification>){
        //TODO: get the correct object depending on the time and properties.
       NSLog("BIIN - assingCurrectNotificationByDate: \(siteNotifications.count)")
        var currentNotificationIndex = 0
        var isCurrentObjectSet = false
        
//        if objects!.count > 0 {
        
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour, .Minute], fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            let currentTime:Float = Float(hour) + (Float(minutes) * 0.01)
            
            var isAvailableToday = false
            
            let dayNumber = getDayOfWeek()
            for var i = 0; i < siteNotifications.count; i++ {
                
                NSLog("Day:\(getDayOfWeek())")
                NSLog("CUrrent object:\(siteNotifications[i].siteIdentifier!) index;\(i)")
                NSLog("Start time:\(siteNotifications[i].startTime)")
                NSLog("End time: \(siteNotifications[i].endTime)")
                
                if currentTime >= siteNotifications[i].startTime {
                    if currentTime <= siteNotifications[i].endTime {
                        
                        switch dayNumber {
                        case 1://Sunday
                            if siteNotifications[i].onSunday {
                                isAvailableToday = true
                            }
                            break
                        case 2://Monday
                            if siteNotifications[i].onMonday {
                                isAvailableToday = true
                            }
                            break
                        case 3://Tuesday
                            if siteNotifications[i].onTuesday {
                                isAvailableToday = true
                            }
                            break
                        case 4://Wednesday
                            if siteNotifications[i].onWednesday {
                                isAvailableToday = true
                            }
                            break
                        case 5://Thurday
                            if siteNotifications[i].onThursday {
                                isAvailableToday = true
                            }
                            break
                        case 6://Friday
                            if siteNotifications[i].onFriday {
                                isAvailableToday = true
                            }
                            break
                        case 7://Saturday
                            if siteNotifications[i].onSaturday {
                                isAvailableToday = true
                            }
                            break
                        default:
                            isAvailableToday = false
                            break
                        }
                        
                        
                        if isAvailableToday {
                            currentNotificationIndex = i
                            currentNotification = siteNotifications[currentNotificationIndex]
                            isCurrentObjectSet = true
                            NSLog("Day:\(getDayOfWeek())")
                            NSLog("Current notification:\(siteNotifications[currentNotificationIndex].siteIdentifier!) index:\(currentNotificationIndex)")
                            NSLog("Start time:\(siteNotifications[currentNotificationIndex].startTime)")
                            NSLog("End time: \(siteNotifications[currentNotificationIndex].endTime)")
                            
                        } else {
                            currentNotificationIndex = 0
                            isCurrentObjectSet = true
                            //                            println("Day:\(getDayOfWeek())")
                            //                            println("CUrrent object index;\(currentObjectIndex)")
                            //                            println("Start time:\(objects![currentObjectIndex].startTime)")
                            //                            println("End time: \(objects![currentObjectIndex].endTime)")
                        }
                    }
                }
//            }
        }
        
        if !isCurrentObjectSet {
//            NSLog("Setting defaul!")
            currentNotificationIndex = 0
            currentNotification = siteNotifications[currentNotificationIndex]
//            NSLog("CUrrent object index;\(currentNotificationIndex)")
//            NSLog("Start time:\(siteNotifications[currentNotificationIndex].startTime)")
//            NSLog("End time: \(siteNotifications[currentNotificationIndex].endTime)")
        }
    }

    
    func getDayOfWeek()->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = NSDate().bnShortDateFormat()
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return 0
        }
    }
    
    func sendCurrentNotification(){
        
        if self.currentNotification != nil {
            
            let days:Int = NSDate().daysBetweenFromAndTo(self.currentNotification!.fireDate!)
            
            NSLog("BIIN - DAYS: \(days), from:\(self.currentNotification!.fireDate!) to:\(NSDate()), \(self.currentNotification!.isUserNotified)")
            
            //HACK: to test all notifications.
//            if !self.currentNotification!.isUserNotified || days > 1 {
            if !self.currentNotification!.isUserNotified  {
                var time:NSTimeInterval = 0
                let localNotification:UILocalNotification = UILocalNotification()
                localNotification.alertBody = currentNotification!.notificationText
                localNotification.alertTitle = "Biin"
                localNotification.soundName = "notification.wav"//UILocalNotificationDefaultSoundName
                //localNotification.alertLaunchImage = "biinLogoLS"
                
                
                switch self.currentNotification!.notificationType! {
                case .EXTERNAL:
                    //println("Activating notification \(self.currentNotification!.biinIdentifier!), EXTERNAL")
                    //localNotification.alertAction = "externalAction"
                    time = 1
                    break
                case .INTERNAL:
                    //println("Activating notification \(self.currentNotification!.biinIdentifier!), INTERNAL")
                    //localNotification.alertAction = "internalAction"
                    time = 1
                    break
                case .PRODUCT:
                    //println("Activating notification \(self.currentNotification!.biinIdentifier!), PRODUCT")
                    //localNotification.alertAction = "productAction"
                    time = 1
                    break
                default:
                    break
                }
                
                localNotification.fireDate = NSDate(timeIntervalSinceNow: time)

//                localNotification.category = "biinNotificationCategory"
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
                //HACK: to shwo all notifications.
                currentNotification!.isUserNotified = false
                //currentNotification!.isUserNotified = true
                
                currentNotification!.fireDate = NSDate()
                lastNotificationObjectId = currentNotification!.objectIdentifier!
                save()
                BNAppSharedManager.instance.dataManager.bnUser!.addAction(NSDate(), did:BiinieActionType.BIIN_NOTIFIED, to:currentNotification!.objectIdentifier!)
            } else {
                NSLog("BIIN - USER ALREADY NOTIFIED!")
                NSLog("BIIN - Current notification:\(currentNotification!.objectIdentifier!)")
                NSLog("BIIN - Start time:\(currentNotification!.startTime)")
                NSLog("BIIN - End time: \(currentNotification!.endTime)")
            }
        }

    }
}

