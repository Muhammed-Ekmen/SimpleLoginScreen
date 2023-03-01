//
//  ViewController.swift
//  SimpleLoginScreen
//
//  Created by Semih Ekmen on 24.02.2023.
//

/*
Simple Login Screen.
I have created this project for see the usage of Delegate,AnimatedButton with extentions and ErrorHandling also HorizantalStack/VerticalStack
 
-+-+-+-+-+
DELEGATE USAGE
 * we have created 2 textField and 1 label. what we wanna is when we use the these textField, label will show what text is there?
 
 * Firstly, setUp the view and connect the ViewController. After that, give a `tag` to each textField. `tag` is so important when we wants to detect
 which textField currently using from User.
 
 * Second,in the viewDidLoad function, we gotta assing delegate to each textField. It is kind of stream or listener on Flutter.
 
 * Third, we have reached the textField function which comes from swift developers. That fucntion include shoulkdChangeChractersIn parameter. That is
 correct function. That is similar to hasOnChanged on the Flutter. it is providing us textField object that represent to current using textField.
 I have mentioned at the above abou the tag, we have detected with these tag values. After that, we have rewrite the quickInfo Label.
 

SHAKE ANIMATION BUTTON USAGE
 * we have created a button and connect ViewController with object and action.
 
 * we have created a extention from UIButton and shakeItBaby fucntion. that function include the shake animation. There are detail description
 on the function.
 
 * finally, when we wants to use animation on the button, only call function on buttonAction.
 
 
 ERROR HANDLING
    * we have created 2 textField. These are email and password. what we wanted is verification the email and password and throw error.
    * we have created custom login Error enums and an extention for checking the password and email format.
    * after that, in the loginbutton action, we have used the logIn function with do,try,catch. when we catch the any error, we have shown
    the error with alert.


HORIZANTALSTACK / VERTICAL STACK
    * These are kind of the Column and row. We can wrap more thanone compents.
*/

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var quickInfo: UILabel!
    @IBOutlet weak var shakeButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        do{
            try logIn()
        }catch LogInError.FillAllField{
            getAlert(message: "Please Fill The All Gap")
        }catch LogInError.EmailCheck{
            getAlert(message: "Please Check The Email")
        }catch LogInError.PasswordCheck{
            getAlert(message: "Please Check The Password")
        }catch let unknownError{
            getAlert(message: "UnKnown Error \(unknownError.localizedDescription)")
        }
    }
    
    @IBAction func shakeButtonAction(_ sender: UIButton) {
        shakeButton.shakeItBaby()   //we have called shake animation from button object.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            quickInfo.text = "Name=> \(textField.text ?? "NONE")\(string)"
        }
        if textField.tag == 1{
            quickInfo.text = "Surname=> \(textField.text ?? "NONE")\(string)"
        }
        return true
    }
    
    func setUpDelegates(){
        nameTextField.delegate=self
        surnameTextField.delegate=self
    }
    
    func getAlert(message:String){
        let alertCtrl:UIAlertController = UIAlertController(title: "ERROR", message: message, preferredStyle: UIAlertController.Style.alert)
        let alertOkButton:UIAlertAction = UIAlertAction(title: "I Got It", style: UIAlertAction.Style.default,handler: nil)
        alertCtrl.addAction(alertOkButton)
        present(alertCtrl, animated: true)
    }
    
    func logIn()throws{
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty && password.isEmpty {
            throw LogInError.FillAllField
        }
        else if email.emailVerification == false {
            throw LogInError.EmailCheck
        }
        else if password.passwordVerification == false {
            throw LogInError.PasswordCheck
        }else{
            getAlert(message: "You have logged successfully.")
        }
    }
}

extension UIButton{
    func shakeItBaby(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.repeatCount = 10                                                         //how many times it runs.
        shakeAnimation.autoreverses = true                                                     //reset button
        shakeAnimation.duration = 0.05                                                        //animation duration
        shakeAnimation.fromValue = CGPoint(x: self.center.x - 5.0, y: self.center.y - 5.0)   //beginning settings
        shakeAnimation.toValue = CGPoint(x: self.center.x + 5, y: self.center.y + 5)        //ending settings
        layer.add(shakeAnimation, forKey: "position")                                      //adding animation to current button.
    }
}

extension String{
    var emailVerification:Bool {
        let emailFormat:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        let result: Bool = predicate.evaluate(with: self)
        return result
    }
    var passwordVerification:Bool {
        let passwordFormat:String = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        let result = predicate.evaluate(with: self)
        return result
    }
}


enum LogInError:Error{
    case FillAllField,PasswordCheck,EmailCheck
}
