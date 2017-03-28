//
//  GameModel.swift
//  Swift2048
//
//  Created by 志强刁 on 2017/3/16.
//  Copyright © 2017年 dzqiang. All rights reserved.
//

import UIKit

class GameModel {

    
    var scoreDelegate:ScoreViewProtocol
    
    var bestScoreDelegate:ScoreViewProtocol
    
    var score:Int = 0
    
    var bestScore:Int = 0
    
    
    //游戏过关最大值
    var maxNumber:Int = 0
    //游戏方格维度
    var  dimension:Int = 0
    
    var tiles:Array<Int>//数组保存4*4
    
    var mtiles:Array<Int>! //重排数组
    
    
    init(dimension:Int,maxnumber:Int,score:ScoreViewProtocol,bestScore:ScoreViewProtocol) {
        self.dimension = dimension
        self.maxNumber = maxnumber
        self.bestScoreDelegate = bestScore
        self.scoreDelegate     = score
        
        self.tiles = Array<Int>(repeating:0,count:self.dimension * self.dimension)
        self.mtiles = Array<Int>(repeating:0,count:self.dimension * self.dimension)
    }
    
    func initTiles() {
        self.tiles = Array<Int>(repeating:0,count:self.dimension * self.dimension)
        self.mtiles = Array<Int>(repeating:0,count:self.dimension * self.dimension)
    }
    
//判断某个位置是否有值
    func setPosition(row:Int,col:Int,value:Int) -> Bool {
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        let index = self.dimension * row + col //索引
        let val = tiles[index]
        
        if val > 0 {
            print("该位置已经有值了")
            return false
        }
        
        tiles[index] = value
        
        return true
    }
    
    //交换tiles 和 mtiles 的数据
    func copyToMtiles(){
        for i  in 0..<self.dimension * self.dimension {
            mtiles[i] = tiles[i]
        }
    }
    //将mtiles 的值搬到tiles
    func copyFromMtiles() {
        for i in 0..<self.dimension * self.dimension {
            tiles[i] = mtiles[i]
        }
    }
    //数据向上重排
    
