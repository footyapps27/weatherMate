//
//  UpcomingForecastViewController.swift
//  WeatherMate
//
//  Created by Samrat on 4/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import Foundation
import UIKit
import Charts

class UpcomingForecastViewController : BaseViewController {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    @IBOutlet weak var heightConstraintForMainScrollView : NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var graphView: LineChartView!
    
    private var model : UpcomingWeather?
    /*************************************************************/
    // MARK: View Lifecycle
    /*************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable user interaction of tableview. This can be done using the storyboard as well, but I prefer using the code! 
        tableView.userInteractionEnabled = false
        tableView.backgroundColor = UIColor.clearColor()
        
        // Update the model that will be used for this screen
        model = UpcomingWeather.init(json: Singleton.sharedInstance.currentCityResponse!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup chart
        setUpChart()
        
        let indexPath = NSIndexPath.init(forItem: Utilities.getIndexForCurrentTime(), inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    /*************************************************************/
    // MARK: Helper Methods
    /*************************************************************/
    
    /**
     Method to setup the chart
     */
    private func setUpChart() {
        graphView.delegate = self
        // Configure the error texts & colors
        graphView.noDataText = "You need to provide data for the chart."
        graphView.descriptionText = "Maximum v/s Minimum"
        graphView.descriptionTextColor = UIColor.whiteColor()
        graphView.gridBackgroundColor = UIColor.clearColor()
        setUpChartData()
    }
    
    /**
     Configure the data that will be showcased in the chart
     */
    private func setUpChartData() {
        let weekForecast = model?.nextWeekForecast!
        
        var dates = Array<String>()
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for iterator in 0 ..< weekForecast!.count {
            yVals1.append(ChartDataEntry(value: Double(weekForecast![iterator].maximumTemperature_In_C!)!, xIndex: iterator))
            dates.append(weekForecast![iterator].date!)
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "Maximum Temperature")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.redColor()
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = true
        
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for iterator in 0 ..< weekForecast!.count {
            yVals2.append(ChartDataEntry(value: Double(weekForecast![iterator].minimumTemperature_In_C!)!, xIndex: iterator))
        }
        
        let set2: LineChartDataSet = LineChartDataSet(yVals: yVals2, label: "Minimum Temperature")
        set2.axisDependency = .Left // Line will correlate with left axis values
        set2.setColor(UIColor.greenColor().colorWithAlphaComponent(0.5))
        set2.setCircleColor(UIColor.greenColor())
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.greenColor()
        set2.highlightColor = UIColor.whiteColor()
        set2.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(xVals: dates, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        // Add animation
        graphView.animate(xAxisDuration: 1.5)
        //5 - finally set our data
        graphView.data = data
    }
}

/*************************************************************/
// MARK: Extension For TableView
/*************************************************************/
extension UpcomingForecastViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Only the next 5 days forecast will be displayed
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpcomingForecastCell", forIndexPath: indexPath) as! UpcomingForecastCell
        
        let dateWeather = model?.nextWeekForecast![indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.lblDayOfTheWeek.text = dateWeather?.date
        cell.lblMaximumTemperature.text = (dateWeather?.maximumTemperature_In_C)! + Constants.Strings.DEGREE
        cell.lblMinimumTemperature.text = (dateWeather?.minimumTemperature_In_C)! + Constants.Strings.DEGREE
        cell.imgVw.image = UIImage(named: (dateWeather?.weatherImageName)!)
        return cell
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 50
    }
}

/*************************************************************/
// MARK: Extension For CollectionView
/*************************************************************/
extension UpcomingForecastViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.nextWeekForecast!.first?.hourlyForecast!.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UpcomingForecastCollectionCell", forIndexPath: indexPath) as! UpcomingForecastCollectionViewCell
        let hourForecast = model?.nextWeekForecast!.first?.hourlyForecast![indexPath.row]
        
        cell.imgVw.image = UIImage(named: (hourForecast?.weatherImageName)!)
        cell.lblTemperature.text = (hourForecast?.temperature_In_C)! + Constants.Strings.DEGREE
        cell.lblTime.text = hourForecast?.time
        // Configure the cell
        return cell
    }
}
/*************************************************************/
// MARK: Extension For ChartView
/*************************************************************/
extension UpcomingForecastViewController : ChartViewDelegate {
    
}