//
//  MainViewController.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/15.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

enum AnimationSlipType {
    case none  //无动画
    case new   //新出现动画
    case merge //合并动画
}


class MainViewController: UIViewController {

    var imageView:UIImageView
    var reTryButton:UIButton
    //分数标签
    var score:ScoreView
    //最高分标签
    var bestScore:BestScoreView
    
    
    //维度
    var dimension = 4
    {
        didSet{
            gameModel.dimension = dimension
        }
    }
    //格子的宽度
    var width:CGFloat = 58
    //格子之间的空隙
    var padding:CGFloat = 7
    //保存背景图数据
    var backgrounds:Array<UIView>
    //白色方块底图
    var whiteView:UIView
    //保存界面的标签
    var tiles:Dictionary<NSIndexPath,TileView>
    //保存界面的数字
    var tileVals:Dictionary<NSIndexPath,Int>
    //model
    var gameModel:GameModel!
    //游戏过关最大值
    var maxNumber:Int = 2048
    {
        didSet{
            gameModel.maxNumber = maxNumber
        }
    }
    
    init() {
        
        self.score = ScoreView()
        self.bestScore = BestScoreView()
        self.imageView   = UIImageView()
        self.reTryButton = UIButton()
        self.backgrounds = Array<UIView>()
        self.whiteView   = UIView()
        self.tiles       = Dictionary()
        self.tileVals    = Dictionary()
        
        super.init(nibName:nil,bundle:nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage:UIImage(named:"background")!)
        
        setupTitleView()
        setupReTryBtn()
        setupBackground()
        
        setupSwipeGuestures()
        setupScoreLables()
        self.gameModel   = GameModel(dimension:self.dimension,maxnumber:maxNumber,score:score,bestScore:bestScore)
        gameModel.changeScore(s: 0)
        initNum(number: 4)
        // Do any additional setup after loading the view.
    }
    
    //
    
    func setupScoreLables() -> Void {
        //添加分数标签
        score.frame.origin.x = 60
        score.frame.origin.y = 160
        self.view.addSubview(score)
        
        //添加最高分标签
        bestScore.frame.origin.x = 225
        bestScore.frame.origin.y = 160
        self.view.addSubview(bestScore)
    }
    
    //方格维度
    func initNum(number:Int) -> Void {
        for _ in 0..<number {
            genRandom()
        }
    }
    
    
    //创建半透明方块底图
    func setupWhiteView(){
        
        let rect = UIScreen.main.bounds
        let w:CGFloat = rect.width
        //白块的坐标和尺寸
        let backWidth = width * CGFloat(dimension) + padding * CGFloat(dimension - 1) + 20
        let backX = (w - backWidth) / 2
        //添加白色方块
        self.whiteView.frame = CGRect(x: backX, y: 208, width: backWidth, height: backWidth)
        
        self.whiteView.backgroundColor = UIColor.white
        self.whiteView.alpha = 0.6
        
        self.view .addSubview(self.whiteView)
        
    }
    //创建背景
    func setupBackground() -> Void {
        setupWhiteView()
        //根据屏幕尺寸计算插入的位置
        var x:CGFloat = 10
        var y:CGFloat = 10
        //竖行逐一排列
        for _ in 0..<dimension{
            y = 10
            for _ in 0..<dimension{
                let backgroundView = UIView(frame: CGRect(x: x, y: y, width: width, height: width))
                backgroundView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
                backgroundView.layer.cornerRadius = 4
                self.whiteView.addSubview(backgroundView)
                backgrounds.append(backgroundView)
                y += padding + width
            }
            
            x += padding + width
            
        }
        
    }
    
    //2048标题
    func setupTitleView()  {
        
        imageView.image = UIImage(named:"title")
        imageView.frame = CGRect(x:22,y:96,width:69,height:69)
//        imageView.backgroundColor=UIColor.black
        self.view .addSubview(self.imageView)
    }
    
