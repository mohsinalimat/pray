//
//  Timing.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Timing: NSObject {
    
    struct DailyTiming {
        var Fajr: String
        var Sunrise: String
        var Dhuhr: String
        var Asr: String
        var Maghrib: String
        var Isha: String
        var Imsak: String
        
        init(dictionary: [String: AnyObject]) {
            self.Fajr = dictionary["Fajr"] as! String
            self.Sunrise = dictionary["Sunrise"] as! String
            self.Dhuhr = dictionary["Dhuhr"] as! String
            self.Asr = dictionary["Asr"] as! String
            self.Maghrib = dictionary["Maghrib"] as! String
            self.Isha = dictionary["Isha"] as! String
            self.Imsak = dictionary["Imsak"] as! String
            
        }
    }
    
    static var calendar: [[String: AnyObject]]? = nil {
        didSet {
            let today = calendar![0] as [String: AnyObject]
            let todayTimingsDictionary = today["timings"] as! [String: AnyObject]
            Timing.today = Timing.DailyTiming.init(dictionary: todayTimingsDictionary)
        }
    }
    
    static var today: DailyTiming? = nil
    
    override init() {
        super.init()
    }
    
    static func fetchCalendar(location: CLLocation, completion: @escaping (_ calendar: ([[String: AnyObject]])?, _ error: NSError?) -> Void) {
        
        let latitude = location.coordinate.latitude.description
        let longitude = location.coordinate.longitude.description
        
        guard let timeZone = Location.currentTimeZone else {
            return
        }
        
        let parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "timezonestring": timeZone,
            "method": "2",
            "month": "6",
            "year": "2017",
            ]
        
        AladhanClient.taskForGETMethod(parameters: parameters as [String : AnyObject], method: "calendar", completion: { (result, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let data = result!["data"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
                return
            }
            
            completion(data, nil)
        })
    }

}