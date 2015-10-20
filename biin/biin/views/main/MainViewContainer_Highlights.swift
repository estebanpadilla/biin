//  HighlightsContainer.swift
//  biin
//  Created by Esteban Padilla on 9/24/15.
//  Copyright © 2015 Esteban Padilla. All rights reserved.


import Foundation
import UIKit

class MainViewContainer_Highlights:BNView, UIScrollViewDelegate {
    
    
    var scroll:UIScrollView?
    var currentHighlight:Int = 0
    var timer:NSTimer?
    
    var hightlights:Array<HighlightView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        self.backgroundColor = UIColor.greenColor()
        
        //TODO: Add all showcase data here
        scroll = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        scroll!.delegate = self
        scroll!.showsHorizontalScrollIndicator = false
        scroll!.backgroundColor = UIColor.darkGrayColor()
        scroll!.pagingEnabled = true
        self.addSubview(scroll!)
        
        hightlights = Array<HighlightView>()
        updateHighlightView()
        
        startTimer()
        
    }
    
    deinit{ }
    
    override func transitionIn() {
        
    }
    
    override func transitionOut( state:BNState? ) {
        if hightlights?.count > 0 {
            
            for view in scroll!.subviews {
                
                if view is HighlightView {
                    (view as! HighlightView).removeFromSuperview()
                }
            }
            
            hightlights!.removeAll(keepCapacity: false)
        }
    }
    
    override func setNextState(goto:BNGoto){

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
    
    //Instance methods
    //instance methods
    //Start all category work, download etc.
    override func getToWork(){

    }
    
    //Stop all category work, download etc.
    override func getToRest(){

    }
    
    func change(sender:NSTimer){
        if currentHighlight < hightlights!.count {
            let xpos:CGFloat = SharedUIManager.instance.screenWidth * CGFloat((currentHighlight))
            scroll!.setContentOffset(CGPoint(x: xpos, y: 0), animated: true)
            currentHighlight++
            
            //print("current:\(currentHighlight)")
            //print("number:\(hightlights!.count)")
        }
    }
    

    
    func updateHighlightView(){

        
        if BNAppSharedManager.instance.dataManager.highlights.count > 0{

            var xpos:CGFloat = 0

            for element in BNAppSharedManager.instance.dataManager.highlights {
                
                //let element = BNAppSharedManager.instance.dataManager.elements[_id]
                
                let highlight = HighlightView(frame: CGRectMake(xpos, 0, SharedUIManager.instance.screenWidth, (SharedUIManager.instance.highlightContainer_Height + SharedUIManager.instance.highlightView_headerHeight)), father: self, element: element)
                
                
                highlight.delegate = BNAppSharedManager.instance.mainViewController!.mainView!//father?.father! as! MainView
                scroll!.addSubview(highlight)
                hightlights!.append(highlight)
                highlight.requestImage()
                xpos += (SharedUIManager.instance.screenWidth )
            }
            
            let lastHightLight = HighlightView(frame: CGRectMake(xpos, 0, SharedUIManager.instance.screenWidth, (SharedUIManager.instance.highlightContainer_Height + SharedUIManager.instance.highlightView_headerHeight)), father: self, element: hightlights![0].element!)
            lastHightLight.frame.origin.x = xpos
            lastHightLight.requestImage()
            lastHightLight.delegate = BNAppSharedManager.instance.mainViewController!.mainView!//father?.father! as! MainView
            scroll!.addSubview(lastHightLight)
            hightlights!.append(lastHightLight)
            xpos += (SharedUIManager.instance.screenWidth )
            
            scroll!.contentSize = CGSizeMake(xpos, SharedUIManager.instance.highlightContainer_Height)
        }
    }
    
    /* UIScrollViewDelegate Methods */
    func scrollViewDidScroll(scrollView: UIScrollView) {

    }// any offset changes
    
    // called on start of dragging (may require some time and or distance to move)
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //handlePan(scrollView.panGestureRecognizer)
        //let mainView = father!.father! as! MainView
        //mainView.delegate!.mainView!(mainView, hideMenu: false)
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
    }// called on finger up as we are moving
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let scrollPosition = scrollView.contentOffset
        currentHighlight = Int(scrollPosition.x / SharedUIManager.instance.screenWidth)
        
 
        
        //print("scrollViewDidEndDecelerating \(currentHighlight)")
        
    }// called when scroll view grinds to a halt
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {

        if currentHighlight == hightlights!.count {
            scroll!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            currentHighlight = 0
        }
        //print("scrollViewDidEndScrollingAnimation")
    }// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        
        return true
    }// return a yes if you want to scroll to the top. if not defined, assumes YES
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        //print("scrollViewDidScrollToTop")

    }// called when scrolling animation finished. may be called immediately if already at top
    
    //ElementMiniView_Delegate
//    func showElementView(element: BNElement) {
//        (father! as! MainViewContainer).showElementView(element)
//    }

    func stopTimer(){
        self.timer!.invalidate()
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "change:", userInfo: nil, repeats: true)
        timer!.fire()
    }
}



