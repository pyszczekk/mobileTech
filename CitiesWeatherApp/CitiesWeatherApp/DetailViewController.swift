//
//  DetailViewController.swift
//  CitiesWeatherApp
//
//  Created by Karolina Pieszczek on 08/06/2020.
//  Copyright © 2020 pyszczekk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

 
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var weatherName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var applicableDate: UILabel!
    @IBOutlet weak var airPressure: UILabel!

    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    let cityId:Array = ["523920", "638242","796597", "721943","851128","56558361","44418", "615702","1047378","1118370", "15015372","1199477","1940345", "2344116", "1105779", "1528488", "1532755", "9807","116545","2423945","2442047","2459115", "455825", "349859", "368148"]
    let cityName:Array = ["Warsaw", "Berlin", "Prague","Rome","Zagreb","Santorini", "London","Paris", "Jakarta", "Tokyo","Kyoto", "Manila", "Dubai","Istanbul", "Sydney", "Nairobi", "Casablanca", "Vancouver", "Mexico City", "Honolulu", "Los Angeles","New York", "Rio de Janeiro", "Santiago", "Bogota"]
    var counter = 0
    var weather : [AnyObject]?
    func configureView() {
       
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                self.navigationItem.title = detail.description
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prevButton.isEnabled = false
        self.prevButton.alpha = 0.5
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
            ApiConnection(id: cityId[cityName.firstIndex(of: detailItem!)!]);
        }
    }
    
  
    @IBAction func prevDay(_ sender: Any) {
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
    func ApiConnection(id : String){
        let urlString = "https://www.metaweather.com/api/location/" + id;                      let url = NSURL(string: urlString)!
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


}

