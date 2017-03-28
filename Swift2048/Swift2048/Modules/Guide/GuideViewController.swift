//
//  GuideViewController.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/15.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate {

    var numPages = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        
        let scrollerView = UIScrollView(frame:frame)
        scrollerView.contentSize = CGSize(width:frame.size.width * CGFloat(numPages),height:frame.size.height)
        scrollerView.delegate = self;
        scrollerView.isPagingEnabled = true
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.scrollsToTop = false
        for i in 0..<numPages{
            let imgfile = "welcome0\(Int(i)).png"
            let image = UIImage(named:"\(imgfile)")
            let imageView = UIImageView(image:image)
            imageView.frame=CGRect(x:CGFloat(i)*frame.size.width,y:CGFloat(0),width:frame.size.width,height:frame.size.height)
            scrollerView.addSubview(imageView)
        }
        scrollerView.contentOffset = CGPoint.zero
        self.view .addSubview(scrollerView)
        
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let twidth = CGFloat(numPages-1) * self.view.bounds.size.width
        
        if scrollView.contentOffset.x > twidth {
            
             let  tabbarViewController = MainTabBarViewController()
//            let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
//            
//            let nav = UINavigationController.init(rootViewController: tabbarViewController)
//            appdelegate.window?.rootViewController = nav
            
            
//                = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
//            self.navigationController?.pushViewController(n, animated: <#T##Bool#>)
           
            self.present(tabbarViewController, animated: true, completion: { 
                
            })
            
        }
        
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