    //随机生成数字
    func genRandom() -> Void {
        //生成一个随机数
        let radomNum = Int(arc4random_uniform(10))
        //以9：1的比例显示数字2和4
        
        var seed:Int = 2
        
        if radomNum == 1 {
            seed = 4
        }
        //根据维度来确定数字显示的位置
        let col = Int(arc4random_uniform(UInt32(dimension)))
        
        let row = Int(arc4random_uniform(UInt32(dimension)))
        
        if gameModel.isFull() {
            print("满了")
            return
        }
        //检测某个位置是否有值
        if gameModel.setPosition(row: row, col: col, value: seed) == false {
            
            genRandom()
            
            return
            
        }
        
        insetTitle((row,col),value:seed,aType:AnimationSlipType.new)
        
        
    }
    //插入数字块
    func insetTitle(_ pos:(Int,Int),value:Int,aType:AnimationSlipType) -> Void {
        let (row,col) = pos
        
        let x = 10 + CGFloat(col) * (width + padding)//X值 = 列号 *（方块的宽度 + 间隙）
        let y = 10 + CGFloat(row) * (width + padding)//Y值 = 行号 *（方块的宽度 + 间隙）
        
        //插入数字块
        let tile = TileView(pos:CGPoint(x:x,y:y),width:width,value:value)
        tile.layer.cornerRadius = 4
        self.whiteView.addSubview(tile)
        self.view.bringSubview(toFront: tile)
        //将tile保存到字典
        let index = NSIndexPath(row:row,section:col)//key
        tiles[index] = tile     //value
        tileVals[index] = value
        
        
        if aType == AnimationSlipType.none{
            return
        }else if aType == AnimationSlipType.new{
            //将数字块大小置为原始尺寸的1/10
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1,y: 0.1))
        }else if aType == AnimationSlipType.merge{
            tile.layer.setAffineTransform(CGAffineTransform(scaleX:1,y:1))
        }
        
        //将数字块大小置为原始尺寸的1/10
