//
//  GameTwoCell.swift
//  ForMonkeys
//
//  Created by 王家豪 on 2017/7/24.
//  Copyright © 2017年 王家豪. All rights reserved.
//

import UIKit

class GameTwoCell: UICollectionViewCell {
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = Double(
            UIScreen.main.bounds.size.width)
        
        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(
            x: 0, y: 10,
            width: w/4 - 10, height: w/4 - 10))
        self.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
