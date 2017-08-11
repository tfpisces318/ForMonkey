//
//  FirstVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/6/30.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirstVC: UIViewController,UITextFieldDelegate {

    var ref:DatabaseReference!
    var userDefault = UserDefaults.standard
    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func btnSignup(_ sender: Any) {
    
        firebaseLogin()
        
        let toSingupVC = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignupVC
        self.navigationController?.pushViewController(toSingupVC, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        var strAccount:String?
        var strPassword:String?
        strAccount = txtAccount.text
        strPassword = txtPassword.text

        
        if strAccount == "" || strPassword == ""{
            allert(title: "錯誤", msg: "請輸入帳號密碼", checktitle: "確認")
        }else{
            firebaseLogin()
            LoginCheck(account: strAccount!, password: strPassword!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //登入tfpisces318
    func firebaseLogin(){
        Auth.auth().signIn(withEmail: "tfpisces318@gmail.com", password: "vu4zj60315") { (user, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    func LoginCheck(account:String , password:String){
        ref = Database.database().reference()
        
        //檢查帳號
        ref.child("Account").observeSingleEvent(of: .value, with: { (snap) in
            if snap.hasChild(account){
                self.ref.child("Account").child(account).observeSingleEvent(of: .value, with: { (snap2) in
                    
                    let pwValue = snap2.value as! NSDictionary
                    let pw = pwValue.object(forKey: "Password") as! String

                    if password == pw{
                        let value = snap.value as! NSDictionary
                        //將使用者資料存進Dictionary
                        let obj = value.object(forKey: account) as! Dictionary<String,Any>
                        //將個人資料存成靜態
                        temp.UserInfo = obj
                        
                        /*
                        let Data = try? JSONSerialization.data(withJSONObject: obj, options: [])
                        let strData = String(data: Data!, encoding: .utf8)
                        
                        //創建資料夾
                        let manager = FileManager.default
                        let folderName = "UserAccount"
                        let dirName = self.documentsPath().appendingPathComponent(folderName)
                        //判斷是否有資料夾
                        do{
                            try manager.createDirectory(at: dirName, withIntermediateDirectories: true, attributes: nil)
                        }catch{
                            print("建立資料夾失敗")
                        }
                        print("建立資料夾成功")
                        
                        
                        //存取資料
                        let fileName:String = account + ".json"
                        
                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                            
                            let path = dir.appendingPathComponent("UserAccount").appendingPathComponent(fileName)
                            self.userDefault.set(path, forKey: "userInfo")
                            print(path)
                            do {
                                try strData?.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                        
                        */
 
                        //to mainVC
                        let toMainVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainVC
                        self.navigationController?.pushViewController(toMainVC, animated: true)
                        
                        

                    }else{
                        self.allert(title: "錯誤", msg: "密碼錯誤", checktitle: "確認")
                    }
                })
                
            }else{
                self.allert(title: "錯誤", msg: "帳號錯誤", checktitle: "確認")
            }
        })
    }
    
    
    // 取得路徑
    func documentsPath() -> URL{
        let documentDirectory = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        userDefault.set(documentDirectory, forKey: "pathOrderinfo")
        print(documentDirectory)
        return documentDirectory
    }
    
    // msg func
    func allert(title:String ,msg:String , checktitle:String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let callAction = UIAlertAction(title:checktitle, style: .default) { (action) in}
        alertController.addAction(callAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 180)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 180)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }

    //Job基本設定
    func getFirebaseJobDB(){
        var dicJob:Dictionary<String, Any> = [:]
        var count = 0
        ref = Database.database().reference()
        ref.child("JobInfo").observeSingleEvent(of: .value, with: { (snap) in
            let value = snap.value as? NSDictionary
            if value != nil{
                if count == 0 {
                    dicJob = value as! Dictionary<String, Any>
                    temp.JobInfo = dicJob as! [String : [String : Any]]
                    print(String(describing: temp.JobInfo["奴隸"]?["Hp"]))
                    count += 1
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFirebaseJobDB()
        
        self.txtAccount.delegate = self
        self.txtPassword.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