    func reflowUp() -> Void {
        copyToMtiles()
        var index:Int
        //i>0表示第一行不用动，用于控制行数
        for temp in 1...(dimension - 1){
            let i = dimension - temp
            //要执行4次，用于控制列数
            for j in 0..<dimension {
                index = self.dimension * i + j
                //如果当前位置有值，上一行没有值
                if (mtiles[index - self.dimension]==0) && (mtiles[index]>0) {
                    //直接把当前行的值赋值给上一行
                    mtiles[index - self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    //因为当前行发生了移动，得让其后面的行跟上
                    //否则滑动重排后，会出现空隙
                    
                    var subindex:Int = index
                    
                    while (subindex + self.dimension < mtiles.count) {
                        if mtiles[subindex + self.dimension]>0 {
                            mtiles[subindex] = mtiles[subindex + self.dimension]
                            mtiles[subindex + self.dimension] = 0
                        }
                        subindex += self.dimension
                    }
                }
            }
        }
        
        copyFromMtiles()
    }
    
    
    //数据向下重排
    
    func reflowDown() -> Void {
        copyToMtiles()
        var index:Int
        //从第0行开始往下找
        //只找到dimension -1 行，因为最下面一行不用再动了
        for i in 0..<dimension-1 {
            for j in 0..<dimension {
                index = self.dimension * i + j
                //如果当前位置有值，下行对应的位置没有值
                if (mtiles[index + self.dimension] == 0) && (mtiles[index] > 0) {
                    //将当前行的值赋给下一行
                    mtiles[index + self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    var subIndex:Int = index
                    //当下面的行发生了移动，上面的行跟上
                    //否则滑动重排之后会出现空隙
                    while (subIndex - self.dimension >= 0) {
                        if mtiles[subIndex - self.dimension] > 0 {
                            mtiles[subIndex] = mtiles[subIndex - self.dimension]
                            mtiles[subIndex - self.dimension] = 0
                        }
                        
                        subIndex -= self.dimension
                        
                    }
                    
                }
            }
        }
        
        copyFromMtiles()
        
    }
    
    //向左重排
    
    func reflowLeft() -> Void {
        copyToMtiles()
        var index:Int
        //从最右侧开始往左找
        //只找到第一列，因为第0列不用再动了
        for i in 0..<dimension {
            for temp in 1...(dimension - 1) {
                let j = dimension - temp
                index = self.dimension * i + j
                //如果当前位置有值，其左侧没有值，向左移动
                if (mtiles[index - 1] == 0) && (mtiles[index] > 0) {
                    mtiles[index - 1] = mtiles[index]
                    mtiles[index] = 0
                    
                    var subindex:Int = index
                    //对右边的内容进行检查，如果有空隙补上
                    while (subindex + 1 < i * dimension + dimension) {
                        if mtiles[index + 1] > 0 {
                            mtiles[subindex] = mtiles[subindex + 1]
                            mtiles[subindex + 1] = 0
                            print("0000")
                        }
                        
                        subindex += 1
                    }
                }
                
            }
        }
        
        copyFromMtiles()
        
    }
    
    func reflowRight() -> Void {
        copyToMtiles()
        var index:Int
        //从第0行列开始往右找
        //只找到第dimension - 1 列，因为最右侧不用再动了
        for i in 0..<dimension {
            for j in 0..<dimension - 1 {
                index = self.dimension * i + j
                //如果当前位置有值，其右侧没有值，向右移动
                if (mtiles[index + 1] == 0) && (mtiles[index] > 0) {
                    mtiles[index + 1] = mtiles[index]
                    mtiles[index] = 0
                    var subindex:Int = index
                    //对左边的内容进行检查，如果有空隙就补上
                    print(i)
                    while (subindex - 1 > i * dimension - 1) {
                        
                        if mtiles[subindex - 1] > 0 {
                            mtiles[subindex] = mtiles[subindex - 1]
                            mtiles[subindex - 1] = 0
                            print("11111")
                        }
                        
                        subindex -= 1
                    }
                }
            }
        }
        copyFromMtiles()
    }
      
    /**
     *滑动和合并可以优化为一个func
     */
    //向上合并
    func mergeUp() -> Void {
        copyToMtiles()
        var index:Int
        //从下向上合并
        for temp in 1...(dimension - 1) {
            let i = dimension - temp
            for j in 0..<dimension {
                index = self.dimension * i + j
                //如果当前航有值而且当前行和上一行的值相等
                if (mtiles[index] > 0) && (mtiles[index - self.dimension] == mtiles[index]) {
                    //将上一行的值变为当前值的2倍，当前行为0
                    mtiles[index - self.dimension] = mtiles[index] * 2
                    changeScore(s: mtiles[index] * 2)
                    mtiles[index] = 0
                }
            }
            
        }
        copyFromMtiles()
    }
    
    //向下合并
    func mergeDown() -> Void {
        copyToMtiles()
        var index:Int
        //从上向下合并
        for i in 0..<dimension - 1 {
            for j in 0..<dimension {
                index = self.dimension * i + j
                //如果当行有值而且当前行和下一行的值相等
                if (mtiles[index]>0) && (mtiles[index + self.dimension] == mtiles[index]) {
                    //将叠加合并和的结果放到下一行，上一行的数字清空
                    mtiles[index + self.dimension] = mtiles[index] * 2
                    changeScore(s: mtiles[index] * 2)
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
        
    }
    
    //向左合并
    func mergeLeft() -> Void {
        copyToMtiles()
        var index:Int
        //从右向左
        for i in 0..<dimension {
            for  temp in 1...(dimension-1) {
                let j = dimension - temp
                index = self.dimension * i + j
                //如果右边和左边的数字相邻相等则合并
                if (mtiles[index]>0) && (mtiles[index - 1] == mtiles[index]) {
                    //将叠加合并和的结果放到下一行，右边一列清空
                    mtiles[index - 1] = mtiles[index] * 2
                    changeScore(s: mtiles[index] * 2)
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
        
    }
    //向右合并
    func mergeRight() -> Void {
        copyToMtiles()
        var index:Int
        //从左向右
        for i in 0..<dimension {
            for j in 0..<dimension - 1 {
                index = self.dimension * i + j
                //如果右边和左边的数字相邻相等则合并
                if (mtiles[index]>0) && (mtiles[index + 1] == mtiles[index]) {
                    //将叠加合并和的结果放到下一行，上一行的数字清空
                    mtiles[index + 1] = mtiles[index] * 2
                    changeScore(s: mtiles[index] * 2)
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
        
    }
    
    
    //检测剩余的空位置
    func emptyPosition() -> [Int] {
        
        var emptytiles = Array<Int>()
        for i in 0..<(dimension * dimension)
        {
            if tiles[i] == 0 {
                emptytiles.append(i)
            }
        }
        
        return emptytiles
    }
    
    
//    检测是否满了
    func isFull() -> Bool {
        
        if emptyPosition().count == 0 {
            return true
        }
        
        return false
    }
    
    func isSuccess() -> Bool {
        for i in 0..<dimension * dimension {
            if tiles[i] >= maxNumber {
                return true
            }
        }
        
        return false
    }
    
    
    //检测相邻值是否相等的方法
    func checkVertical() -> Bool {
        
        var index = 0
        
        //从下向上检查
        for temp in 1...(dimension - 1) {
            let i = dimension - temp
            
            for j in 0..<dimension {
                index = self.dimension * i + j
                //如果当前行和上一行值相等，返回FALSE
                while mtiles[index - self.dimension] == mtiles[index] {
                    return false
                }
                
            }
            
        }
        
        return true
    }
    
    
    //水平方向检查
    
    func checkHourizontal() -> Bool {
        
        var index = 0
        //从右向左检查
        for i in 0..<dimension {
            for temp in 1...(dimension - 1) {
                let j = dimension - temp
                index = self.dimension * i + j
                //如果当前列和左侧一列值相等返回FALSE
                while mtiles[index - 1] == mtiles[index] {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isFailure() -> Bool {
        if isFull() == true {
            if checkVertical() == true && checkHourizontal() == true {
                return true
            }
        }
        
        return false
    }
    
    
    //
    func changeScore(s:Int) {
        score += s
        
        if bestScore < score{
            bestScore = score
        }
        
        scoreDelegate.changeScore(value: score)
        bestScoreDelegate.changeScore(value: bestScore)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
