//
//  LoginCondidateViewController.swift
//  Riku RH
//
//  Created by user on 26/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class LoginCondidateViewController: UIViewController {

    static var userId : String = ""
    static var userLinkedin : String = ""
    
    
    @IBOutlet weak var txt_mail: UITextField!
    
    @IBOutlet weak var txt_password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_toSignin(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignin", sender: nil)
    }
    
    
    
    
    @IBAction func btn_login(_ sender: Any) {
        
        // Call jobList.php
        let url : String = IP.init().url+"LoginUser.php?mail=" + txt_mail.text!.lowercased() + "&password=" + txt_password.text!
        
        Alamofire.request(url, method: .get ).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call LoginUser.php is sucess!")
                
                let results = response.result.value as! NSArray
                
                print (results)
                let userDict = results[0] as! Dictionary<String,String>
                if (userDict["Email"] == self.txt_mail.text!.lowercased() && userDict["Email"] != "" ){
                    // Go to Home
                    
                    LoginCondidateViewController.userId = userDict["id"]!
                    LoginCondidateViewController.userLinkedin = userDict["Linkedin"]!
                    
                    
                    
                    
                    
                    /*
                    // Call damn.php
                    let url3 : String = IP.init().url+"damn.php"
                    let p : Parameters = ["url":LoginCondidateViewController.userLinkedin,"id":LoginCondidateViewController.userId]
                    Alamofire.request(url3, method: .post, parameters: p).responseString {
                        (response) in
                        switch response.result {
                        case .success:
                            print("SUCCESS1")
                            
                            break
                        case .failure(let error):
                            
                            print("SUCCESS2")
                        }
                    }
                    */
                    
                     //var currentUser = User (idUser: userDict["id"]!, mailUser: userDict["Email"]!, linkedinUser: userDict["Linkedin"]!, userName: userDict["userName"]!)
                    self.performSegue(withIdentifier: "goToHomeCondidate", sender: nil)
                    
                    
                }
                else{
                    let alert = UIAlertController(title:"Error",message:"Bad credentials",preferredStyle: .alert)
                    let ok = UIAlertAction(title:"OK", style: .cancel)
                    alert.addAction(ok)
                    
                    self.present(alert, animated:true ,completion: nil)
                    
                }
            }
            else {
                print("Call LoginUser.php failed! Erreur :", response.result.error!)
            }
        }
        
        
        
    }
    /*
    
    //Declaration IBActions
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
   
        // Call jobList.php
        let url : String = IP.init().url+"LoginUser.php?mail=" + txt_mail.text!.lowercased() + "&password=" + txt_password.text!
        
        Alamofire.request(url, method: .get ).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Call ListePosts.php is sucess!")
                
                let results = response.result.value as! NSArray
                
                print (results)
            }
            else {
                print("Call ListePosts.php failed! Erreur :", response.result.error!)
            }
        }*/
        
        

    
}
