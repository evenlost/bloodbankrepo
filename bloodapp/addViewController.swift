//
//  addViewController.swift
//  bloodapp
//
//  Created by HOME on 7/18/17.
//  Copyright © 2017 HOME. All rights reserved.
//

import UIKit

class addViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate {

    @IBOutlet weak var namefield: UITextField!   //A weak reference is just a pointer to an object that doesn't protect the object                                                             from being deallocated by ARC.
    
    @IBOutlet weak var contactfield: UITextField!
    
    @IBOutlet weak var bloodpicker: UIPickerView!
    
    var bloodbank: Bloodbank!
   
    
    let blood = ["A+" , "A-" , "B+" , "B-" , "AB+" , "AB-" , "o+" , "o-"] //creating array of blood type
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {   //picker view ko 1 ota matai basxa 2 halo vani 2ta awxa
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //blood vanni array ko row ayera basxa
        return blood[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //count garxa no. of items
        return blood.count
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodlabel.text = blood[row]
    }
    */
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.namefield.delegate = self as? UITextFieldDelegate
        self.contactfield.delegate = self as? UITextFieldDelegate
        
        if bloodbank != nil{    //print the value in bloodbank entity if not nil
            self.namefield.text = bloodbank.name
            self.contactfield.text = String(bloodbank.contact)
            
            //print value for pickerview
            let postionOfBloodInArray = blood.index(of: bloodbank.blood!)
            if(postionOfBloodInArray != nil){
                self.bloodpicker.selectRow(postionOfBloodInArray!, inComponent: 0, animated: false)//(inComponent: postionOfBloodInArray!)
            }
            
            //print(bloodbank)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addbtn(_ sender: Any) {  //adding action to button
        //guard self.namefield.text != ""  else {return}
        
        //alert if the field is empty
        if((namefield.text?.characters.count)! == 0 || (contactfield.text?.characters.count)! == 0 )
        {
            let alertController = UIAlertController(title: "text field is empty", message:"please fill the credential", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
            //alert if contact is less than 10digit number
            else if ((contactfield.text?.characters.count)! < 10 )
        {
            let alert = UIAlertController(title: "number must be 10 digits", message: "please fill the credential", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ignore and Add", style: UIAlertActionStyle.default, handler: ignorehandler))
            
            self.present(alert, animated: true, completion: nil)

            
            }
            
        else {
            
        addtobutton()
            
        }
    }

    //This is for the keyboard to GO AWAYY !! when user clicks anywhere on the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //This is for the keyboard to GO AWAYY !! when user clicks "Return" key  on the keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        namefield.resignFirstResponder()
        return true
    }
    
    //function for alert while pressing cancel
    
    func ignorehandler(alert: UIAlertAction)  {
       addtobutton()
       
    }
    
    //saving the value in entity
    func addtobutton()
        {
            if(bloodbank != nil){
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                bloodbank.name = namefield.text     //namefield ko data bloodbank entity ko name attribute ma save garcha.
                bloodbank.blood = blood[bloodpicker.selectedRow(inComponent: 0)]
                bloodbank.contact = Int64(contactfield.text!)!
                
                appDelegate.saveContext()
                
            }
                
            else
            {
                
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = Bloodbank(context: context)
            task.name = namefield.text
            task.contact = Int64(contactfield.text!)!
            task.blood = blood[bloodpicker.selectedRow(inComponent: 0)]
            //save the data
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext() //contex save garcha
            }
            
            navigationController!.popViewController(animated: true) //viewcontroller popup garcha
   
            }
    
    
    
}
