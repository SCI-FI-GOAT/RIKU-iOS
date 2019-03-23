//
//  JobPostsViewController.swift
//  Riku RH
//
//  Created by user on 13/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class JobPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userId:String = ""
    var jobsArray : NSArray = []
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
        // Recuperation de idUSER
        userId = UserDefaults.standard.string(forKey: "userId")!
        
        // Call jobList.php
        let url : String = IP.init().url+"ListePosts.php"
        let params:Parameters = ["user":LoginCondidateViewController.userId]
        Alamofire.request(url, method: .get, parameters:params ).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListePosts.php is sucess!")
                
                let results = response.result.value as! NSArray
                self.jobsArray = results
                self.tableViewJobs.reloadData()
            }
            else {
                print("Call ListePosts.php failed! Erreur :", response.result.error!)
            }
        }
    }
    
    
    
    
    // Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CondidateJobsBrowseCell")
        let contentView = cell?.viewWithTag(0)
        let labelJobName = contentView?.viewWithTag(1) as! UILabel
        let labelCompany = contentView?.viewWithTag(2) as! UILabel
        let labelLocation = contentView?.viewWithTag(3) as! UILabel
        let imageViewLogo = contentView?.viewWithTag(4) as! UIImageView
        let imageViewEtat = contentView?.viewWithTag(5) as! UIImageView
        
        let jobDict = jobsArray[indexPath.row] as! Dictionary<String,String>
        labelJobName.text = jobDict["titreOffre"]
        labelCompany.text = jobDict["nomEntreprise"]
        labelLocation.text = jobDict["LocationOffre"]
        imageViewLogo.af_setImage(withURL: URL(string:jobDict["imageEntreprise"]!)!)
        
        switch jobDict["etatPost"] {
        case "applied":
            imageViewEtat.image = UIImage(named: "orange")
            print("yellow")
        case "accepted":
            imageViewEtat.image = UIImage(named: "green")
            print("green")
        case "rejected":
            imageViewEtat.image = UIImage(named: "red")
            print("red")
        case "interviewed":
            imageViewEtat.image = UIImage(named: "blue")
            print("blue")
        default:
            imageViewEtat.image = UIImage(named: "orange")
        }
        
        return cell!
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let jobDict = jobsArray[indexPath.row] as! Dictionary<String,String>
        print(indexPath.row)
        switch jobDict["etatPost"] {
        case "applied":
            
            let alert = UIAlertController(title:"Details",message:"Youu have already applied to this offer, go to our website and pass the interview with RIKU ",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            print("hd")
            
        case "accepted":
            
            let alert = UIAlertController(title:"Details",message:"You are accepted",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            
            
        case "rejected":
            
            let alert = UIAlertController(title:"Details",message:"You are rejected",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            
            
        case "interviewed":
            
            let alert = UIAlertController(title:"Details",message:"You have already passed the interview, wait until the company take the decision",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
            
            
        default:
            
            
            let alert = UIAlertController(title:"Details",message:"I don't know what's this",preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel)
            alert.addAction(ok)
            
            self.present(alert, animated:true ,completion: nil)
        
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
           let jobDict = jobsArray[indexPath.row] as! Dictionary<String,String>
            
            if(jobDict["etatPost"]=="applied"){
                
                
                //APPEL WS DELETE
                // Call jobList.php
                let url : String = IP.init().url+"DeletePost.php?iduser="+LoginCondidateViewController.userId+"&idoffre="+jobDict["idOffre"]!
                let params:Parameters = ["user":LoginCondidateViewController.userId]
                Alamofire.request(url, method: .get, parameters:params ).responseJSON {
                    (response) in
                    if response.result.isSuccess {
                        print("Call DeletePost.php is sucess!")
                        let alert = UIAlertController(title:"Success",message:"Post deleted",preferredStyle: .alert)
                        let ok = UIAlertAction(title:"OK", style: .cancel)
                        alert.addAction(ok)
                        
                        self.present(alert, animated:true ,completion: nil)
                        self.viewWillAppear(true)
                    }
                    else {
                        //print("Call DeletePost.php failed! Erreur :", response.result.error!)
                        print("Call DeletePost.php is sucess! 2")
                        let alert = UIAlertController(title:"Success",message:"Post deleted",preferredStyle: .alert)
                        let ok = UIAlertAction(title:"OK", style: .cancel)
                        alert.addAction(ok)
                        
                        self.present(alert, animated:true ,completion: nil)
                        self.viewWillAppear(true)
                    }
                }
                
                
                
            
            
            }
            else{
                let alert = UIAlertController(title:"Error",message:"You cannot delete this post",preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
            }
            
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "bar_item_posts"), tag: 1)
    }
    
}