//        tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1,y: 0.1))
        
        //设置动画效果，动画长度为0.3
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations: { 
            
            () -> Void in
            tile.layer.setAffineTransform(CGAffineTransform(scaleX:1,y:1))
            
        }) {
            (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.8, animations: { 
                () -> Void in
                //动画完成时，数字块复原
                tile.layer.setAffineTransform(CGAffineTransform.identity)
                
            })
        }
        
    }
    //创建滑动手势
    func setupSwipeGuestures(){
        //向上
        let upSwipe = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipeUP))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipeDown))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(downSwipe)
        
        
        let letfSwipe = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipeLeft))
        letfSwipe.numberOfTouchesRequired = 1
        letfSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(letfSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipeRight))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    //手势function
    func swipeUP() {
       print("向上")
        gameSuccess()
        
        if !gameModel.isSuccess() && !gameModel.isFailure() {
            printTiles(tiles: gameModel.tiles)
            gameModel.reflowUp()
            gameModel.mergeUp()
            gameModel.reflowUp()
            printTiles(tiles: gameModel.mtiles)
            
            resetUI()
            initUI()
            
            initNum(number: 2)
            
            
        }else{
            gameSuccess()
            gameFailure()
        }
        
        
    }
    
    func swipeDown() {
        gameSuccess()
        print("向下")
        if !gameModel.isSuccess() && !gameModel.isFailure() {
            printTiles(tiles: gameModel.tiles)
            gameModel.reflowDown()
            gameModel.mergeDown()
            gameModel.reflowDown()
            printTiles(tiles: gameModel.mtiles)
            
            resetUI()
            initUI()
            
            initNum(number: 2)
        }else{
            gameSuccess()
            gameFailure()
        }
    }
    
    func swipeLeft() {
        
        gameSuccess()
        print("向左")
        if !gameModel.isSuccess() && !gameModel.isFailure() {
            printTiles(tiles: gameModel.tiles)
            gameModel.reflowLeft()
            gameModel.mergeLeft()
            gameModel.reflowLeft()
            printTiles(tiles: gameModel.mtiles)
            
            resetUI()
            initUI()
            
            initNum(number: 2)
        }else{
            gameSuccess()
            gameFailure()
        }
    }
    
    func swipeRight() {
        
        
        
        print("向右")
        if !gameModel.isSuccess() && !gameModel.isFailure() {
            printTiles(tiles: gameModel.tiles)
            gameModel.reflowRight()
            gameModel.mergeRight()
            gameModel.reflowRight()
            printTiles(tiles: gameModel.mtiles)
            resetUI()
            initUI()
            
            initNum(number: 2)
        }else{
            gameSuccess()
            gameFailure()
        }
        
    }
    
    
    //界面展示重排效果
    func resetUI(){
        
        for (_,tile) in tiles {
            tile.removeFromSuperview()
        }
        tiles.removeAll(keepingCapacity: true)
        tileVals.removeAll(keepingCapacity: true)
        
        
        for background in backgrounds {
            background.removeFromSuperview()
        }
        
        setupBackground()
        
        
    }
    
    func initUI() -> Void {
        
        
        var index:Int     //在模型中数组中的序号
        var key:NSIndexPath //在视图数组中的路径
        var tile:TileView //格子的数字视图
        var tileVal:Int   //格子的数字
        

        for i in 0..<dimension {
            for j in 0..<dimension {
                let index = i * self.dimension + j
                key = NSIndexPath(row:i,section:j)
                //原来界面没有值，模型数据中有值
                if gameModel.tiles[index] > 0 && tileVals.index(forKey: key ) == nil {
                    insetTitle((i,j), value: gameModel.tiles[index], aType: AnimationSlipType.merge)
                }
                
                //原来界面中有值，现在模型数据中没有值
                if (gameModel.tiles[index] == 0) && (tileVals.index(forKey: key) != nil) {
                    
                    tile = tiles[key]!
                    tile.removeFromSuperview()
                    tiles.removeValue(forKey: key)
                    tileVals.removeValue(forKey: key)
                }
                
                //原来有值，现在仍然有值
                if (gameModel.tiles[index] > 0) && (tileVals.index(forKey: key) != nil) {
                    tileVal = tileVals[key]!
                    //如果不相等，直接换掉值就可以
                    if tileVal != gameModel.tiles[index] {
                        tile = tiles[key]!
                        tile.removeFromSuperview()
                        tiles.removeValue(forKey: key)
                        tiles.removeValue(forKey: key)
                        insetTitle((i,j), value: gameModel.tiles[index], aType: AnimationSlipType.merge)
                    }
                }
                
//                if gameModel.tiles[index] != 0 {
//                    insetTitle((i,j), value: gameModel.tiles[index],aType: AnimationSlipType.merge)
//                }
                
            }
        }
    }
    
    
    
    //重置按钮
    func setupReTryBtn(){
        reTryButton = ControlView.creatButton(#selector(MainViewController.reRestart), sender: self)
        reTryButton.frame = CGRect(x: UIScreen.main.bounds.width-22-69, y: 96, width: 69, height: 69)
        self.view .addSubview(reTryButton)
        
    }
//    重置按钮action
    func reRestart(sender:UIButton){
        self .reStart()
    }
    
    func reStart() -> Void {
        resetUI()//重置界面
        score.changeScore(value: 0)
        gameModel.score = 0
        gameModel.initTiles()//同步数据
        
        initNum(number: 4)
    }
    
    
    func printTiles(tiles:Array<Int>) -> Void {
        let count = tiles.count
        
        for i in 0..<count {
            
            if (i + 1)%Int(dimension) == 0 {
                print(tiles[i])
            }
            else{
                
                print(tiles[i], separator: "", terminator: "\t")
            }
            
        }
        print("")
        
    }
    
    func gameSuccess() {
        if gameModel.isSuccess() {
            //弹出提示框
            let alertVc  = UIAlertController(title: "恭喜过关！", message: "嘿，真棒！！您过关了！！！", preferredStyle: .alert)
            // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
            
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: {
            (UIAlertAction) -> Void in
                
                
            })
            let okAction = UIAlertAction(title: "再玩一次", style: .default, handler:{
                (UIAlertAction) -> Void in
                print("点击确定事件")
                self.reStart()
            })
            alertVc.addAction(cancelAction)
            alertVc.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
            self.present(alertVc, animated: true, completion: nil)
            
            return
            
        }
    }
    
    func gameFailure() {
        if gameModel.isFailure() {
            //弹出提示框
            let alertVc  = UIAlertController(title: "游戏结束！", message: "抱歉！！您失败了！！！", preferredStyle: .alert)
            // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
            
            let okAction = UIAlertAction(title: "再试一次", style: .default, handler:{
                (UIAlertAction) -> Void in
                print("点击确定事件")
                self.reStart()
            })
            alertVc.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
            self.present(alertVc, animated: true, completion: nil)
            
            return
            
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
