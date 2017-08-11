//
//  Game1VC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/12.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class GameOneVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{

    var mb = MemberInfo()
    
    var imgStr:[String] = []
    var rmdImg:[String] = []
    var gameCount:Int = 0
    var checkimg1:String?
    var checkimg2:String?
    var fullScreenSize :CGSize!
    var item1:Int?
    var item2:Int?
    var checkFinal:Int = 0
    var delayCheck:Timer?
    var gameTime:Timer?
    var checkGMtime:Timer?
    var checkCorect:[Int] = []
    var clickDelay:Bool = true
    var cantdoubleclick:Int = 100
    
    var Timecount = 50

    
    
    @IBOutlet weak var lblGameTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var mainCollectionview: UICollectionView!
    @IBOutlet weak var ruleView: UIView!
    
    @IBAction func btnStart(_ sender: Any) {
        mainCollectionview.isHidden = false
        FCgameTime()
        ruleView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell", for: indexPath)
                as! MyCollectionViewCell
        
        cell.imageView.image = UIImage(named: "close")
        
        //檢查一樣的圖片消失
        for i in checkCorect{
            if indexPath.row == i{
                cell.imageView.image = nil
            }
        }
        
        switch checkFinal {
        case 1:
            if indexPath.row == item1!{
                cell.imageView.image = UIImage(named: "close")
            }
            if indexPath.row == item2!{
                cell.imageView.image = UIImage(named: "close")
            }
        case 2:
            if indexPath.row == item1!{
                cell.imageView.image = nil
            }
            if indexPath.row == item2!{
                cell.imageView.image = nil
            }
        default:
            break
        }
        lblScore.text = String(checkCorect.count)
        //可以按了
        self.clickDelay = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        //配對成功的不能再按
        if cell.imageView.image != nil{
        
            if clickDelay == true{
                switch gameCount {
                case 0:
                    cell.imageView.image = UIImage(named: rmdImg[indexPath.row])
                    checkimg1 = rmdImg[indexPath.row]
                    item1 = indexPath.row
                    
                    //記錄按哪一個
                    gameCount += 1
                    
                    //記住按哪一個 第二個不能按同一個
                    cantdoubleclick = indexPath.row
                case 1:
                    if cantdoubleclick != indexPath.row{
                        cell.imageView.image = UIImage(named: rmdImg[indexPath.row])
                        checkimg2 = rmdImg[indexPath.row]
                        item2 = indexPath.row
                        gameCount -= 1
                        //目前不能按
                        clickDelay = false
                        
                        //延遲1秒
                        if #available(iOS 10.0, *) {
                            delayCheck = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (Timer) in
                                
                                //檢查有沒有一樣
                                if self.checkimg1 != self.checkimg2{
                                    self.checkFinal = 1
                                    collectionView.reloadData()
                                }else{
                                    self.checkFinal = 2
                                    self.checkCorect.append(self.item1!)
                                    self.checkCorect.append(self.item2!)
                                    collectionView.reloadData()
                                }
                                
                                
                            })
                        }
                        
                    }
                default: break
                }
                
            }

            
        }
        
        
    }
    
    
    func randomImg(){
        var nums = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        
        while nums.count > 0 {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            // your random number
            let randNum = nums[arrayKey]
            // rmdImg is array of random img string
            rmdImg.append(imgStr[randNum])
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
    
    }
    
    func random30(){
        var tmprmd = rmdImg
        rmdImg = []
        
        var nums = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
        
        while nums.count > 0 {
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            // your random number
            let randNum = nums[arrayKey]
            // rmdImg is array of random img string
            rmdImg.append(tmprmd[randNum])
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
    }
    
    func FCgameTime(){
        
        gameTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameOneVC.updateTime), userInfo: nil, repeats: true)
    }
    
    
    func stopTime(){
        var userItem:[String] = []
        
        if #available(iOS 10.0, *) {
            checkGMtime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
                if self.Timecount == 0 || self.checkCorect.count == 30{
                    self.gameTime?.invalidate()
                    Timer.invalidate()
                    
                    switch self.checkCorect.count {
                    case 0...10:
                        let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.checkCorect.count)分，分數太低，沒有獎勵！", preferredStyle: .alert)
                        let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                            
                            //update firebase
                            self.mb.userUpdate()
                            
                            //返回上一頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(callAction)
                        self.present(alertController, animated: true, completion: nil)
                    case 11...20:
                        userItem = temp.UserInfo["Item"] as! [String]
                        userItem.append("Apple")
                        temp.UserInfo["Item"] = userItem
                        
                        let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.checkCorect.count)分，得到的「蘋果」已送到物品欄", preferredStyle: .alert)
                        let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                            
                            //update firebase
                            self.mb.userUpdate()
                            
                            //返回上一頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(callAction)
                        self.present(alertController, animated: true, completion: nil)
                    case 21...29:
                        userItem = temp.UserInfo["Item"] as! [String]
                        userItem.append("Banana")
                        temp.UserInfo["Item"] = userItem
                        
                        let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.checkCorect.count)分，得到的「香蕉」已送到物品欄", preferredStyle: .alert)
                        let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                            
                            //update firebase
                            self.mb.userUpdate()
                            
                            //返回上一頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(callAction)
                        self.present(alertController, animated: true, completion: nil)
                    default:
                        userItem = temp.UserInfo["Item"] as! [String]
                        userItem.append("Orange")
                        temp.UserInfo["Item"] = userItem
                        
                        let alertController = UIAlertController(title: "時間到", message: "總得分：\(self.checkCorect.count)分，滿分得到的「橘子」已送到物品欄！", preferredStyle: .alert)
                        let callAction = UIAlertAction(title:"確認", style: .default) { (action) in
                            
                            //update firebase
                            self.mb.userUpdate()
                            
                            //返回上一頁
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(callAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            })
        }
    }
    
    func updateTime() {
        
        Timecount -= 1
        
        lblGameTime.text = "時間：\(Timecount)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopTime()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        // 取得螢幕的尺寸
        fullScreenSize =
            UIScreen.main.bounds.size
        //註冊cell
        mainCollectionview.register(
            MyCollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell")
        
        let layout = UICollectionViewFlowLayout()
        //設置section間距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //設置每一行距離
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //設置cell尺寸
        layout.itemSize = CGSize(width: fullScreenSize.width / 6.0 - 10, height: fullScreenSize.width / 6.0 + 10)
        
        mainCollectionview!.collectionViewLayout = layout
        mainCollectionview.isScrollEnabled = false
        
        //將照片加入陣列
        for i in 1...15{
            let str = "animal" + String(i)
            imgStr.append(str)
        }
        //put 30 random img in randomImg
        randomImg()
        randomImg()
        random30()
        
        mainCollectionview.isHidden = true
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
