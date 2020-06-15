//
//  AddCityController.swift
//  CitiesWeatherApp
//
//  Created by Karolina Pieszczek on 10/06/2020.
//  Copyright © 2020 pyszczekk. All rights reserved.
//
import UIKit
protocol AddCityDelegate {
  func cityName(value: String)
}
class AddCityController: UIViewController{
     var objects = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var list: UITableViewCell!
    var cityName:Array = ["Warsaw", "Berlin", "Prague","Rome","Zagreb","Santorini", "London","Paris", "Jakarta", "Tokyo","Kyoto", "Manila", "Dubai","Istanbul", "Sydney", "Nairobi", "Casablanca", "Vancouver", "Mexico City", "Honolulu", "Los Angeles","New York", "Rio de Janeiro", "Santiago", "Bogota"]
    @IBOutlet weak var table: UIStackView!
    @IBOutlet weak var city: UITextField!
    var callback : ((String)->())?
    var choosen = ""
    var delegate: AddCityDelegate?
    @IBAction func searchCity(_ sender: Any) {

        for c in self.cityName{
            let matched = self.matches(for: "\(self.city.text!)[a-z]*", in: c)
            if(!matched.isEmpty){
                objects.insert(c, at: 0)
            }
         }
        self.updateView()
        print("search");
    }
   
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    @IBAction func Back(_ sender: Any) {
     
        _ = self.navigationController?.navigationController?.popViewController(animated: true)

    }
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var nav: UINavigationItem!
    override func viewDidLoad() {
        table.translatesAutoresizingMaskIntoConstraints = false
        table.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true;
        table.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive=true;
        table.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true;
        table.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive=true;
        table.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive=true;
        table.spacing = 20
        updateView();
     print("view")
    }
    func updateView(){
         DispatchQueue.main.async{
            
            for r in self.table.subviews{
                self.table.removeArrangedSubview(r)
                r.removeFromSuperview()
            }
            for i in self.objects{
                let l = UILabel()
                l.text = i;
                l.textAlignment = .center
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                l.isUserInteractionEnabled = true
                l.addGestureRecognizer(tap)
                self.table.addArrangedSubview(l)
            }
            self.objects.removeAll();
        }
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let thisLabel = sender.view as! UILabel
        self.choosen=thisLabel.text!
        print(thisLabel.text!)
     
        self.delegate?.cityName(value: self.choosen)
        callback?(self.choosen)
        _ = self.navigationController?.navigationController?.popViewController(animated: true)
        
    }


    
}
