//
//  SearchJobViewController.swift
//  Riku RH
//
//  Created by user on 09/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class SearchJobViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var min :String = ""
    var max :String = ""
    var titre :String = ""
    var location :String = ""
    var contrat :String = ""
    var selectedPickerValue = ""
    
    var mySearchResult : NSArray = []
    var mySearchResultMatched : NSArray = []
    
    
    let contractArray = ["ALL","Full-time","Part-time","Internship","Freelance"]

    @IBOutlet weak var textFieldJobTitle: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldCompany: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelMaxSalary: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // UIPiker DataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contractArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contractArray[row]
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        labelMaxSalary.text = String(Int(sender.value))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerValue = contractArray[row]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "bar_item_search"), tag: 2)
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        min = "1"
        max = String(Int(slider.value))
        titre = textFieldJobTitle.text!
        location = textFieldLocation.text!
        contrat = selectedPickerValue
        
        let parameters : Parameters = ["min":min,"max":max,"titre":titre,"location":location,"contrat":contrat]
        let url = IP.init().url+"ListeRecherche.php"
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("ListRecherche Success!")
                let resultArray = response.result.value as! NSArray
                if resultArray.count > 0 {
                    self.mySearchResult = resultArray
                    //self.performSegue(withIdentifier: "toResult", sender: self)
                    
                } else {
                    let alert = UIAlertController(title: "Search", message: "No Result Found", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                print(resultArray)
            } else {
                print("ListRecherche Failed!")
            }
        }
        
        
        
        //MATCHING
        
        
        var arr = NSMutableArray()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if(self.mySearchResult.count>0){
           
            
            
            
            for i in 0 ... self.mySearchResult.count - 1 {
                let jobDict = self.mySearchResult[i] as! Dictionary<String,String>
                
                let tech = jobDict["langageOffre"]
                let exp = jobDict["experienceOffre"]
                
                let url : String = IP.init().url+"Matching.php?url="+IP.init().cv+LoginCondidateViewController.userId+".json&exp="+exp!+"&tech="+tech!
                print(url)
                Alamofire.request(url, method: .get).responseJSON {
                    (response) in
                    if response.result.isSuccess {
                        print("Call Matching.php is sucess!")
                        
                        let results = response.result.value as! NSObject
                        let matchDict = results as! Dictionary<String,Double>
                        print(matchDict["matching"]!)
                        
                        if(matchDict["matching"]!>=65){
                            //self.matchedArray.adding(self.jobsArray[i])
                            arr.add(self.mySearchResult[i])
                            //print("adding ",self.jobsArray[i])
                        }
                        
                        //self.jobsArray = results
                        //self.tableViewJobs.reloadData()
                    }
                    else {
                        print("Call Matching.php failed! Erreur :", response.result.error!)
                    }
                }
                
            }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.mySearchResultMatched = arr
            print("arr = ",arr)
            
            if self.mySearchResultMatched.count > 0 {
                self.performSegue(withIdentifier: "toResult", sender: self)
                
            } else {
                let alert = UIAlertController(title: "Search", message: "No Result Found", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            let DVC = segue.destination as! SearchResultViewController
            DVC.searchArray = mySearchResultMatched
        }
    }
}
