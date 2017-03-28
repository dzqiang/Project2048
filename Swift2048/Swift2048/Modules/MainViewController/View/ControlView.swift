//
//  ControlView.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/16.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

class ControlView {

    //创建button
    class func creatButton(_ action:Selector,sender:UIViewController) ->UIButton {
        
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"retry"), for: UIControlState())
        button.setBackgroundImage(UIImage(named:"highlighted"), for: UIControlState.highlighted)
        button.addTarget(sender, action: action, for: UIControlEvents.touchUpInside)
        button.layer.cornerRadius=8;
        return button
    }
    //创建textfield
    class func creatTextField(value:String,action:Selector,sender:UITextFieldDelegate) -> UITextField{
    
        let textField = UITextField()
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true;
        textField.layer.borderColor = UIColor(red:254/255,green:204/255,blue:57/255,alpha:1).cgColor
        textField.textColor = UIColor.black
        textField.text = value
        textField.adjustsFontSizeToFitWidth = true//调整字体尺寸来适应宽度
        textField.delegate = sender
        return textField
        
    }
    //创建选项卡
    class func creatSegmented(items:[String],action:Selector,sender:UIViewController)->UISegmentedControl{
        
        let segment = UISegmentedControl(items:items)
        segment.isMomentary = false//按钮点击之后是否恢复原样
        segment.addTarget(sender, action: action, for: UIControlEvents.valueChanged)
        return segment
    }
    //创建label
    class func createLabel(_ title:String) ->UILabel{
        
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = title
        label.font = UIFont(name:"HelveticaNeue-Bold",size:14)
        return label
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
