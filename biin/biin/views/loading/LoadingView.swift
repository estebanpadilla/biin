//  LoadingView.swift
//  biin
//  Created by Esteban Padilla on 1/15/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class LoadingView:UIView {

    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.biinColor()
        
        var labelHeight:CGFloat = 40.0
        var ypos:CGFloat = (frame.height / 2) - (labelHeight / 2)
        var loadingLbl = UILabel(frame: CGRect(x:0, y:ypos, width:frame.width, height:labelHeight))
        loadingLbl.font = UIFont(name: "Lato-Light", size: 30)
        loadingLbl.textColor = UIColor.whiteColor()
        loadingLbl.textAlignment = NSTextAlignment.Center
        loadingLbl.text = "Loading..."
        self.addSubview(loadingLbl)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}