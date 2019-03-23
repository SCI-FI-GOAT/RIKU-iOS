//
//  CompanyDetailViewController.swift
//  Riku RH
//
//  Created by user on 31/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CompanyDetailViewController: UIViewController {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelNom: UILabel!
    @IBOutlet weak var labelDomaine: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelTel: UILabel!
    @IBOutlet weak var labelSiteWeb: UILabel!
    
    var logo : String = ""
    var nom : String = ""
    var mail : String = ""
    var id : String = ""
    
    
  
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageLogo.af_setImage(withURL: URL(string: logo)!)
        labelNom.text = nom
        labelMail.text = mail
        
        
        //labelTel.text = tel
       // labelSiteWeb.text = siteWeb
        //labelDomaine.text = domaine
        //textDescription.text = descrip
        //labelLocation.text = location
        
        
        //Get Profile info
        let url : String = IP.init().cv+id+".json"
        Alamofire.request(url, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Profile info success!")
                let resultDict = response.result.value as! Dictionary<String,Any>
                
                let personalInfo = resultDict["overview"] as! Dictionary<String,Any>
               /* let name = personalInfo["name"] as! String
                let headline = personalInfo["headline"] as! String
                let school = personalInfo["school"] as! String
                let image = personalInfo["image"] as! String*/
                self.labelTel.text = personalInfo["specialties"] as! String
                self.labelSiteWeb.text = personalInfo["website"] as! String
                self.labelDomaine.text = personalInfo["industry"] as! String
                self.textDescription.text = personalInfo["description"] as! String
                self.labelLocation.text = personalInfo["headquarters"] as! String
            }
            else {
                print("Failed to get Profile info!")
            }
        }
    }
    
    
    @IBAction func btn_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
