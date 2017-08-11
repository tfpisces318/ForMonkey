//
//  MemberInfoVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/10.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberInfoVC: UIViewController {

    var jsData = JSONData()
    
    @IBOutlet weak var lblHP: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var pgHP: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view radius 20.0
        uiView.layer.cornerRadius = 20.0
        //UserInfo
        lblName.text = temp.UserInfo["Name"] as? String
        lblGender.text = temp.UserInfo["Gender"] as? String
        lblJob.text = temp.UserInfo["Job"] as? String
        lblHP.text = String(describing: temp.UserInfo["Hp"]!) + "/" + String(describing: temp.UserInfo["Health"]!)
        
        let tmpHp:Int16 = temp.UserInfo["Hp"] as! Int16
        let tmpHealth:Int16 = temp.UserInfo["Health"] as! Int16
        
        pgHP.progress = Float(tmpHp) / Float(tmpHealth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFirebaseDB(){
        
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
