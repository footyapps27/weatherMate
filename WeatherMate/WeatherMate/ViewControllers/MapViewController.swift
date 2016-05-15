//
//  MapViewController.swift
//  WeatherMate
//
//  Created by Samrat on 4/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

/*************************************************************/
// MARK: Imported Classes
/*************************************************************/
import Foundation
import MapKit
import CoreLocation
import ICLoader

class MapViewController : BaseViewController,CLLocationManagerDelegate , MKMapViewDelegate, NSURLSessionDataDelegate, NSXMLParserDelegate {
    
    /*************************************************************/
    // MARK: Instance Variables
    /*************************************************************/
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    var buffer:NSMutableData!
    
    var modelCurrentWeather : CurrentWeather?
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var cityName = NSMutableString()
    var lat = NSMutableString()
    var long = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        self.getSetLocation()
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        self.mapView.scrollEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        getSetLocation()
    }
    func getSetLocation() {
        
        ICLoader.present()
        let locationCity = Singleton.sharedInstance.currentCity
        //print("city from shared instance : \(locationCity)")
        var center : CLLocationCoordinate2D?
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationCity!, completionHandler:
            {(placemarks : [CLPlacemark]?, error:NSError?) -> Void in
                if (error  !=  nil) {
                    let alert = UIAlertController(title: "Location Not Found!", message : "Try entering another location", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction!) in
                    }
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil);
                }
                else if let placemark = placemarks?[0] {
                    center = placemark.location!.coordinate
                    self.getWeatherInfoForLocation(center!, locationName: locationCity!)
                    let region = MKCoordinateRegionMake(center!,  MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0))
                    self.mapView.setRegion(region, animated: true)
                    self.getNearbyLocations(center!)
                }
        })
        
        //self.getNearbyLocations(center!)
        
    }
    
    func getWeatherInfoForLocation(location:CLLocationCoordinate2D, locationName:String) {
        
        var temp : String = "temp"
        //get weather info for all near by cities
        WeatherService.sharedInstance.getWeatherUpdatesForCity(locationName, onCompletion: { (data, error) in
            
            if(error == nil){
                self.modelCurrentWeather = CurrentWeather.init(json: data)
                temp  = (self.modelCurrentWeather?.temperature_In_C)! + Constants.Strings.DEGREE
                
                self.addAnotation(location, locationName: locationName, temp: temp)
            }
            
        })
        
    }
    
    func addAnotation(location:CLLocationCoordinate2D, locationName:String, temp : String){
        
        //add annotation
        var annotationView:MKAnnotationView!
        let pointAnnoation:MKPointAnnotation = MKPointAnnotation()
        
        pointAnnoation.coordinate = location
        pointAnnoation.title = locationName
        pointAnnoation.subtitle = temp
        annotationView = MKAnnotationView(annotation: pointAnnoation, reuseIdentifier: "pin")
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.mapView.addAnnotation(annotationView.annotation!)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func getNearbyLocations(location : CLLocationCoordinate2D) {
        
        
        let distance : Double = 1000
        let radius : Double = 6371
        let rad2Deg : Double = 180 / M_PI
        let deg2Rad : Double = M_PI/180
        let south = location.latitude + rad2Deg * (distance/radius)
        let north = location.latitude - rad2Deg * (distance/radius)
        let east = location.longitude + rad2Deg * (distance/radius/cos(deg2Rad*location.latitude))
        let west = location.longitude - rad2Deg * (distance/radius/cos(deg2Rad*location.latitude))
        
        //call to get nearby cities
        let urlAsString:String = String(format:"http://api.geonames.org/cities?north=\(north)&south=\(south)&east=\(east)&west=\(west)&lang=en&username=myusername")
        
        let url:NSURL = NSURL(string: urlAsString)!;
        let req:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        req.HTTPMethod = "GET"
        
        let defaultConfigObject:NSURLSessionConfiguration =
            NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: NSOperationQueue.mainQueue());
        self.buffer = NSMutableData();
        session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                
            }
            
            self.processResponse(url)
            self.showAnnnotations()
            ICLoader.dismiss()
            
        }).resume();
        
    }
    
    func processResponse(text:NSURL){
        //let posts = []
        let parser = NSXMLParser(contentsOfURL:text)!
        parser.delegate = self
        parser.parse()
        
    }
    
    
    // didStartElement
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("geoname")
        {
            elements = NSMutableDictionary()
            elements = [:]
        }
    }
    
    // foundCharacters
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("toponymName") {
            cityName.appendString(string)
        }
        if element.isEqualToString("lat") {
            lat.appendString(string)
        }
        if element.isEqualToString("lng") {
            long.appendString(string)
        }
        
    }
    
    // didEndElement
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("geoname") {
            if !cityName.isEqual(nil) {
                elements.setObject(cityName, forKey: "cityName")
            }
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: "lat")
            }
            if !long.isEqual(nil) {
                elements.setObject(long, forKey: "long")
            }
            posts.addObject(elements)
        }
        
    }
    func showAnnnotations(){
        
        var newCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.01, longitude: 0.01)
        let cityString = elements["cityName"] as! String
        //print("city string: \(cityString)")
        let cityStringArr = cityString.characters.split{$0 == "\n"}.map(String.init)
        let latString = elements["lat"] as! String
        let latStringArr = latString.characters.split{$0 == "\n"}.map(String.init)
        let longStr = elements["long"] as! String
        let longStrArr = longStr.characters.split{$0 == "\n"}.map(String.init)
        
        for var i in 0..<latStringArr.count {
            newCoordinate.latitude = Double(latStringArr[i])!
            newCoordinate.longitude = Double(longStrArr[i])!
            let city = cityStringArr[i]
            self.getWeatherInfoForLocation(newCoordinate,locationName: city)
            //self.addAnotation(newCoordinate,locationName: city)
        }
    }
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseIdentifier = "pin"
        //let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
            
        }
        else {
            v!.annotation = annotation
        }
        
        let icon = (modelCurrentWeather?.weatherImageName)
        
        //let customPointAnnotation = annotation as! CustomPointAnnotation
        v!.image = UIImage(named:"map-pin")
        v!.frame.size = CGSize(width: 30.0, height: 30.0)
        
        let base = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        base.backgroundColor = UIColor.lightGrayColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named:icon!)
        base.addSubview(imageView)
        v!.leftCalloutAccessoryView = base
        
        return v
    }
    
}
