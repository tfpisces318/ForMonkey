//
//  ItemVC.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/17.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    var js = ItemData.getItem()
    var mb = MemberInfo()
    var itemDT = ItemData()
    
    var fullScreenSize :CGSize!
    var isshow:Bool = false
    // array物品編號 arrItem[i]
    var selectRow:Int?
    // 選取的indexpath
    var itemindex:IndexPath?
    
    let itemView = UIView()
    let txtcontent = UITextView()
    let btnUse = UIButton()
    let btnClose = UIButton()
    
    //save item in arrItem
    var arrItem:[[String:String]] = []
    
    @IBOutlet weak var mainCollectionview: UICollectionView!
    
    // celldid
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemindex = indexPath
        
        if isshow == false{
            showItemContent(row: indexPath.row)
        }
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainCollectionview.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        cell.imageView.image = UIImage(named: arrItem[indexPath.row]["image"]!)
        cell.titleLabel.text = arrItem[indexPath.row]["name"]

        return cell
        
        
    }
    
    // section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // item in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrItem.count
    }
    
    func showItemContent
        (row:Int){
        
        selectRow = Int(arrItem[row]["ID"]!)
        
        itemView.isHidden = false
        var txtStr = "物品描述\n\n"
        
        
        //itemView setting
        itemView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 250)
        itemView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        itemView.center = self.view.center
        
        //lblcontent setting
        txtStr += arrItem[row]["content"]!
        txtcontent.text = txtStr
        txtcontent.font = UIFont.systemFont(ofSize: 20)
        txtcontent.textColor = UIColor.black
        txtcontent.backgroundColor = UIColor.clear
        txtcontent.frame = CGRect.init(x: 30, y: 25, width: 240, height: 220)
        txtcontent.isSelectable = false
        
        //btnOk setting
        btnUse.frame = CGRect.init(x: 50, y: 185, width: 80, height: 30)
//        btnUse.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        btnUse.setTitle("使用", for: .normal)
        btnUse.layer.cornerRadius = 10
        btnUse.titleLabel?.textColor = UIColor.black
        btnUse.backgroundColor = UIColor.lightGray
        btnUse.addTarget(self, action: #selector(useBtn), for: .touchUpInside)
        
        
        btnClose.frame = CGRect.init(x: 170, y: 185, width: 80, height: 30)
        btnClose.setTitle("關閉", for: .normal)
        btnClose.layer.cornerRadius = 10
        btnClose.titleLabel?.textColor = UIColor.black
        btnClose.backgroundColor = UIColor.lightGray
        btnClose.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
//        btnUse.titleLabel?.textColor = UIColor.black
        
        self.view.addSubview(itemView)
        itemView.addSubview(txtcontent)
        itemView.addSubview(btnUse)
        itemView.addSubview(btnClose)
        
        btnUse.isHidden = false
        
        //物品不能使用
        for i in 0...itemDT.cantUseItem.count - 1{
            if selectRow == Int(itemDT.cantUseItem[i]){
                btnUse.isHidden = true
            }
        }
        
        //目前出現
        isshow = true
    }
    
    //使用
    func useBtn(sender: UIButton!) {
        var title:String?
        var itemarr:[String] = []
        var tempInt:Int?
        _ = ItemData.itemEffect(itemID: selectRow!)
        
        itemarr = (temp.UserInfo["Item"] as? [String])!
        
        
//        itemEffect(itemID: selectRow!)
        title = arrItem[(itemindex?.row)!]["ID"]
        
        
        for i in 0...itemarr.count{
            if itemarr[i] == title{
                tempInt = i
                break
            }
        }
        arrItem.remove(at: (itemindex?.row)!)
        mainCollectionview.deleteItems(at: [itemindex!])

        itemarr.remove(at: tempInt!)
        temp.UserInfo["Item"] = itemarr
        
        
        isshow = false
        itemView.isHidden = true
        
        self.mb.userUpdate()
        mainCollectionview.reloadData()
    }
    
    //關閉
    func closeBtn(sender: UIButton!) {
        isshow = false
        itemView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得螢幕的尺寸
        fullScreenSize =
            UIScreen.main.bounds.size
        
        mainCollectionview.register(
            ItemCell.self,
            forCellWithReuseIdentifier: "itemCell")
        
        let layout = UICollectionViewFlowLayout()
        //設置section間距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //設置每一行距離
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        //設置cell尺寸
        layout.itemSize = CGSize(width: fullScreenSize.width / 4.0, height: fullScreenSize.width / 4.0 + 10)
        
        mainCollectionview!.collectionViewLayout = layout
        
        arrItem = js
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     arrItem 內容
     ID,name,content,image,title
    */
}
