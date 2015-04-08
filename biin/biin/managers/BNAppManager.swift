//  BNAppManager.swift
//  Biin
//  Created by Esteban Padilla on 6/3/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import UIKit

struct BNAppSharedManager { static let instance = BNAppManager() }

class BNAppManager {
    
    var counter = 0
    var version = "0.1.8"
    
    var delegate:BNAppManager_Delegate?
    
    var dataManager:BNDataManager
    var positionManager:BNPositionManager
    var networkManager:BNNetworkManager
    var errorManager:BNErrorManager
    
    var IS_PRODUCTION_RELEASE = false
    
    var areNewNotificationsPendingToShow = false
    
    var mainViewController:MainViewController?
    
    init(){
        self.counter++

        errorManager = BNErrorManager()
        dataManager = BNDataManager(errorManager:errorManager)
        positionManager = BNPositionManager(errorManager:errorManager)
        networkManager = BNNetworkManager(errorManager:errorManager)
        
        networkManager.delegateDM = dataManager
        dataManager.delegateNM = networkManager
        dataManager.delegatePM = positionManager
        positionManager.delegateDM = dataManager
        errorManager.delegateNM = networkManager
        
        //1. Code Flow - Checks connectivity first.
        networkManager.checkConnectivity()
    }
    
    func biinit(identifier:String, isElement:Bool){

        println("Biinit: \(identifier)")
        
        if isElement {
            dataManager.elements[identifier]?.userBiined = true
            dataManager.elements[identifier]?.biinedCount++
            
            dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]?.elements[identifier] = dataManager.elements[identifier]!
     
            networkManager.sendBiinedElement(dataManager.bnUser!, element:dataManager.elements[identifier]!, collectionIdentifier: dataManager.bnUser!.temporalCollectionIdentifier!)
        } else {
            dataManager.sites[identifier]?.userBiined = true
            dataManager.sites[identifier]?.biinedCount++
            dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]?.sites[identifier] =  dataManager.sites[identifier]!
            networkManager.sendBiinedSite(dataManager.bnUser!, site: dataManager.sites[identifier]!, collectionIdentifier: dataManager.bnUser!.temporalCollectionIdentifier!)
        }
        
        dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]?.items.append(identifier)
    }
    
    func shareit(identifier:String){
        println("Shareit: \(identifier)")
    }
    
    func commentit(identifier:String, comment:String){
        println("Commentit: \(identifier) comment: \(comment)")
    }
    
    func unBiinit(identifier:String, isElement:Bool){
        
        println("unBiinit: \(identifier)")
        
        if isElement {
            dataManager.elements[identifier]?.userBiined = false
            dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]!.elements[identifier] = nil
            networkManager.sendUnBiinedElement(dataManager.bnUser!, elementIdentifier:identifier, collectionIdentifier:dataManager.bnUser!.temporalCollectionIdentifier!)
        } else {
            dataManager.sites[identifier]?.userBiined = false
            dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]!.sites[identifier] = nil
            networkManager.sendUnBiinedSite(dataManager.bnUser!, siteIdentifier:identifier, collectionIdentifier:dataManager.bnUser!.temporalCollectionIdentifier!)
        }

        if dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]?.items.count > 0 {
            var index:Int = 0
            for item in dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]!.items {

                if item == identifier {
                    break
                }
                
                index++
            }
            
            dataManager.bnUser!.collections![dataManager.bnUser!.temporalCollectionIdentifier!]!.items.removeAtIndex(index)
        }
        
        //TODO: inform backend the user remove biined element
    }
    
    func processNotification(notification:BNNotification){
        areNewNotificationsPendingToShow = true
        dataManager.bnUser!.newNotificationCount!++
        dataManager.bnUser!.notificationIndex! = notification.identifier
        dataManager.notifications.append(notification)

        //Notify main view to show circle
        delegate!.manager!(showNotifications: true)
    }
}

@objc protocol BNAppManager_Delegate:NSObjectProtocol {
    optional func manager(showNotifications value:Bool)
    optional func manager(hideNotifications value:Bool)
}
