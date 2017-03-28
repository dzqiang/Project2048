//
//  TileView.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/16.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

class TileView: UIView {

    
//    2:UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1),
    let colroMap = [2:UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1),
                    4:UIColor(red: 190/255, green: 235/255, blue: 50/255, alpha: 1),
                    8:UIColor(red: 95/255, green: 235/255, blue: 100/255, alpha: 1),
                    16:UIColor(red: 0/255, green: 235/255, blue: 200/255, alpha: 1),
                    32:UIColor(red: 70/255, green: 200/255, blue: 250/255, alpha: 1),
                    64:UIColor(red: 70/255, green: 165/255, blue: 250/255, alpha: 1),
                    128:UIColor(red: 180/255, green: 110/255, blue: 255/255, alpha: 1),
                    256:UIColor(red: 235/255, green: 95/255, blue: 250/255, alpha: 1),
                    512:UIColor(red: 240/255, green: 90/255, blue: 155/255, alpha: 1),
                    1024:UIColor(red: 235/255, green: 70/255, blue: 75/255, alpha: 1),
                    2048:UIColor(red: 255/255, green: 135/255, blue: 50/255, alpha: 1)
                    ]
    
    
    var numberLabel:UILabel
    
    var value:Int = 0{
        didSet{
            backgroundColor = colroMap[value]
            numberLabel.text = "\(value)"
        }
    }
    
    //初始化标签
    init(pos:CGPoint,width:CGFloat,value: Int) {
        
        numberLabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: width))
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.minimumScaleFactor = 0.5//设置最小收缩比例
        numberLabel.font = UIFont(name:"HelveticaNeue-Bold",size:20)
        numberLabel.text = "\(value)"
        
        super.init(frame: CGRect(x: pos.x, y: pos.y, width: width, height: width))
        addSubview(numberLabel)
        self.value = value
        backgroundColor = colroMap[value]
        switch value {
        case 2,4:
            numberLabel.textColor = UIColor(red: 119/255, green: 110/255, blue: 101/255, alpha: 1)
            
            break
        default:
            numberLabel.textColor = UIColor.white
            
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
