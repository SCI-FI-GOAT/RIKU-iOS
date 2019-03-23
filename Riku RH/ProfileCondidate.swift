//
//  ProfileCondidate.swift
//  Riku RH
//
//  Created by user on 26/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileCondidate: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHeadline: UILabel!
    @IBOutlet weak var labelProfileUrl: UILabel!
    @IBOutlet weak var labelSchool: UILabel!
    @IBOutlet weak var textExperiences: UITextView!
    @IBOutlet weak var textSkills: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get Profile info
        let url : String = IP.init().cv+LoginCondidateViewController.userId+".json"
        Alamofire.request(url, method: .get).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Profile info success!")
                let resultDict = response.result.value as! Dictionary<String,Any>
                let personalInfo = resultDict["personal_info"] as! Dictionary<String,Any>
                let name = personalInfo["name"] as! String
                let headline = personalInfo["headline"] as! String
                let school = personalInfo["school"] as! String
                let image = personalInfo["image"] as! String
                self.labelName.text = name
                self.labelHeadline.text = headline
                self.labelSchool.text = school
                self.imageView.af_setImage(withURL: URL(string: image)!)
                self.labelProfileUrl.text = LoginCondidateViewController.userLinkedin 
                
                
                let experiences = resultDict["experiences"] as! Dictionary<String,Any>
                let jobsArray = experiences["jobs"] as! NSArray
                // Recuperation de l'element 0 du tableau
                for i in 0 ..< jobsArray.count {
                    let jobDict = jobsArray[i] as! Dictionary<String,Any>
                    let jobName = jobDict["title"] as! String
                    let jobDateRange = jobDict["date_range"] as! String
                    let jobCompany = jobDict["company"] as! String
                    self.textExperiences.text = self.textExperiences.text+"\n"+jobDateRange+"\n"+jobName+"\n"+"At : "+jobCompany+"\n"
                }
                
                let skills = resultDict["skills"] as! NSArray
                for i in 0 ..< skills.count {
                    let skillDict = skills[i] as! Dictionary<String,Any>
                    let skillName = skillDict["name"] as! String
                    self.textSkills.text = self.textSkills.text+skillName+", "
                }
            }
            else {
                print("Failed to get Profile info!")
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "bar_item_profile"), tag: 4)
    }

}
