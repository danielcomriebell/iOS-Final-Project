//
//  qrgen.swift
//  LockChain
//  QR Generator
//
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import MessageUI

class qrgen: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var imgQRCode2: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    
    var qrcodeImage: CIImage!
    var qrcodeImage2: CIImage!
    
    let keychain = Keychain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 90))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "lockchain_title.png")
        
        self.navigationItem.titleView = titleView
        
        ViewController().get_newQRKey()
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.generateQR()
            
        })

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    func generateQR() {
        if qrcodeImage2 == nil || qrcodeImage == nil{
//            if textField2.text == "" || textField.text == "" {
//                return
//            }
            
//            let data = textField.text!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
//            let data2 = textField2.text!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            let data = keychain["pub2"]!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            let data2 = keychain["priv2"]!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            let filter2 = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            filter2!.setValue(data2, forKey: "inputMessage")
            filter2!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            qrcodeImage2 = filter2!.outputImage
            
//            textField.resignFirstResponder()
//            textField2.resignFirstResponder()
            
//            btnAction.setTitle("Clear", forState: UIControlState.Normal)
            
            displayQRCodeImage()
            displayQRCodeImage2()
        }
        else {
            imgQRCode.image = nil
            qrcodeImage = nil
            imgQRCode2.image = nil
            qrcodeImage2 = nil
            //btnAction.setTitle("Generate", forState: UIControlState.Normal)
        }
    
//        textField.enabled = !textField.enabled
//        textField2.enabled = !textField2.enabled
        slider.hidden = !slider.hidden
    }
    
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(slider.value), CGFloat(slider.value))
        imgQRCode2.transform = CGAffineTransformMakeScale(CGFloat(slider.value), CGFloat(slider.value))
    }
    
    
    // MARK: Custom method implementation
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
    }

    
    func displayQRCodeImage2() {
        let scaleX = imgQRCode2.frame.size.width / qrcodeImage2.extent.size.width
        let scaleY = imgQRCode2.frame.size.height / qrcodeImage2.extent.size.height
        
        let transformedImage2 = qrcodeImage2.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode2.image = UIImage(CIImage: transformedImage2)
        
    }
    
    @IBAction func send_email(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!])
//            let imageData = UIImagePNGRepresentation(imgQRCode.image!)!
            mail.setMessageBody("<p>Attach a Screenshot!</p>", isHTML: true)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
}

