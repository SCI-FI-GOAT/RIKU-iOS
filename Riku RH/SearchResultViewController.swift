//
//  SearchResultViewController.swift
//  Riku RH
//
//  Created by user on 13/04/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewJobs: UITableView!
    var searchArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewJobs.reloadData()
        print(searchArray)
        print("TEST")
        // Do any additional setup after loading the view.
        
        
        //Matching
        
        
        
        
        
    }
    
    // Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CondidateJobsBrowseCell")
        let contentView = cell?.viewWithTag(0)
        let labelJobName = contentView?.viewWithTag(1) as! UILabel
        let labelCompany = contentView?.viewWithTag(2) as! UILabel
        let labelLocation = contentView?.viewWithTag(3) as! UILabel
        let imageViewLogo = contentView?.viewWithTag(4) as! UIImageView
        
        let jobDict = searchArray[indexPath.row] as! Dictionary<String,String>
        labelJobName.text = jobDict["titreOffre"]
        labelCompany.text = jobDict["nomEntreprise"]
        labelLocation.text = jobDict["LocationOffre"]
        imageViewLogo.af_setImage(withURL: URL(string:jobDict["imageEntreprise"]!)!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toResultDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultDetail" {
            
            let DVC = segue.destination as! SearchResultDetailViewController
            let indice = sender as! IndexPath
            let jobDict = searchArray[indice.row] as! Dictionary<String,String>
            
            DVC.id = String(jobDict["idOffre"]!)
            DVC.logo = String(jobDict["titreOffre"]!)
            DVC.titre = String(jobDict["titreOffre"]!)
            DVC.nomEntreprise = String(jobDict["nomEntreprise"]!)
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
