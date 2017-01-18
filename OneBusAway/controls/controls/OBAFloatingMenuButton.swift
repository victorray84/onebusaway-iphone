//
//  OBAFloatingMenuButton.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/18/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import UIKit

class OBAFloatingMenuButton: OBAFloatingButton {
    lazy var darkLayer: UIView = {
        let layer = UIView.init(frame: (self.superview?.bounds)!)
        layer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        layer.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return layer
    }()

    override func configure() {
        super.configure()

        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func buttonTapped() {
        self.isSelected = !self.isSelected

        if self.isSelected {
            self.animateInDarkLayer()
        }
        else if self.darkLayer.superview != nil {
            // this should always hold true when we're not selected,
            // but better safe than sorry.
            self.darkLayer.removeFromSuperview()
        }
    }

    // MARK: - Menu Rendering

    func animateInDarkLayer() {
        if self.darkLayer.superview != nil {
            return
        }

        self.darkLayer.alpha = 0
        self.superview?.insertSubview(self.darkLayer, belowSubview: self)
        OBAAnimation.performAnimations { 
            self.darkLayer.alpha = 1.0
        }
    }
}
