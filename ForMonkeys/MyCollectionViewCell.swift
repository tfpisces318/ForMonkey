//
//  MyCollectionViewCell.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/12.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    var imageView:UIImageView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = Double(
            UIScreen.main.bounds.size.width)
        
        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(
            x: 0, y: 0,
            width: w/6 - 10, height: w/6 - 10))
        self.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
