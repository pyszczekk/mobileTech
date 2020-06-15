//
//  MasterViewController.swift
//  CitiesWeatherApp
//
//  Created by Karolina Pieszczek on 08/06/2020.
//  Copyright © 2020 pyszczekk. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var addCityController : AddCityController? = nil
    var objects : [Any] = []
    var cityId :Array = ["523920", "638242","796597", "721943","851128","56558361","44418", "615702","1047378","1118370", "15015372","1199477","1940345", "2344116", "1105779", "1528488", "1532755", "9807","116545","2423945","2442047","2459115", "455825", "349859", "368148"]
    var cityName :Array = ["Warsaw", "Berlin", "Prague","Rome","Zagreb","Santorini", "London","Paris", "Jakarta", "Tokyo","Kyoto", "Manila", "Dubai","Istanbul", "Sydney", "Nairobi", "Casablanca", "Vancouver", "Mexico City", "Honolulu", "Los Angeles","New York", "Rio de Janeiro", "Santiago", "Bogota"]
   
    var addButton : UIBarButtonItem?
    var info=["",""];
    func configureView(){
        self.ApiConnection(id:self.cityId[0])
        self.ApiConnection(id:self.cityId[1])
        self.ApiConnection(id:self.cityId[2])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
             addCityController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? AddCityController
        }
        configureView();
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        //here add city
        performSegue(withIdentifier: "addView", sender: self)
 
    }
    
    func addCell(id: Int){
        DispatchQueue.main.async {
        
            self.objects.insert(self.cityName[id], at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        
           
    }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! String
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
              controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
 
            }
        }
        if(segue.identifier == "addView"){
    
            let controller = (segue.destination as! UINavigationController).topViewController as! AddCityController
              controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
              controller.navigationItem.leftItemsSupplementBackButton = true
              addCityController = controller
            controller.callback = { result in
                self.ApiConnection(id: self.cityId[self.cityName.firstIndex(of: result)!])
            }
           
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row] as! NSString
        
        cell.imageView?.image =  UIImage(named: "img/\(self.info[1]).png")
        cell.textLabel!.text = object.description + " "+(self.info[0])+"C";
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
  
    
    func ApiConnection(id : String){
        let urlString = "https://www.metaweather.com/api/location/"+id;
        var res = ["",""];
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
                                          let weather = responseDictionary["consolidated_weather"] as! [AnyObject]
                                            let first = weather[0] as! NSDictionary
                                        
                                        res[0] = "\(first.value(forKey: "the_temp")!)" as! String;
                                        res[1] = first.value(forKey: "weather_state_abbr") as! String
                                        self.info=res;
                                        self.addCell(id: self.cityId.firstIndex(of: id)!)
                                       } catch {
                                       }
                                   }
                               }
          task.resume()
      }


}

