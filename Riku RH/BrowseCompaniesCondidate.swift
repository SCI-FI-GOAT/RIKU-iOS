//
//  BrowseCompaniesCondidateViewController.swift
//  Riku RH
//
//  Created by user on 26/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class BrowseCompaniesCondidate: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var companiesArray : NSArray = []

    @IBOutlet weak var tableViewCompanies: UITableView!
    
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
        // Get Companies
        let url : String = IP.init().url+"ListeCompanies.php"
        Alamofire.request(url).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListCompanies.php : Success!")
                let results = response.result.value as! NSArray
                self.companiesArray = results
                self.tableViewCompanies.reloadData()
            }
            else {
                print("Erreur ! : ",response.result.error as Any)
            }
        }
    }
    
    
    // Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CondidateCompaniesBrowseCell")
        let contentView = cell?.viewWithTag(0)
        let labelName = contentView?.viewWithTag(1) as! UILabel
        let labelField = contentView?.viewWithTag(2) as! UILabel
        let imageViewLogo = contentView?.viewWithTag(3) as! UIImageView
        
        let companyDict = companiesArray[indexPath.row] as! Dictionary<String,String>
        
        imageViewLogo.af_setImage(withURL: URL(string: companyDict["imageEntreprise"]!)!)
        labelName.text = companyDict["nomEntreprise"]
        labelField.text = companyDict["mailEntreprise"]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCompanyDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCompanyDetail" {
            let indexPath = sender as! IndexPath
            let DVC = segue.destination as! CompanyDetailViewController
            let companyDict = companiesArray[indexPath.row] as! Dictionary<String,String>
            
            
            DVC.id = String(companyDict["idEntreprise"]!)
            DVC.nom = String(companyDict["nomEntreprise"]!)
            DVC.mail = String(companyDict["mailEntreprise"]!)
            DVC.logo = String(companyDict["imageEntreprise"]!)
    
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Companies", image: UIImage(named: "bar_item_companies"), tag: 3)
    }

}
