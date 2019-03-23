//
//  RegisterViewController.swift
//  Riku RH
//
//  Created by user on 04/05/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var txt_user: UITextField!
    @IBOutlet weak var txt_mail: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_linkedin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_toLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    
    @IBAction func btn_register(_ sender: Any) {
        
        
        let url = IP.init().url+"InsertUser.php"
        
        
        //String((result?.user.email)!)
        
        let user = String((txt_user!.text?.lowercased())!)
        let mail = String((txt_mail!.text?.lowercased())!)
        let pass = String((txt_password!.text)!)
        let li = String((txt_linkedin!.text?.lowercased())!)
        
        
        
        let parameters : Parameters = ["username":user,"email":mail,"linkedin":li,"password":pass]
        Alamofire.request(url, method: .post, parameters: parameters).responseString {
            (response) in
            if response.result.isSuccess {
                print(response)
                
                
                
                let alert = UIAlertController(title:"Error",message:response.description,preferredStyle: .alert)
                let ok = UIAlertAction(title:"OK", style: .cancel)
                alert.addAction(ok)
                
                self.present(alert, animated:true ,completion: nil)
                
                
            } else {
                print("InsertUser Failed!")
            }
        }
        
        
        
    }
    
    

}
