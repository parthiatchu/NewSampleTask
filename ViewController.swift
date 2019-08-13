//
//  ViewController.swift
//  SampleTask
//
//  Created by Bala on 05/08/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Username.delegate = self
        Password.delegate = self
       
    }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    @IBAction func submit_btn(_ sender: Any) {
        
        if (Username.text!.isEmpty) {
            Global.objGlobalMethod.Alertview(view: self, message: "Please Enter Username", title: "Alert")
        }else if (Password.text!.isEmpty){
            Global.objGlobalMethod.Alertview(view: self, message: "Please Enter Password", title: "Alert")
        }else if !(Username.text! == "john")  && !(Password.text! == "john") {
            Global.objGlobalMethod.Alertview(view: self, message: "Please check your username or password", title: "Alert")
        }else{
            if Connectivity.isConnectedToInternet {
                print("Connected")
                self .getLoginApiCalling()
            } else {
                print("No Internet")
                let alert = UIAlertController(title: "Alert", message:"Please check your internet connection or login via offline?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailvc")
                    self.navigationController?.pushViewController(detailVC!, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func getLoginApiCalling()  {
        
        let headers = ["consumer-key" : "mobile_dev",
                       "consumer-secret": "20891a1b4504ddc33d42501f9c8d2215fbe85008"]
        
        let parameters = ["eid" : 123456,
                          "name" : "john",
                          "idbarahno" : 123456,
                          "emailaddress" : "john.smith@mrhe.ae",
                          "unifiednumber" : 123,
                          "mobileno" : "971556987002"] as [String : Any]
        Global.objGlobalMethod.requestPOSTURL("https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api/iskan/v1/certificates/towhomitmayconcern", params: parameters as [String : AnyObject], headers: headers as [String : AnyObject]) { (response, Bool) in
            if (Bool != false){
                let check:Bool = response?["success"] as! Bool
                if (check == true) {
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailvc")
                    self.navigationController?.pushViewController(detailVC!, animated: true)
                }else{
                    
                }
            }else{
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailvc")
                self.navigationController?.pushViewController(detailVC!, animated: true)
            }
    }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet.letters
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


