//
//  SignupVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/6/30.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseDatabase

class SignupVC: UIViewController ,UITextFieldDelegate{
    
    
    @IBOutlet weak var SegGender: UISegmentedControl!
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    var ref:DatabaseReference!
    var dicAccount:[String:Any] = [:]
    var arrItem:[String] = []
    var JobMoney:String?
    var Health:Int16?
    var Hp:Int16?
    
    var dicAllAccount:[String:String] = [:]
    var arrAllAccount:[[String:String]] = []
    
    @IBAction func btnJob(_ sender: Any) {
        
        let alertController = UIAlertController(title: "陷阱題", message: "確定要選擇職業？", preferredStyle: .alert)
        let callAction = UIAlertAction(title: "確定", style: .default) { (action) in
                let alertController2 = UIAlertController(title: "So Sad!", message: "職業隨機！", preferredStyle: .alert)
                let callAction = UIAlertAction(title: "無奈接受", style: .default) { (action) in}
                alertController2.addAction(callAction)
            self.present(alertController2, animated: true, completion: nil)
            }
        let callAction2 = UIAlertAction(title: "取消", style: .cancel) { (action) in}
        alertController.addAction(callAction)
        alertController.addAction(callAction2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        
        let js = jsFromJob.jsfromjob()
        let mbinfo = MemberInfo()
        mbinfo.Account = txtAccount.text
        mbinfo.Password = txtPassword.text
        mbinfo.rePassword = txtRePassword.text
        mbinfo.Name = txtName.text
        
        switch SegGender.selectedSegmentIndex {
        case 0:
            mbinfo.Gender = "男"
        case 1:
            mbinfo.Gender = "女"
        default:
            print("第三性")
        }
        
        //隨機變數
        let randomNum = Int(arc4random_uniform(4))
        mbinfo.Job = js?[randomNum]["職業"].string
        JobMoney = js?[randomNum]["金錢"].string
        Health = Int16((js?[randomNum]["生命"].string)!)
        Hp = Health
        
        
        for i in 0...(js?[randomNum]["物品"].count)! - 1{
            arrItem.append((js?[randomNum]["物品"][i].string)!)
        }
        
        //檢查
        if mbinfo.Account == nil || (mbinfo.Account?.characters.count)! <= 3 || (mbinfo.Account?.characters.count)! >= 13{
            allert(title: "帳號格式錯誤", msg: "帳號為4~12英數字", checktitle: "確認")
        }else if mbinfo.Password == nil || (mbinfo.Password?.characters.count)! <= 3 || (mbinfo.Password?.characters.count)! >= 13{
            allert(title: "密碼格式錯誤", msg: "密碼為4~12英數字", checktitle: "確認")
        }else if mbinfo.rePassword != mbinfo.Password{
            allert(title: "重複密碼錯誤", msg: "兩次密碼不相同", checktitle: "確認")
        }else if mbinfo.Name == nil || mbinfo.Name!.characters.count <= 1 || mbinfo.Name!.characters.count >= 9{
            allert(title: "暱稱格式錯誤", msg: "暱稱為2~8個中文", checktitle: "確認")
        }else{
            
            dicAccount["Account"] = mbinfo.Account
            dicAccount["Password"] = mbinfo.rePassword
            dicAccount["Name"] = mbinfo.Name
            dicAccount["Gender"] = mbinfo.Gender
            dicAccount["Job"] = mbinfo.Job
            dicAccount["Money"] = Int(JobMoney!)
            dicAccount["Item"] = arrItem
            dicAccount["Health"] = Health
            dicAccount["Hp"] = Hp
            
            //firebase所有帳號更新
            dicAllAccount["Account"] = mbinfo.Account
            dicAllAccount["Name"] = mbinfo.Name
            
            
            //firbase所有帳號下載
            ref = Database.database().reference()

            ref.child("Account").child("allAccount").observeSingleEvent(of: .value, with: { (snap) in
                
                self.arrAllAccount = (snap.value as? Array)!
                self.arrAllAccount.append(self.dicAllAccount)
                
            })
            
            
            // firebase check data
            
            ref.child("Account").observeSingleEvent(of: .value, with: { (snap) in
                if snap.hasChild(self.dicAccount["Account"]! as! String){
                    self.allert(title: "帳號重複", msg: "此帳號已申請過！", checktitle: "確認")
                }else{
                    //上傳資料
                    self.Signup(dic: self.dicAccount )
                    
                    let alertController = UIAlertController(title: "職業", message: "職業為：\(mbinfo.Job!)", preferredStyle: .alert)
                    let callAction = UIAlertAction(title:"確定", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    //back to lastPage
    func back(backCount:Int){
        let seeviewController:[UIViewController] = (self.navigationController?.viewControllers)!
        self.navigationController!.popToViewController(seeviewController[seeviewController.count - backCount], animated: true)
    }
    
    // firebase 上傳個人資料
    func Signup(dic:[String:Any]){
        ref = Database.database().reference()
        
        ref.child("Account").child(dic["Account"]! as! String).setValue(dic)
        ref.child("Account").child("allAccount").setValue(arrAllAccount)
    }
    
    // msg func
    func allert(title:String ,msg:String , checktitle:String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let callAction = UIAlertAction(title:checktitle, style: .default) { (action) in}
        alertController.addAction(callAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // job JSON
    class jsFromJob{
        
        class func jsfromjob() -> JSON?{
            var jsonData:JSON?
            let path = Bundle.main.path(forResource: "job", ofType: "json")
            let data1:Data
            
            do{
                try data1 = Data(contentsOf: URL(fileURLWithPath:
                    path!, isDirectory: false))
                jsonData = JSON(data: data1)
            }catch{
                print(error.localizedDescription)
            }
            return jsonData
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtAccount.delegate = self
        self.txtPassword.delegate = self
        self.txtRePassword.delegate = self
        self.txtName.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
