//
//  MainVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/8.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseDatabase

class ChatroomVC: UIViewController ,UITextFieldDelegate{
    var chattext:String = ""
    var txtOpt:String = ""
    var userDefault = UserDefaults.standard
    var Name:String?
    var ref:DatabaseReference!
    var jsData = JSONData()
    var time:Timer?

    @IBOutlet weak var optTxtview: UITextView!
    @IBOutlet weak var txtChat: UITextField!
    
    @IBOutlet weak var btnsend: UIButton!
    @IBAction func btnSend(_ sender: Any) {
        Name = temp.UserInfo["Name"] as! String
        //拿到聊天資料
        if txtChat.text != ""{
            SendgetChat()
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtChat.text != ""{
            btnsend.sendActions(for: .touchUpInside)
            txtChat.text = ""
        }
        return false
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
    
    func getChat(){
        ref = Database.database().reference()
        var chat = ""
        ref.child("ChatRoom").observeSingleEvent(of: .value, with: { (snap) in
            let value = snap.value as? NSDictionary
            if value != nil{
                chat = value?.object(forKey: "Chat") as! String
                temp.ChatInfo = chat
                self.optTxtview.text = temp.ChatInfo
                
                //將scrollview移到最下面
                let stringLength:Int = self.optTxtview.text.characters.count
                self.optTxtview.scrollRangeToVisible(NSMakeRange(stringLength - 1, 0))
            }
        })
    }
    
    func SendgetChat(){
        ref = Database.database().reference()
        var chat = ""
        ref.child("ChatRoom").observeSingleEvent(of: .value, with: { (snap) in
            let value = snap.value as? NSDictionary
            if value != nil{
                chat = value?.object(forKey: "Chat") as! String
                self.txtOpt = chat
                self.chattext = self.txtChat.text!    //輸入的聊天資料
                self.txtOpt += self.Name! + ":" + self.chattext + "\n\n"
                //上傳聊天資料
                self.sendChat(strChat: self.txtOpt)
                self.optTxtview.text = self.txtOpt
                self.txtChat.text = ""

                //將scrollview移到最下面
                let stringLength:Int = self.optTxtview.text.characters.count
                self.optTxtview.scrollRangeToVisible(NSMakeRange(stringLength - 1, 0))
                
            }
        })
    }
    
    func sendChat(strChat:String){
        ref = Database.database().reference()
        ref.child("ChatRoom").setValue(["Chat":strChat])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChat()
        //拿到聊天資料
        optTxtview.text = temp.ChatInfo
        
        self.txtChat.delegate = self
        //點擊縮小鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //textview滾輪移到最下面
        self.optTxtview.layoutManager.allowsNonContiguousLayout = false
        //textview padding
        optTxtview.textContainerInset = UIEdgeInsetsMake(20, 30, 20, 30)
        optTxtview.layer.cornerRadius = 20
        //每(x)s更新一次
        if #available(iOS 10.0, *) {
            time = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (Timer) in
                self.getChat()
            })
        }

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
