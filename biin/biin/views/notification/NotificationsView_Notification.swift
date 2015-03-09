//  NotificationsView_Notification.swift
//  biin
//  Created by Esteban Padilla on 3/6/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class NotificationsView_Notification: BNView {
    
    var notificationAvatarView:UIView?
    var notificationAvatar:BNUIImageView?
    
    var title:UILabel?
    var text:UILabel?
    var removeBtn:BNUIButton_RemoveIt?
    
    weak var notification:BNNotification?
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame)
        self.father = father
    }
    
    convenience init(frame: CGRect, father: BNView?, notification:BNNotification?) {
        self.init(frame:frame, father:father)
        //self.site = site
        self.notification = notification
        
        self.backgroundColor = UIColor.appMainColor()
        self.layer.borderColor = UIColor.appButtonColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        var screenWidth = SharedUIManager.instance.screenWidth
        var screenHeight = SharedUIManager.instance.screenHeight
        var xpos:CGFloat = ((screenHeight) / 2)
        var ypos:CGFloat = 10
        
        notificationAvatarView = UIView(frame: CGRectMake(10, ypos, 40, 40))
        notificationAvatarView!.layer.cornerRadius = 15
        notificationAvatarView!.layer.borderColor = UIColor.appBackground().CGColor
        notificationAvatarView!.layer.borderWidth = 3
        notificationAvatarView!.layer.masksToBounds = true
        self.addSubview(notificationAvatarView!)
        
        notificationAvatar = BNUIImageView(frame: CGRectMake(1, 1, 38, 38))
        notificationAvatar!.alpha = 0
        notificationAvatarView!.addSubview(notificationAvatar!)
    
        BNAppSharedManager.instance.networkManager.requestImageData(notification!.biin!.site!.media[0].url!, image: notificationAvatar)
        
        title = UILabel(frame: CGRectMake(55, 15, (screenWidth - 90), 14))
        title!.text = self.notification!.title!
        title!.textColor = notification!.biin!.site!.titleColor!
        title!.font = UIFont(name: "Lato-Regular", size: 12)
        title!.textAlignment = NSTextAlignment.Left
        self.addSubview(title!)
        
        text = UILabel(frame: CGRectMake(55, 28, (screenWidth - 90), 12))
        text!.font = UIFont(name: "Lato-Light", size: 10)
        text!.text = self.notification!.text!
        text!.textColor = UIColor.appTextColor()
        text!.numberOfLines = 0
        self.addSubview(text!)
        
        text = UILabel(frame:CGRectMake((screenWidth - 30), 25, 15, 15))
        text!.font = UIFont(name: "Lato-Light", size: 10)
        text!.text = "\(self.notification!.identifier)"
        text!.textColor = UIColor.bnRed()
        self.addSubview(text!)
        
        removeBtn = BNUIButton_RemoveIt(frame:CGRectMake((screenWidth - 30), 5, 15, 15))
        self.addSubview(removeBtn!)
        
    }
}
