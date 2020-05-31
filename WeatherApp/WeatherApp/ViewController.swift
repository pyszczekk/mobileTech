//
//  ViewController.swift
//  WeatherApp
//
//  Created by Karolina Pieszczek on 28/05/2020.
//  Copyright © 2020 pyszczekk. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

     
 
    @IBOutlet weak var weatherName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var applicableDate: UILabel!
    @IBOutlet weak var airPressure: UILabel!
    var counter = 0
    var weather : [AnyObject]?
    override func viewDidLoad() {
           super.viewDidLoad()
        //do sth
        print("hello world")
       
        self.prevButton.isEnabled = false
        self.prevButton.alpha = 0.5
        self.ApiConnection()
       
        
    }
    
    func ApiConnection(){
        let urlString = "https://www.metaweather.com/api/location/523920"
                      
                      let url = NSURL(string: urlString)!
                      var request = URLRequest(url: url as URL)
                      request.setValue("application/json", forHTTPHeaderField: "Accept")
                      request.httpMethod = "GET"
                       let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                                 guard let data = data, error == nil else {
                                     print("cannot connect")
                                     return
                                 }
                                 if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                                    print(httpStatus.statusCode)
                                 }else{
                                     do {
                                      var responseDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                        self.weather = responseDictionary["consolidated_weather"] as! [AnyObject]
                                         self.GetWeather(id: self.counter)
                                      
                                     } catch {
                                     }
                                 }
                             }
        task.resume()
      
    }

    @IBAction func previousDay(_ sender: Any) {
         self.nextButton.isEnabled = true
        self.nextButton.alpha = 1
        if(self.counter>0){
            self.counter = self.counter - 1
            self.GetWeather(id: self.counter)
            if(self.counter==0){
                 self.prevButton.isEnabled = false
                self.prevButton.alpha = 0.5
            }
        }
    }
    
    @IBAction func nextDay(_ sender: Any) {
         self.prevButton.isEnabled = true
        self.prevButton.alpha = 1
        if(self.counter<5){
            self.counter = self.counter + 1
            self.GetWeather(id: self.counter)
            if(self.counter==5){
                 self.nextButton.isEnabled = false
                self.nextButton.alpha = 0.5
            }
        
        }
    }
    func GetWeather(id: Int) -> Void{
        let first = self.weather?[id] as! NSDictionary
                   
         DispatchQueue.main.async {
            self.applicableDate.text = "\(first.value(forKey: "applicable_date")!)"
            self.minTemp.text = "min Temp: \(first.value(forKey: "min_temp")!) C"
            self.maxTemp.text = "max Temp: \(first.value(forKey: "max_temp")!) C"
            self.airPressure.text = "air pressure: \(first.value(forKey: "air_pressure")!) hPa"
            self.humidity.text = "humidity: \(first.value(forKey: "humidity")!) %"
            self.wind.text = "\(first.value(forKey: "wind_speed")!) km/h \(first.value(forKey: "wind_direction_compass")!)"
            self.weatherName.text = "\(first.value(forKey: "weather_state_name")!) "
            self.weatherImage.image = UIImage(named:"img/\(first.value(forKey: "weather_state_abbr")!).png")
            
        }
    }
  
    
    

}

