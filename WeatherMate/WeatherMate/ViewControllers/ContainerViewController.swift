//
//  ContainerViewController.swift
//  WeatherMate
//
//  Created by Samrat on 7/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Main") {
            self.mainViewController = controller
        }
        
        // TODO: Add the logic foe left view controller here
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("Left") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }
    
}