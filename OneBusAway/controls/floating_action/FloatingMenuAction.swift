//
//  FloatingMenuAction.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/20/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import UIKit

class FloatingMenuAction: NSObject {
    public var image: UIImage
    public var text: String
    public weak var target: AnyObject?
    public var action: Selector?

    init(text: String, image: UIImage, target: AnyObject?, action: Selector?) {
        self.image = image
        self.text = text
        self.target = target
        self.action = action
    }
}
