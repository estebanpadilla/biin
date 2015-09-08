//  BNRequest_Biinie.swift
//  biin
//  Created by Alison Padilla on 9/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class BNRequest_Biinie: BNRequest {
    override init(){
        super.init()
    }
    
    deinit{
        
    }
    
    convenience init(requestString:String, errorManager:BNErrorManager, networkManager:BNNetworkManager, user:Biinie ) {
        
        self.init()
        self.identifier = BNRequestData.requestCounter++
        self.requestString = requestString
        self.dataIdentifier = ""
        self.requestType = BNRequestType.SendBiinieActions
        self.errorManager = errorManager
        self.networkManager = networkManager
        self.user = user
    }
    
    override func run() {
        
        NSLog("BNRequest_CheckEmail_IsVerified.run()")
        isRunning = true
        
        self.networkManager!.epsNetwork!.getJson(false, url: self.requestString, callback:{
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            if (error != nil) {
                
                println("Error on biinie data")
                self.networkManager!.handleFailedRequest(self, error: error )
                
            } else {
                
                var response:BNResponse?
                
                if let biinieData = data["data"] as? NSDictionary {
                    
                    var status = BNParser.findInt("status", dictionary: data)
                    var result = BNParser.findBool("result", dictionary: data)
                    
                    if result {
                        response = BNResponse(code:status!, type: BNResponse_Type.Cool)
                        
                        self.user!.identifier = BNParser.findString("identifier", dictionary:biinieData)
                        self.user!.biinName = BNParser.findString("biinName", dictionary: biinieData)
                        self.user!.firstName = BNParser.findString("firstName", dictionary: biinieData)
                        self.user!.lastName = BNParser.findString("lastName", dictionary: biinieData)
                        self.user!.email = BNParser.findString("email", dictionary: biinieData)
                        self.user!.imgUrl = BNParser.findString("imgUrl", dictionary: biinieData)
                        self.user!.gender = BNParser.findString("gender", dictionary: biinieData)
                        self.user!.isEmailVerified = BNParser.findBool("isEmailVerified", dictionary: biinieData)
                        self.user!.birthDate = BNParser.findNSDate("birthDate", dictionary: biinieData)
                        
                        var friends = BNParser.findNSArray("friends", dictionary: biinieData)
                        var categories = Array<BNCategory>()
                        var categoriesData = BNParser.findNSArray("categories", dictionary: biinieData)
                        
                        for var i = 0; i < categoriesData?.count; i++ {
                            
                            var categoryData = categoriesData!.objectAtIndex(i) as! NSDictionary
                            var category = BNCategory(identifier: BNParser.findString("identifier", dictionary: categoryData)!)
                            
                            category.name = BNParser.findString("name", dictionary: categoryData)
                            
                            categories.append(category)
                        }
                        
                        self.user!.categories = categories
                        self.networkManager!.delegateDM!.manager!(self.networkManager!, didReceivedBiinieData:self.user!)
                        
                    } else {
                        println("EROOR: NOT USER FOUND ON DB")
                        response = BNResponse(code:status!, type: BNResponse_Type.Suck)
                    }
                }
                
                self.inCompleted = true
                self.networkManager!.removeFromQueue(self)
            }
        })
    }
}