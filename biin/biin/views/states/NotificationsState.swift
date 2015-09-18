//  NotificationsState.swift
//  biin
//  Created by Esteban Padilla on 2/20/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class NotificationsState:BNState {
    
    override init(context:BNView, view:BNView){
        super.init(context:context, view: view)
        self.stateType = BNStateType.Notifications
    }
    
    override init(context: BNView, view: BNView, stateType: BNStateType) {
        super.init(context: context, view: view, stateType: stateType)
    }
    
    override func action() {
        view!.transitionIn()
    }
    
    override func next( state:BNState? ) {
        print("goto state: \(state)")
        context!.state = state
        view!.transitionOut( context!.state )
    }
}
