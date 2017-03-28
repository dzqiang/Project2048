//
//  scoreView.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/21.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

protocol ScoreViewProtocol {
   
    func changeScore(value s:Int)
}


class ScoreView: UIView,ScoreViewProtocol {

    var label:UILabel
    let defaultFrame = CGRect(x: 0, y: 0, width: 162, height: 30)
    var score: Int = 0 {
        didSet {
            label.text = "   分数：    \(score)"
        }
    }
    
    init() {
        
        label = UILabel(frame:defaultFrame)
        label.textAlignment = NSTextAlignment.left
        label.layer.borderColor = UIColor(red:254/255,green:204/255,blue:57/255,alpha:1).cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textColor = UIColor.black
        super.init(frame:defaultFrame)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScore(value s: Int) {
        score = s
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class BestScoreView: ScoreView {
    var bestScore:Int = 0{
        didSet{
            label.text = "   最高分：  \(bestScore)"
        }
    }
    
    override func changeScore(value s: Int) {
        bestScore = s
    }
    
}





