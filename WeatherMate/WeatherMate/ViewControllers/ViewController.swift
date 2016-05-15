//
//  ViewController.swift
//  WeatherMate
//
//  Created by Samrat on 18/4/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

/*************************************************************/
// MARK: Imported Classes
/*************************************************************/
import UIKit
import AVFoundation
import CoreLocation
import Shimmer

class ViewController: UIViewController {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    
    /// The AVPlayer object reference
    private var player: AVPlayer? = nil
    
    /// The view that will tell the user to navigate to the next screen
    @IBOutlet var shimmeringView: FBShimmeringView!
    
    /// Label for slide to continue
    @IBOutlet var lblSlideToContinue: UILabel!
    
    /*************************************************************/
    // MARK: View Lifecycle
    /*************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Hide navigation controller
        navigationController?.navigationBarHidden = true
        
        // Start shimmering the text
        shimmeringView.contentView = lblSlideToContinue
        shimmeringView.shimmering = true
        
        // Add the sliding gesture to the view
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.navigateToCurrentWeatherController))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        // Add the background video
        addBackgroundVideo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*************************************************************/
    // MARK: Helper Methods
    /*************************************************************/
    
    /**
     Method to add the background video
     */
    func addBackgroundVideo() {
        // Get the video
        let path = NSBundle.mainBundle().pathForResource(Constants.Resources.BACKGROUND_VIDEO_NAME, ofType: Constants.Resources.BACKGROUND_VIDEO_TYPE)
        
        // Add the video to the player
        player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None;
        
        // Customize the player now
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(playerLayer, atIndex: 0)
        
        // Observe the end of the player, so that we can start again.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.restartPlayer), name: AVPlayerItemDidPlayToEndTimeNotification, object: player!.currentItem)
        
        // Finally start the player
        player!.seekToTime(kCMTimeZero)
        player!.play()
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        self.view.addMotionEffect(group)
    }
    
    /**
     Restart the player from scratch
     */
    func restartPlayer() {
        player!.seekToTime(kCMTimeZero)
    }
    
    /**
     Navigate to the Current Weather Controller
     */
    func navigateToCurrentWeatherController() {
        performSegueWithIdentifier("showCurrentWeatherController", sender: nil)
    }
}

