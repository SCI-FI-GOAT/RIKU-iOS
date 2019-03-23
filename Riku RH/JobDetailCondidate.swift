//
//  JobDetailCondidate.swift
//  Riku RH
//
//  Created by user on 27/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class JobDetailCondidate: UIViewController {
    
    // Declaration des variables
    var id : String = ""
    var logo : String = ""
    var titre : String = ""
    var nomEntreprise : String = ""
    var date : String = ""
    var descrip : String = ""
    var location : String = ""
    var type : String = ""
    var langage : String = ""
    var salaire : String = ""
    var experience : String = ""
    var technologies : String = ""
    
    // Declaration des IBOutlets
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelTitre: UILabel!
    @IBOutlet weak var labelNomEntreprise: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelLangage: UILabel!
    @IBOutlet weak var labelSalaire: UILabel!
    @IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelTechnologies: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageLogo.af_setImage(withURL: URL(string: logo)!)
        labelTitre.text = titre
        labelNomEntreprise.text = nomEntreprise
        labelDate.text = date
        textDescription.text = descrip
        labelLocation.text = location
        labelType.text = type
        labelLangage.text = langage
        labelSalaire.text = salaire
        labelExperience.text = experience
        labelTechnologies.text = technologies
        
    }
    @IBAction func applyPressed(_ sender: UIButton) {
        let userId = UserDefaults.standard.string(forKey: "userId")
        print(userId!)
        print(id)
        
        let url = IP.init().url+"InsertPost.php"
        let parameters : Parameters = ["iduser":LoginCondidateViewController.userId,"idoffre":id]
        Alamofire.request(url, method: .get, parameters: parameters).responseString {
            (response) in
            if response.result.isSuccess {
                print(response)
                let alert = UIAlertController(title:"Success",message:response.description,preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
            } else {
                print("InsertPost Failed!")
            }
        }
    }
    
    
    @IBAction func btn_back(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
}
