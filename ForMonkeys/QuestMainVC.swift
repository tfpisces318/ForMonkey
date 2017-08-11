//
//  QuestMainVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/12.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class QuestMainVC: UIViewController {

    @IBAction func btnBack(_ sender: Any) {
  
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func toGame1(_ sender: Any) {
        let toGameOne = self.storyboard?.instantiateViewController(withIdentifier: "gameOne") as! GameOneVC
        self.navigationController?.pushViewController(toGameOne, animated: true)
        
    }
    @IBAction func toGametwo(_ sender: Any) {
        let toGameTwo = self.storyboard?.instantiateViewController(withIdentifier: "gametwo") as! GameTwoVC
        self.navigationController?.pushViewController(toGameTwo, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
