//
//  DetailViewController.swift
//  SampleTask
//
//  Created by Bala on 06/08/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tbl_view: UITableView!
    var Image_array = [AnyObject] ()
    var title_array = [AnyObject] ()
    var description_array = [AnyObject]()
    var userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_view.delegate = self
        tbl_view.dataSource = self
        // Do any additional setup after loading the view.
        if Connectivity.isConnectedToInternet {
            print("Connected")
             self.getCallingDetailWebService()
        } else {
            print("No Internet Connected")
            let defaults = UserDefaults.standard
            if ((defaults.stringArray(forKey: "Image_array")) != nil) && ((defaults.stringArray(forKey: "title_array")) != nil) {
                Image_array = defaults.stringArray(forKey: "Image_array")! as [AnyObject]
                title_array = defaults.stringArray(forKey: "title_array")! as [AnyObject]
            }
            if (Image_array.count != 0){
                
            }else{
                let alert = UIAlertController(title: "Alert", message:"No Offline record available.Please login one time via with network", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    func getCallingDetailWebService()  {
        
        let headers = ["consumer-key" : "mobile_dev",
                       "consumer-secret": "20891a1b4504ddc33d42501f9c8d2215fbe85008"]
        Global.objGlobalMethod.requestGETURL("https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api/public/v1/news?local=en", headers: headers) { (response, Bool) in
            if (Bool != false){
                let check:Bool = response?["success"] as! Bool
                if (check == true) {
                    let payload = response!["payload"] as! NSArray
                    self.Image_array = [payload .value(forKey:"image")][0] as! [AnyObject]
                    self.title_array = [payload.value(forKey: "title")][0] as! [AnyObject]
                    self.description_array = [payload.value(forKey: "description")] as! [AnyObject]
                    let defaults = UserDefaults.standard
                    defaults.set(self.Image_array, forKey: "Image_array")
                    defaults.set(self.title_array, forKey: "title_array")
                    self.tbl_view.reloadData()
                }else{
                    
                }
            }else{
                
            }
        }
    }
    
    @IBAction func bck_btn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Image_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tbl_view.dequeueReusableCell(withIdentifier: "Customcell") as! CustomTableViewCell
        cell.title_lbl.text! = title_array[indexPath.row] as! String
        let url = URL(string: Image_array[indexPath.row] as! String)
        cell.img.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}



