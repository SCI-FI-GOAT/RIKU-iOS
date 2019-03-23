//
//  BrowseJobsCondidateViewController.swift
//  Riku RH
//
//  Created by user on 26/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class BrowseJobsCondidateViewConroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jobsArray : NSArray = []
    var matchedArray : NSArray = []
    @IBOutlet weak var tableViewJobs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // ViewWillApperar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
    }
    
    // setup view did load
    func viewLoadSetup(){
        // Call jobList.php
        let url : String = IP.init().url+"ListeOffres.php"
        Alamofire.request(url, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListJobs.php is sucess!")
                
                let results = response.result.value as! NSArray
                self.jobsArray = results
                //self.tableViewJobs.reloadData()
            }
            else {
                print("Call ListJobs.php failed! Erreur :", response.result.error!)
            }
        }
        var arr = NSMutableArray()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for i in 0 ... self.jobsArray.count - 1 {
                let jobDict = self.jobsArray[i] as! Dictionary<String,String>
                
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
                            arr.add(self.jobsArray[i])
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.matchedArray = arr
            print("arr = ",arr)
            self.tableViewJobs.reloadData()
        }
        
        
        
        
        
    }
    
 
    // Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CondidateJobsBrowseCell")
        let contentView = cell?.viewWithTag(0)
        let labelJobName = contentView?.viewWithTag(1) as! UILabel
        let labelCompany = contentView?.viewWithTag(2) as! UILabel
        let labelLocation = contentView?.viewWithTag(3) as! UILabel
        let imageViewLogo = contentView?.viewWithTag(4) as! UIImageView
        
        let jobDict = matchedArray[indexPath.row] as! Dictionary<String,String>
        labelJobName.text = jobDict["titreOffre"]
        labelCompany.text = jobDict["entreprise_id"]
        labelLocation.text = jobDict["LocationOffre"]
        imageViewLogo.af_setImage(withURL: URL(string:jobDict["imageEntreprise"]!)!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToJobDetailCondidate", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToJobDetailCondidate" {
            
            let DVC = segue.destination as! JobDetailCondidate
            let indice = sender as! IndexPath
            let jobDict = matchedArray[indice.row] as! Dictionary<String,String>

            DVC.id = String(jobDict["idOffre"]!)
            DVC.titre = String(jobDict["titreOffre"]!)
            DVC.nomEntreprise = String(jobDict["entreprise_id"]!)
            DVC.date = String(jobDict["dateOffre"]!)
            DVC.descrip = String(jobDict["descriptionOffre"]!)
            DVC.location = String(jobDict["LocationOffre"]!)
            DVC.type = String(jobDict["typeOffre"]!)
            DVC.langage = String(jobDict["langageOffre"]!)
            DVC.salaire = String(jobDict["salaireOffre"]!)
            DVC.experience = String(jobDict["experienceOffre"]!)
            DVC.technologies = String(jobDict["technologiesOffre"]!)
            DVC.logo = String(jobDict["imageEntreprise"]!)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(named: "bar_item_jobs"), tag: 1)
    }
    
}
