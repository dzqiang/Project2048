//
//  SettingViewController.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/15.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITextFieldDelegate {

    
    var txtNum:UITextField!
    var segDimension:UISegmentedControl!
    var mainView = MainViewController()
    
    init(mainView:MainViewController) {
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage:UIImage(named:"background")!)
        self.setupControls()
        // Do any additional setup after loading the view.
    }
    
    func setupControls() -> Void {
        let labelNum = ControlView.createLabel("阈值:")
        labelNum.frame = CGRect(x: 30, y: 100, width: 60, height: 30)
        self.view .addSubview(labelNum)
        
        txtNum = ControlView.creatTextField(value: "\(mainView.maxNumber)", action: Selector(("numChanged")), sender: self)
        txtNum.frame = CGRect(x: 90, y: 100, width: 255, height: 30)
        txtNum.returnKeyType = UIReturnKeyType.done
        
        self.view.addSubview(txtNum)
        
        let labelDm = ControlView.createLabel("维度:")
        labelDm.frame = CGRect(x: 30, y: 150, width: 60, height: 30)
        self.view .addSubview(labelDm)
        
        let segDimension = ControlView.creatSegmented(items: ["3x3","4x4","5x5"], action: #selector(SettingViewController.dimensionChanged(_:)), sender: self)
        segDimension.frame = CGRect(x: 90, y: 150, width: 255, height: 30)
        segDimension.tintColor = UIColor.orange
        segDimension.selectedSegmentIndex = 1
        self.view .addSubview(segDimension)
        
    }
    
    func dimensionChanged(_ segmented:UISegmentedControl) {
        
        var segVals = [3,4,5]
        print(segmented.selectedSegmentIndex)
        mainView.dimension = segVals[segmented.selectedSegmentIndex]
        //重置界面
        mainView.reStart()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        
        print("num Changed！")
        
        if textField.text != "\(mainView.maxNumber)" {
            let num = Int(textField.text!)
            mainView.maxNumber = num!
        }
        
        return true
        
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
