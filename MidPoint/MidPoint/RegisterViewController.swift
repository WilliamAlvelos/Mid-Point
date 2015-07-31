//
//  RegisterViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController, UserManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var pickerLibrary : UIImagePickerController?
    
    var user : User?
    
    
    @IBOutlet weak var buttonAdicioneUmaFoto: UIButton!
    private var  userManager :UserManager = UserManager()
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTexteField: UITextField!
    
    @IBOutlet var confirmPasswordTextFied: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var cancelarButton: UIButton!
    private func preloadUser(){
        self.nameTextField.text = user?.name
        self.emailTexteField.text = user?.email
        self.button.setBackgroundImage(user?.image, forState: UIControlState.Normal)
    self.buttonAdicioneUmaFoto.setTitle("Foto adicionada!", forState: .Normal)
        
    }
    @IBAction func cancelarAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.delegate = self
        self.view.backgroundColor = Colors.Azul
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        IHKeyboardAvoiding.setAvoidingView(self.view)
         UIMPConfiguration.addBorderToView(self.registerButton, color: Colors.Rosa, width: 3.0, corner: 25.0)
        UIMPConfiguration.addColorAndFontToButton(self.registerButton, color: Colors.Rosa, fontName: FontName.ButtonFont, fontSize: 20)
        UIMPConfiguration.addBorderAndMakeRounded(self.button, color: Colors.Rosa, width: 2)

        UIMPConfiguration.configureTextField(self.nameTextField, text: "qual o seu nome?")
        UIMPConfiguration.configureTextField(self.emailTexteField, text: "e o seu email?")
        UIMPConfiguration.configureTextField(self.passwordTextField, text: "crie uma super-senha")
        UIMPConfiguration.configureTextField(self.confirmPasswordTextFied, text: "confirme ela aqui")
        UIMPConfiguration.addColorAndFontToButton(self.buttonAdicioneUmaFoto, color: Colors.Rosa, fontName: FontName.LabelFont, fontSize: 14)
        UIMPConfiguration.addColorAndFontToButton(self.cancelarButton, color: Colors.Rosa, fontName: FontName.LabelFont, fontSize: 14)
        button.imageView?.alpha = 0.1
        
        if user == nil {
            user = User()
        }
        else {
            self.preloadUser()
        }
        
        self.title = "Create Account"
        
        
//        var buttonRegister: UIBarButtonItem = UIBarButtonItem(title: "Register", style: UIBarButtonItemStyle.Done, target: self, action: Selector("register"))
//        
//        self.navigationItem.rightBarButtonItem = buttonRegister
        
    }
    
    override func  viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
