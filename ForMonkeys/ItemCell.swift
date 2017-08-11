//
//  ItemCell.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/17.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    var titleLabel:UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 取得螢幕寬度
        let w = Double(
            UIScreen.main.bounds.size.width)
        
        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(
            x: 0, y: 0,
            width: w/4, height: w/4 - 10.0))
        self.addSubview(imageView)
        
        // 建立一個 UILabel
        titleLabel = UILabel(frame:CGRect(
            x: 0, y: w/4 - 12, width: w/4, height: 20))
        titleLabel.textAlignment = .center
//        titleLabel.textColor = UIColor.orange
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
