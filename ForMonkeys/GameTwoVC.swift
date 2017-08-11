//
//  GameTwoVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/24.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class GameTwoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var mainCollectView: UICollectionView!
    @IBOutlet weak var lblScore: UILabel!
    
    @IBAction func btnStart(_ sender: Any) {
        startTime()
        if #available(iOS 10.0, *) {
            checkTime()
        }
        ruleView.isHidden = true
    }
    
    let mb = MemberInfo()
    
    var gameTimer:Timer?
    var checkTimer:Timer?
    var overTime:Double = 50
    var score:Int = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = mainCollectView.cellForItem(at: indexPath) as! GameTwoCell

        if cell.imageView.image == UIImage(named: "zombiehand"){
            score += 1
            //score
            lblScore.text = String(score)
            cell.imageView.image = UIImage(named: "tombstone")
        }
        
        if cell.imageView.image == UIImage(named: "zombiehead"){
            score += 3
            //score
            lblScore.text = String(score)
            cell.imageView.image = UIImage(named: "tombstone")
        }
        if cell.imageView.image == UIImage(named: "god"){
            score -= 5
            //score
            lblScore.text = String(score)
            cell.imageView.image = UIImage(named: "tombstone")
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //rmd location
        var rmdLocation:Int = Int(arc4random_uniform(15))
        
        let cell = mainCollectView.dequeueReusableCell(
                withReuseIdentifier: "gametwo", for: indexPath)
                as! GameTwoCell
        
        cell.imageView.image = UIImage(named: "tombstone")
        
        switch overTime {
        case 35...49:
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
        case 11...34:
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "god")
            }
        case 1...10:
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehand")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "zombiehead")
            }
            rmdLocation = Int(arc4random_uniform(15))
            if indexPath.row == rmdLocation{
                cell.imageView.image = UIImage(named: "god")
            }
        default: break
            
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //每秒 - 1
    func updateTime() {
        
        overTime -= 0.7
        
        if overTime.truncatingRemainder(dividingBy: 1) == 0.7{
            lblTime.text = "時間：\(Int8(overTime + 0.3))"
        }else{
            lblTime.text = "時間：\(Int8(overTime))"
        }
        
    }
    //時間幾秒該做什麼事
    @available(iOS 10.0, *)
    func checkTime(){
        var userItem:[String] = []
        
        checkTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true, block: { (Timer) in
            switch self.overTime{
            case 1...50:
                self.mainCollectView.reloadData()
            case -1...0:
                self.gameTimer?.invalidate()
                Timer.invalidate()
                
                switch self.score{
                case -1000...29:
                    let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.score)分，分數太低，沒有獎勵！", preferredStyle: .alert)
                    let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                        
                        //update firebase
                        self.mb.userUpdate()
                        //返回上一頁
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true, completion: nil)
                case 30...59:
                    userItem = temp.UserInfo["Item"] as! [String]
                    userItem.append("Stone")
                    temp.UserInfo["Item"] = userItem
                    let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.score)分，獎勵物品『小石子』已送至物品欄", preferredStyle: .alert)
                    let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                        
                        //update firebase
                        self.mb.userUpdate()
                        //返回上一頁
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true, completion: nil)
                case 60...89:
                    userItem = temp.UserInfo["Item"] as! [String]
                    userItem.append("Stick")
                    temp.UserInfo["Item"] = userItem
                    let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.score)分，獎勵物品『木棒』已送至物品欄", preferredStyle: .alert)
                    let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                        
                        //update firebase
                        self.mb.userUpdate()
                        //返回上一頁
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true, completion: nil)
                case 89...500:
                    userItem = temp.UserInfo["Item"] as! [String]
                    userItem.append("Mace")
                    temp.UserInfo["Item"] = userItem
                    let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.score)分，獎勵物品『狼牙棒』已送至物品欄", preferredStyle: .alert)
                    let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                        
                        //update firebase
                        self.mb.userUpdate()
                        //返回上一頁
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(callAction)
                    self.present(alertController, animated: true, completion: nil)
                default:
                    break
                }
            default: break
            }
        })
        
    }
    //開始計時
    func startTime(){
        gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(GameTwoVC.updateTime), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MainView Width
        let viewWidth = Double(UIScreen.main.bounds.size.width)
        //註冊cell
        mainCollectView.register(
            GameTwoCell.self,
            forCellWithReuseIdentifier: "gametwo")
        //設置每一行距離
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        //item間距
        layout.minimumInteritemSpacing = 5
        //設置cell尺寸
        layout.itemSize = CGSize(width: viewWidth / 4.0 - 10, height: viewWidth / 4.0 - 10)
        
        mainCollectView.collectionViewLayout = layout
        mainCollectView.isScrollEnabled = false
        
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
