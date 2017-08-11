//
//  itemData.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/26.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class jsFromItem{
    
    }


class ItemData{
    
    var cantUseItem:[String] = ["0","21","22","23"]
    
    // take user all item ID
    class func getAllItemID() -> [Int]{
        let tmpArr:[String] = temp.UserInfo["Item"]
         as! [String]
        var tmpID:Int?
        var ID:[Int] = []
        
        for i in 0...tmpArr.count - 1 {
            tmpID = Int(tmpArr[i])
            ID.append(tmpID!)
        }
        return ID
    }
    
    //take user attack item ID
    class func getAttackItemID() -> [Int]{
        var tmpID:Int?
        var ID:[Int] = []
        var tmpArr:[Int] = []
        tmpArr = ItemData.getAllItemID()
        for i in 0...tmpArr.count - 1{
            if tmpArr[i] >= 21 && tmpArr[i] <= 40{
                tmpID = tmpArr[i]
                ID.append(tmpID!)
            }
        }
        
        return ID
    }
    
    // 物品JSON資料
    class func jsfromitme() -> JSON?{
        var jsonData:JSON?
        let path = Bundle.main.path(forResource: "item", ofType: "json")
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
    
    //取得所有物品
    class func getItem() -> [[String:String]]{
        
        let js = ItemData.jsfromitme()
        var ID:String = ""
        var name:String = ""
        var content:String = ""
        var image:String = ""
        var title:String = ""
        var tempItem:[String]? = []
        var tempDic:[String:String] = [:]
        var arrItem:[[String:String]] = []
        
        
        tempItem = temp.UserInfo["Item"] as? [String]
        
        if tempItem == nil{
            arrItem = []
        }else{
            for i in tempItem!{
                
                ID = i
                name = (js?[i]["name"].string)!
                content = (js?[i]["content"].string)!
                image = (js?[i]["image"].string)!
                title = (js?[i]["title"].string)!
                
                tempDic["ID"] = ID
                tempDic["name"] = name
                tempDic["content"] = content
                tempDic["image"] = image
                tempDic["title"] = title
                
                arrItem.append(tempDic)
            }
        }
        return arrItem
    }

    //取得攻擊物品
    class func getAttackItem() -> [[String:String]]{
        
        let js = ItemData.jsfromitme()
        let arrAtk = ItemData.getAttackItemID()
        var ID:String = ""
        var name:String = ""
        var content:String = ""
        var image:String = ""
        var title:String = ""
        var tempItem:[String]? = []
        var tempDic:[String:String] = [:]
        var arrItem:[[String:String]] = []
        
        
        tempItem = temp.UserInfo["Item"] as? [String]
        
        if arrAtk.count == 0{
            return []
        }
        
        if tempItem == nil{
            arrItem = []
        }else{
            for i in tempItem!{
                for j in 0...arrAtk.count  - 1{
                    if i != String(arrAtk[j]){
                        continue
                    }
                    
                    ID = i
                    name = (js?[i]["name"].string)!
                    content = (js?[i]["content"].string)!
                    image = (js?[i]["image"].string)!
                    title = (js?[i]["title"].string)!
                    
                    tempDic["ID"] = ID
                    tempDic["name"] = name
                    tempDic["content"] = content
                    tempDic["image"] = image
                    tempDic["title"] = title
                    
                    arrItem.append(tempDic)
                }
            }
        }
        return arrItem
    }
    
    class func itemAttackEffect(itemID:Int) -> Int{
        switch itemID {
        case 0:
            return 0
        case 21:
            return 1
        case 22:
            return 2
        case 23:
            return 4
        default:
            return 0
        }
    }
    
    class func itemEffect(itemID:Int){
        let itemvc = ItemVC()
        
        switch itemID {
        // apple hp + 1
        case 1:
            var Hp:Int16?
            var Health:Int16?
            Hp = temp.UserInfo["Hp"] as? Int16
            Health = temp.UserInfo["Health"] as? Int16
            if Hp! >= Health!{
                Hp = Health
            }else{
                Hp! += 1
                temp.UserInfo["Hp"] = Hp!
            }
        case 2:
            var Hp:Int16?
            var Health:Int16?
            Hp = temp.UserInfo["Hp"] as? Int16
            Health = temp.UserInfo["Health"] as? Int16
            if Hp! >= Health!{
                Hp = Health
            }else{
                Hp! += 2
                temp.UserInfo["Hp"] = Hp!
            }
        case 3:
            var Hp:Int16?
            var Health:Int16?
            Hp = temp.UserInfo["Hp"] as? Int16
            Health = temp.UserInfo["Health"] as? Int16
            if Hp! >= Health!{
                Hp = Health
            }else{
                Hp! += 4
                temp.UserInfo["Hp"] = Hp!
            }
        default:
            break
        }
        
        //update firebase
        itemvc.mb.userUpdate()
    }
    
}
