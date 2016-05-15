//
//  BaseViewController.swift
//  WeatherMate
//
//  Created by Samrat on 4/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

/*************************************************************/
// MARK: Imported Classes
/*************************************************************/
import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    struct Static {
        static let random = Int(arc4random_uniform(UInt32(5 - 1))) + 1
    }
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    @IBOutlet weak var imgVwBackground : UIImageView?
    
    /*************************************************************/
    // MARK: View Lifecycle
    /*************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        //imgVwBackground?.image = UIImage(named: "Default_Background")
        // Randomise the background
        imgVwBackground?.image = UIImage(named: ("Background_" + String(Static.random)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    /*************************************************************/
    // MARK: Actions
    /*************************************************************/
    @IBAction func hamburgerTapped(sender : AnyObject?){
        //TODO: Add the paperfold view here.
        
        if let slideMenuController = self.slideMenuController() {
            // some code
            slideMenuController.openLeft()
        }
    }
    
    @IBAction func refreshTapped(sender : AnyObject?){
        //TODO: Call the service to get updated values
    }
}