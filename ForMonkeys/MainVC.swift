//
//  MainVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/10.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var MainView: UIView!
    
    var loadedVC:UIViewController?
    var backgroundColor:UIColor?
    
    @IBAction func btnItem(_ sender: UIButton) {
        if loadedVC != nil{
            self.MainView.willRemoveSubview((loadedVC?.view)!)
            loadedVC = nil
        }
        switch sender.tag {
        case 1:
            print("個人狀態")
            
            let mbvc = storyboard?.instantiateViewController(withIdentifier: "memberinfo") as! MemberInfoVC
            mbvc.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
//            self.addChildViewController(mbvc)
//            self.contentView.addSubview(mbvc.view)
            self.MainView.addSubview(mbvc.view)
            loadedVC = mbvc
//            self.present(mbvc, animated: true, completion: {
//            })
        case 2:
            print("聊天室")
            let chatvc = storyboard?.instantiateViewController(withIdentifier: "chatroom") as! ChatroomVC
            chatvc.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
            self.MainView.addSubview(chatvc.view)
            loadedVC = chatvc
            
        case 3:
            print("物品欄")
            let itemvc = storyboard?.instantiateViewController(withIdentifier: "item") as! ItemVC
            itemvc.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
            self.MainView.addSubview(itemvc.view)
            loadedVC = itemvc

        case 4:
            print("任務")
            let questmainvc = storyboard?.instantiateViewController(withIdentifier: "questmain") as! QuestMainVC
            self.navigationController?.pushViewController(questmainvc, animated: true)
        case 5:
            print("戰鬥")
            let attackvc = storyboard?.instantiateViewController(withIdentifier: "attack") as! AttackVC
            attackvc.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
            self.MainView.addSubview(attackvc.view)
            loadedVC = attackvc
        default:
            print("nothing")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let mbvc = storyboard?.instantiateViewController(withIdentifier: "memberinfo") as! MemberInfoVC
        mbvc.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
        //            self.addChildViewController(mbvc)
        //            self.contentView.addSubview(mbvc.view)
        self.MainView.addSubview(mbvc.view)
        loadedVC = mbvc
        
//        vcs.append(mbvc)
//        self.present(mbvc, animated: true) {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
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
