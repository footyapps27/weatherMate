//
//  SetNavigationControllerSegue.swift
//  WeatherMate
//
//  Created by Samrat on 19/4/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit

class SetNavigationControllerSegue: UIStoryboardSegue {
    
    override func perform() {
        sourceViewController.navigationController?.setViewControllers([destinationViewController], animated: true)
    }
}