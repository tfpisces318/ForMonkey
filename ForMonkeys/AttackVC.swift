//
//  AttackVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/26.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AttackVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var ref:DatabaseReference!
    var js = ItemData.getAttackItem()
    var arrItem:[[String:String]] = []
    var arrName:[[String:String]] = []
    var enemyName:String?
    var enemyHp:Int16?
    var usedItemID:String?
    var didSelect:Bool = false
    var txtEnemyAccount:String?
    var txtEnemyHP:String?

    
    @IBOutlet weak var lblHp: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var mainPickerView: UIPickerView!
    @IBAction func btnHP(_ sender: UIButton) {
//        lblHp.text = txtEnemyHP
    }
    @IBAction func btnAtk(_ sender: Any) {
        ref = Database.database().reference()
        
        //alertcontroll
//        if arrItem.count == 0{
//            let alertController = UIAlertController(title: "沒有武器", message: "目前沒有武器", preferredStyle: .alert)
//            let callAction = UIAlertAction(title:"確認", style: .default) { (action) in}
//            alertController.addAction(callAction)
//            self.present(alertController, animated: true, completion: nil)
//        }else
        
        
        //判斷是否進didSelect
        if didSelect == false || Int(usedItemID!)! == 0{
            let alertController = UIAlertController(title: "請選擇武器", message: "尚未選擇武器", preferredStyle: .alert)
            let callAction = UIAlertAction(title:"確認", style: .default) { (action) in}
            alertController.addAction(callAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            // attackItemEffect
            lblHp.text = String(Int(enemyHp!) - ItemData.itemAttackEffect(itemID: Int(usedItemID!)!))
            
            enemyHp = Int16(Int(enemyHp!) - ItemData.itemAttackEffect(itemID: Int(usedItemID!)!))
            
            ref.child("Account").child(txtEnemyAccount!).updateChildValues(["Hp":enemyHp!])
            
            
            // remove UserItem
            var tmpUserItem = temp.UserInfo["Item"] as! [String]
            for i in 0...tmpUserItem.count - 1{
                if tmpUserItem[i] == usedItemID{
                    tmpUserItem.remove(at: i)
                    break
                }
            }
            temp.UserInfo["Item"] = tmpUserItem
            
            //remove arrItem reload coponent
            for i in 0...arrItem.count - 1{
                if usedItemID == arrItem[i]["ID"]{
                    arrItem.remove(at: i)
                    break
                }
            }
            
            mainPickerView.reloadAllComponents()
            mainPickerView.selectRow(0, inComponent: 1, animated: true)
            usedItemID = "0"
            
            
            
            //animation
            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
                self.imgView1.alpha = 1
                self.imgView2.alpha = 1
            }) { (Bool) in}
            
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseInOut, animations: {
                self.imgView1.center = CGPoint(x: self.imgView1.center.x + 130, y: self.imgView1.center.y)
            }) { (Bool) in}
            
            UIView.animate(withDuration: 1, delay: 2.4, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.imgView2.center = CGPoint(x: self.imgView2.center.x + 5, y: self.imgView2.center.y - 5)
            }) { (Bool) in}
            
        }
        
    }
    
    func textHPSet(){
        txtEnemyAccount = getAccount(name: enemyName!)
        txtEnemyHP = String(getHP(account: txtEnemyAccount!))
        lblHp.text = txtEnemyHP!
    }
    
    func getHP(account:String) -> Int16{
        ref = Database.database().reference()
        
        ref.child("Account").child(account).child("Hp").observeSingleEvent(of: .value, with: { (snap) in
            self.enemyHp = snap.value as? Int16
            self.lblHp.text = String(self.enemyHp!)
        })
        
        if enemyHp == nil{
            return 0
        }else{
            return enemyHp!
        }
    }
    
    func getAccount(name:String) -> String{
        var tmpAccount:String?
        for i in 0...arrName.count - 1{
            if arrName[i]["Name"] == name{
                tmpAccount = arrName[i]["Account"]
            }
        }
        return tmpAccount!
    }
    
    func getName(){
        ref = Database.database().reference()
        
        ref.child("Account").child("allAccount").observeSingleEvent(of: .value, with: { (snap) in
            self.arrName = (snap.value as? Array)!
            var arrLoc = 0
            for i in 0...self.arrName.count - 1{
                if self.arrName[i]["Account"] == temp.UserInfo["Account"] as? String{
                    arrLoc = i
                }
            }
            self.arrName.remove(at: arrLoc)
            self.enemyName = self.arrName[0]["Name"]

            self.textHPSet()
            self.lblHp.text = self.txtEnemyHP!
            
            self.mainPickerView.reloadAllComponents()
        })
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            enemyName = arrName[row]["Name"]!
        default:
            didSelect = true
            if arrItem.count == 0{
                usedItemID = nil
            }else{
                usedItemID = arrItem[row]["ID"]
            }
        }
        textHPSet()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if arrName.count == 0{
            return 0
        }else{
            switch component {
            case 0:
                return arrName.count
            default:
                if arrItem.count == 0{
                    return 0
                }else{
                    return arrItem.count
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if arrName.count == 0 {
            return ""
        }else{
            switch component {
            case 0:
                return arrName[row]["Name"]!
            default:
                if arrItem.count == 0{
                    return ""
                }else{
                    return arrItem[row]["name"]
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrItem = js
        arrItem.insert(["name":"請選擇武器","ID":"0"], at: 0)
        
        imgView1.alpha = 0
        imgView2.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getName()
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
