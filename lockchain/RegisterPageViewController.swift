//
//  RegisterPageViewController.swift
//  LockChain
//
//

import UIKit

class RegisterPageViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userEmailTextField: UITextField!

    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 90))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "lockchain_title.png")
        
        self.navigationItem.titleView = titleView

        
        self.repeatPasswordTextField.delegate = self;
        self.userPasswordTextField.delegate = self;
        self.userEmailTextField.delegate = self;
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder();
//        print("hello");
        return true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
        super.touchesBegan(touches, withEvent: event);
    }
    
    
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = repeatPasswordTextField.text;
        
        
        //check for empty fields
        
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty){
            
            
            displayMyAlertMessage("All fields are required");
            return;
        }
        
        
        if (userPassword != userRepeatPassword){
            
            displayMyAlertMessage("Passwords do not match");
            return;
        }
        
        
        
        
        
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "userEmail");
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        
        var myAlert = UIAlertController(title: "Alert", message: "Registration is successful", preferredStyle: UIAlertControllerStyle.Alert);
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            action in self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion:nil);
        
        
        
    }
    
    
    func displayMyAlertMessage(userMessage: String){
        
        
        var myAlert = UIAlertController(title: "ERROR", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated:true, completion: nil);
    }


}
