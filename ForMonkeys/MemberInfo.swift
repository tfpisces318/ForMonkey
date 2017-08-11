//
//  MemberInfo.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/6/30.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase
import FirebaseDatabase


/*
 
    temp.userInfo內容
    Account:string
    Gender:string
    Health:Int16
    Hp:Int16
    Item:[String]
    Job:string
    Money:Int
    Name:string
    Password:string
 
 */

class MemberInfo: UIViewController{
    
    //signup data
    var Account:String?
    var Password:String?
    var rePassword:String?
    var Name:String?
    var Gender:String?
    var Job:String?
    var JobMoney:Int?
    
    
    func userUpdate(){
        var ref = DatabaseReference()
        let account:String = temp.UserInfo["Account"] as! String
        let userinfo:[String:Any] = temp.UserInfo
        
        ref = Database.database().reference()
        
        ref.child("Account").child(account).setValue(userinfo)
    }
    
    
    
}

class JSONData{
    let userDefault = UserDefaults.standard
    
    func getUserInfo() -> JSON{
        var jsonData:JSON?
        let data:Data
        let path = userDefault.url(forKey: "userInfo")
        do{
            try data = Data(contentsOf: path!)
            jsonData = JSON(data: data)
        }catch{
            print(error.localizedDescription)
        }
        return jsonData!
    }
}


struct temp{
    static var ChatInfo:String?
    static var JobInfo:[String:[String:Any]] = [:]
    static var UserInfo:[String:Any] = [:]
    static var ItemInfo:[[String:String]] = []
}




