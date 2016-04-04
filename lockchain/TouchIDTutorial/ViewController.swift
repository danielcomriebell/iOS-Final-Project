//
//  ViewController.swift
//  TouchIDTutorial
//
//  Created by Jason Rosenstein on 3/23/16.
//  Copyright © 2016 Frederik Jacques. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var uniqueID: UILabel!

    @IBOutlet weak var priv2: UILabel!
    @IBOutlet weak var pub2_hash: UILabel!
    @IBOutlet weak var priv1: UILabel!
    @IBOutlet weak var pub1_hash: UILabel!
    
    var pub1:String!
    var priv1raw:String!
    var pub2:String!
    var priv2raw:String!
    //let url_to_request:String = "http://trancendus.com:8081/api/pk"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var keychain = Keychain()
        keychain["deviceId"] = NSUUID().UUIDString // Set string
        var deviceId = keychain["deviceId"] // Get string       
        uniqueID.text = deviceId;
        

        ////////
        key_gen("http://trancendus.com:8081/api/pk")
        
        //download_request()
        
        //upload_request()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func key_gen(url_requested: String)
    {
        let url:NSURL = NSURL(string: url_requested)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            //let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(dataString)
            
            do {
                let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
                self.pub1 = jsonArray["alicePay"] as! String
                self.priv1raw = jsonArray["alicePriv"] as! String
                self.pub2 = jsonArray["bobPay"] as! String
                self.priv2raw = jsonArray["bobPriv"] as! String
                
                print("Array: \(self.pub1)")
                
                
                ////////
                dispatch_async(dispatch_get_main_queue()) {
                    self.pub1_hash.text = self.pub1
                    self.priv1.text = self.priv1raw
                    self.pub2_hash.text = self.pub2
                    self.priv2.text = self.priv2raw
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
        
        task.resume()
    }
    
    
    func download_request(url_requested: String)
    {
        let url:NSURL = NSURL(string: url_requested)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "data=Hello"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.downloadTaskWithRequest(request) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let urlContents = try! NSString(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
            
            guard let _:NSString = urlContents else {
                print("error")
                return
            }
            
            print(urlContents)
            
        }
        
        task.resume()
        
    }
    
    
    func upload_request(url_requested: String)
    {
        let url:NSURL = NSURL(string: url_requested)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let data = "data=Hi".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        task.resume()
        
    }


}