//        self.nameTextField.hidden = true
//        self.emailTexteField.hidden = true
//        self.passwordTextField.hidden = true
//        self.confirmPasswordTextFied.hidden = true
        

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        self.nameTextField.hidden = false
//        self.emailTexteField.hidden = false
//        self.passwordTextField.hidden = false
//        self.confirmPasswordTextFied.hidden = false
//
//        self.passwordTextField.center.x -= view.bounds.width
//        self.emailTexteField.center.x -= view.bounds.width
//        self.confirmPasswordTextFied.center.x -= view.bounds.width
//        self.nameTextField.center.x -= view.bounds.width
//        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.nameTextField.center.x = self.view.bounds.width/2
//            //self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.emailTexteField.center.x = self.view.bounds.width/2
//            //self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.5, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.passwordTextField.center.x = self.view.bounds.width/2
//            //self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.5, delay: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.confirmPasswordTextFied.center.x = self.view.bounds.width/2
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//
//        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func errorThrowed(error: NSError){
        
        if error.code == 3 || error.code == 4{
            println("BAD INTERNET")
        }else if error.code == 9 || error.code == 1{
            println("nao esta logado no icloud fdp")
        }else{
            println("internal error")
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
//        
//        self.nameTextField.hidden = true
//        self.emailTexteField.hidden = true
//        self.passwordTextField.hidden = true
//        self.confirmPasswordTextFied.hidden = true
//        
    }
    
    func userStillInserted(user: User){
        println("userStillInserted")
    }
    func saveUserFinished(user: User){
        //changeView("geolocation", animated: true)
        UserDAODefault.saveLogin(user)
        PictureCloudKit().uploadImageUser(user)
        TransitionManager(indentifier: "navigationHome", animated: true, view: self)
    }
    func userNotFound(user : User){
        println("userNotFound")
    }
    func changeImage(){
        
        var actionsheet: UIAlertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            
            self.pickerLibrary?.sourceType = .Camera
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        let roloCamera = UIAlertAction(title: "Rolo de camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            self.pickerLibrary?.sourceType = .PhotoLibrary
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,handler:{ (alert: UIAlertAction!) -> Void in
            println("cancelar")
        })
        
        actionsheet.addAction(cameraAction)
        actionsheet.addAction(roloCamera)
        actionsheet.addAction(cancelAction)
        
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func changeImage(sender: AnyObject) {
       
        self.changeImage()
    }
    
    
    @IBAction func tappedChangeImage(sender: AnyObject) {
        self.changeImage()
    }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let data : NSData = NSData(data: UIImageJPEGRepresentation(image, 1))
        data.writeToFile(self.imagePathURL().path!, atomically: true)
        
        button.setBackgroundImage(image, forState: .Normal)
        self.buttonAdicioneUmaFoto.setTitle("Foto adicionada!", forState: .Normal)

        //user?.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/userPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }

    
    
    
    
    func register(){
        if(self.nameTextField.text == ""){
            
            ActionError.actionWithTextField("Cuidado", errorMessage: "O seu Nome está vazio", placeholder: "Digite o seu Nome", textFieldView: self.nameTextField, view: self)
            
        }
        
        if(self.emailTexteField.text == ""){
            
            ActionError.actionWithTextField("Cuidado", errorMessage:"O email está Vazio", placeholder:"Digite seu email", textFieldView: self.emailTexteField, view: self)
            
        }
        
        if(passwordTextField.text == confirmPasswordTextFied.text || passwordTextField.text != ""){
            self.user?.name = nameTextField.text
            self.user?.email = emailTexteField.text
            userManager.insertUserDatabase(self.user!, password : passwordTextField.text)
            
            var progressView: ProgressView = ProgressView(frame: self.view.frame)
            
            progressView.backgroundColor = Colors.Rosa
            
            self.view = progressView
            
            self.navigationController?.navigationBarHidden = true
        }
    
    }
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        if(self.nameTextField.text == ""){
            
            ActionError.actionWithTextField("Cuidado", errorMessage: "O seu Nome está vazio", placeholder: "Digite o seu Nome", textFieldView: self.nameTextField, view: self)
            
        }
        
        if(self.emailTexteField.text == ""){
            
            ActionError.actionWithTextField("Cuidado", errorMessage:"O email está Vazio", placeholder:"Digite seu email", textFieldView: self.emailTexteField, view: self)
            
        }
        
        if(self.passwordTextField.text == ""){
            
            ActionError.actionWithTextFieldSecure("Cuidado", errorMessage:"A Senha está Vazia", placeholder:"Digite sua Senha", textFieldView: self.passwordTextField, view: self)
        }
        
        if(self.confirmPasswordTextFied.text == ""){
            
            ActionError.actionWithTextFieldSecure("Cuidado", errorMessage:"A Confirmaçāo da senha está Vazia", placeholder:"Digite sua Senha", textFieldView: self.confirmPasswordTextFied, view: self)
        }
        
        
        if((passwordTextField.text == confirmPasswordTextFied.text) || passwordTextField.text != ""){
            self.user?.name = nameTextField.text
            self.user?.email = emailTexteField.text
            userManager.insertUserDatabase(self.user!, password : passwordTextField.text)
            
        }
        
    }
    func progressUpload(float: Float) {
        println(float)
        
        var progressView: ProgressView = ProgressView(frame: self.view.frame)
        
        self.view = progressView
        
        self.navigationController?.navigationBarHidden = true
        
        progressView.animateProgressView(float)
        
    }
    func saveUserFinished() {
        var alertController = UIAlertController(title: "Sucesso", message: "Usuario Criado com Sucesso", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            TransitionManager(indentifier: "navigationHome", animated: false, view: self)
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    func errorThrowedServer(stringError : String){
        println(stringError)
    }

    
}
