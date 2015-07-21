//
//  ViewController.swift
//  Meme
//
//  Created by Anya Gerasimchuk on 7/18/15.
//  Copyright (c) 2015 Anya Gerasimchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewPicker.image = image
            imageViewPicker.contentMode = UIViewContentMode.ScaleToFill
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    
    @IBOutlet weak var topTextField: UITextField!
    //@IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageViewPicker: UIImageView!
    //@IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),//TODO: Fill in appropriate UIColor,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName :1.9
            
        ]
        
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.delegate = self

        //topTextField.textAlignment(NSTextAlignment)
  
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        topTextField.text = ""
        bottomTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField .resignFirstResponder()
        bottomTextField .resignFirstResponder()
    
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
              cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                self.subscribeToKeyboardNotifications()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        //memes = appDelegate.memes.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
        
    }
    
   //ADD NOTIFICATIONS TO MOVE THE VIEW UP OR DOWN DEPENDING ON WHETHER THE KEYBOARD IS DISPLAYED OR HIDDEN
   
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    //cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

    @IBAction func pickAnimage() {
        let pickerController = UIImagePickerController()
        //pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        println("in second")
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }

    

    @IBAction func pickAnimage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
         //pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        

        
        self.presentViewController(pickerController, animated: true, completion: nil)
        println("in first")
          //self.dismissViewControllerAnimated(true, completion: nil)
        let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Save", forState: UIControlState.Normal)
        button.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
    }
    

    
 
    struct Meme {
        var topText:String?
        var bottomText:String?
        var originalImage:UIImage?
        var memedImage:UIImage
    }
    
    func save() {
        //Create the meme
        print("before memedImage")
        //let memedImage = generateMemedImage()
        //print(memedImage)
        var meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageViewPicker.image, memedImage: generateMemedImage())
        
        //Add it to the memes array in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
       //AppDelegate.
        
    }
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // render view to an image
        self.navigationController?.setToolbarHidden(true, animated: true)
        cameraButton.hidden = true
        toolBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        println("meme saved")
        cameraButton.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    }
    


