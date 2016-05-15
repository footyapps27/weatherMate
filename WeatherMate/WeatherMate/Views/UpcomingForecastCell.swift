//
//  UpcomingForecastCell.swift
//  WeatherMate
//
//  Created by Samrat on 7/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit

class UpcomingForecastCell : UITableViewCell {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    @IBOutlet weak var lblDayOfTheWeek : UILabel!
    
    @IBOutlet weak var lblMaximumTemperature : UILabel!
    
    @IBOutlet weak var lblMinimumTemperature : UILabel!
    
    @IBOutlet weak var imgVw: UIImageView!
}
