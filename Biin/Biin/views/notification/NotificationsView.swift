//  NotificationsView.swift
//  biin
//  Created by Esteban Padilla on 2/20/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class NotificationsView: BNView, NotificationsView_Notification_Delegate {
    
    var delegate:NotificationsView_Delegate?
    var title:UILabel?
    var backBtn:BNUIButton_Back?
//    var fade:UIView?
    
    var biinieAvatar:BNUIImageView?
    var biinieNameLbl:UILabel?
    var biinieUserNameLbl:UILabel?
    
    var scroll:BNScroll?
    
    var notifications = Array<NotificationsView_Notification>()

    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appBackground()
        
        let screenWidth = SharedUIManager.instance.screenWidth
        let screenHeight = SharedUIManager.instance.screenHeight
        
        var ypos:CGFloat = 27
        title = UILabel(frame: CGRectMake(6, ypos, screenWidth, (SharedUIManager.instance.mainView_TitleSize + 3)))
        title!.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.mainView_TitleSize)
        let titleText = NSLocalizedString("Notifications", comment: "Notifications").uppercaseString
        let attributedString = NSMutableAttributedString(string:titleText)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(3), range: NSRange(location: 0, length:(titleText.characters.count)))
        title!.attributedText = attributedString
        title!.textColor = UIColor.whiteColor()
        title!.textAlignment = NSTextAlignment.Center
        self.addSubview(title!)
        
        backBtn = BNUIButton_Back(frame: CGRectMake(5,15, 50, 50))
        backBtn!.addTarget(self, action: #selector(self.backBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backBtn!)
        
        ypos = SharedUIManager.instance.mainView_HeaderSize
        let line = UIView(frame: CGRectMake(0, ypos, screenWidth, 0.5))
        line.backgroundColor = UIColor.lightGrayColor()
        
        self.scroll = BNScroll(frame: CGRectMake(0, 0, screenWidth, (screenHeight - 20)), father: self, direction: BNScroll_Direction.VERTICAL, space: 0, extraSpace: 45, color: UIColor.darkGrayColor(), delegate: nil)
        //self.addSubview(scroll!)
        self.addSubview(line)
    }
    
    convenience init(frame:CGRect, father:BNView?, site:BNSite?){
        self.init(frame: frame, father:father )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func transitionIn() {
        
        UIView.animateWithDuration(0.25, animations: {()->Void in
            self.frame.origin.x = 0
        })
    }
    
    override func transitionOut( state:BNState? ) {
        state!.action()
        
        UIView.animateWithDuration(0.25, animations: {()-> Void in
            self.frame.origin.x = SharedUIManager.instance.screenWidth
        })
    }
    
    func hideView(sender:NSTimer){
        self.frame.origin.x = SharedUIManager.instance.screenWidth
    }
    
    override func setNextState(goto:BNGoto){
        //Start transition on root view controller
        father!.setNextState(goto)
    }
    
    override func showUserControl(value:Bool, son:BNView, point:CGPoint){
        if father == nil {

        }else{
            father!.showUserControl(value, son:son, point:point)
        }
    }
    
    override func updateUserControl(position:CGPoint){
        if father == nil {

        }else{
            father!.updateUserControl(position)
        }
    }
    
    //Instance Methods
    func backBtnAction(sender:UIButton) {
        delegate!.hideNotificationsView!()
        //delegate!.hideElementView!(elementMiniView)
    }
    
    func addNotifications(){
        /*
        if notifications.count > 0 {
            for value in notifications {
                value.removeFromSuperview()
            }
            
            notifications.removeAll(keepCapacity: false)
        }

        var ypos:CGFloat = 5
        var height:CGFloat = 60
        
        BNAppSharedManager.instance.notificationManager.notifications = sorted(BNAppSharedManager.instance.notificationManager.notifications){ $0.identifier > $1.identifier }
        
        
        for value in BNAppSharedManager.instance.notificationManager.notifications {
            
            //if notifications[key] == nil {
                var notification = NotificationsView_Notification(frame: CGRectMake(5, ypos, (SharedUIManager.instance.screenWidth - 10), height), father: self, notification: value)
                notification.delegate = self
                self.scroll!.addSubview(notification)
                self.notifications.append(notification)
                
                ypos += height
                ypos += 5
            //}
        }
        
        scroll!.contentSize = CGSizeMake(SharedUIManager.instance.screenWidth, ypos)
*/
    }
    
    
    func resizeScrollOnRemoved(identifier: Int) {
        
        //BNAppSharedManager.instance.notificationManager.removeNotification(identifier)
        
        var startPosition = 0
        for i in (0..<notifications.count){
//        for var i = 0; i < notifications.count; i++ {
            if notifications[i].notification!.identifier == identifier {
                startPosition = i
                notifications[i].removeFromSuperview()
                notifications.removeAtIndex(i)
            }
        }
        
        //var width:CGFloat = (SharedUIManager.instance.screenWidth - 10)
        let height:CGFloat = 65
        var ypos:CGFloat = (height * CGFloat(startPosition)) + 5
        
        for i in (startPosition..<notifications.count){
//        for var i = startPosition; i < notifications.count; i++ {
            UIView.animateWithDuration(0.2, animations: {()->Void in
                self.notifications[i].frame.origin.y = ypos
            })
            
            ypos += height
        }
        
        ypos += 5
//        scroll!.contentSize = CGSizeMake(SharedUIManager.instance.screenWidth, ypos)

    }
    
    
    //func resizeScrollOnRemoved(identifier:Int) {
       /*
        var startPosition = 0
        
        for var i = 0; i < elements!.count; i++ {
            if elements![i].header!.elementPosition! == view.header!.elementPosition! {
                startPosition = i
                elements!.removeAtIndex(i)
            }
        }
        
        var width:CGFloat = (SharedUIManager.instance.miniView_width + spacer)
        var xpos:CGFloat = (width * CGFloat(startPosition)) + spacer
        
        for var i = startPosition; i < elements!.count; i++ {
            UIView.animateWithDuration(0.2, animations: {()->Void in
                self.elements![i].frame.origin.x = xpos
            })
            
            xpos += SharedUIManager.instance.miniView_width + spacer
        }
        
        xpos += spacer
        */
        //        if site!.loyalty!.isSubscribed {
        //            //Add game view
        //            gameView = SiteView_Showcase_Game(frame: CGRectMake(xpos, 0, SharedUIManager.instance.screenWidth, SharedUIManager.instance.miniView_height + 10), father: self, showcase: showcase!, animatedCircleColor: UIColor.biinColor())
        //            scroll!.addSubview(gameView!)
        //            xpos += SharedUIManager.instance.screenWidth
        //        } else  {
        //            joinView = SiteView_Showcase_Join(frame: CGRectMake(xpos, 0, SharedUIManager.instance.screenWidth, SharedUIManager.instance.miniView_height + 10), father: self, showcase: showcase!)
        //            scroll!.addSubview(joinView!)
        //            xpos += SharedUIManager.instance.screenWidth
        //        }
        
//        scroll!.contentSize = CGSizeMake(xpos, 0)

        
    //}

    
}

@objc protocol NotificationsView_Delegate:NSObjectProtocol {
    optional func hideNotificationsView()
}