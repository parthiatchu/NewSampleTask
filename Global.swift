//
//  Global.swift
//  SampleTask
//
//  Created by Bala on 05/08/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Global: NSObject {
    
    static let objGlobalMethod = Global()
    
    func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, completion:@escaping (_ Dic: [String:Any]?,_ status:Bool) -> Void) {
        
        let url:String! = strURL
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: (headers as! HTTPHeaders)).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                //let resJson = JSON(responseObject.result.value!)
                let jsonResponse = responseObject.result.value as! NSDictionary
                completion((jsonResponse as! [String : Any]),true)
                
            }else{
                completion(nil,false)
            }
        }
    }
    
    func requestGETURL(_ strURL: String,headers:[String : String]?, completion:@escaping (_ Dic: [String:Any]?,_ status:Bool) -> Void)
    {
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = responseObject.result.value as! NSDictionary
                completion((jsonResponse as! [String : Any]),true)
                
            }else{
                completion(nil,false)
            }
        }
    }
    
    
    func Alertview(view:UIViewController,message:String,title:String)  {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
        
    }
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
}
