//
//  AnalysisTableViewCell.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/11/25.
//

import UIKit
import RealmSwift

class AnalysisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bopLabel: UILabel!           //収支
    @IBOutlet weak var workLabel: UILabel!          //仕事量
    @IBOutlet weak var machineCountLabel: UILabel!  //稼働台数
    @IBOutlet weak var dateCountLabel: UILabel!     //稼働日数
    @IBOutlet weak var winCountLabel: UILabel!      //勝敗
    @IBOutlet weak var winRateLabel: UILabel!       //勝率
    @IBOutlet weak var totalStartLabel: UILabel!    //総スタート
    @IBOutlet weak var avgStartLabel: UILabel!      //平均スタート
    @IBOutlet weak var rateHavePlayLabel: UILabel!  //持ち玉比率
    @IBOutlet weak var avgBOPLabel: UILabel!        //平均収支
    @IBOutlet weak var avgWorkLabel: UILabel!       //平均仕事量
    @IBOutlet weak var luckLabel: UILabel!          //損益金額
    @IBOutlet weak var rateLabel: UILabel!          //回収率
    @IBOutlet weak var rangeBallLabel: UILabel!     //差玉
    @IBOutlet weak var maximumMoneyLabel: UILabel!  //最高勝ち金額
    @IBOutlet weak var minimumMoneyLabel: UILabel!  //最高負け金額
    var investment = 0  //投資金額
    var rental = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDate(result: Results<ResultTable>, idx: [Int]){
        var winCount = 0
        var loseCount = 0
        var evenCount = 0
        var maxMoney = 0
        var minMoney = 0
        var dateCount = 0
        var start = 0
        var bop = 0
        var work = 0
        var dif = 0
        investment = 0
        
        
        
        var inPOS = 0
        var rental = 0
        for i in 0 ..< idx.count{
            if result[idx[i]].playResult > 0{
                winCount += 1
            }else if result[idx[i]].playResult < 0{
                loseCount += 1
            }
            if result[idx[i]].playResult > maxMoney{
                maxMoney = result[idx[i]].playResult
            }
            if result[idx[i]].playResult < minMoney{
                minMoney = result[idx[i]].playResult
            }
            start += result[idx[i]].start
            bop += result[idx[i]].playResult
            work += result[idx[i]].workResult
            inPOS += result[idx[i]].inPOS
            rental += Int(Double(result[idx[i]].rental) * (Double(result[idx[i]].investment) / 1000.0))
            dif += result[idx[i]].defference
            
            
            
        }
        
        
        if idx.count > 0{
            dateCount += 1
            var day = result[idx[0]].date
            for i in 1 ..< idx.count{
                if day == result[idx[i]].date{
                }else{
                    dateCount += 1
                    day = result[idx[i]].date
                }
            }
        }
                
        
        
        //let date = result.value(forKeyPath: "@distinctUnionOfObjects.date")
        
        let calc = LogCalc()
        if bop > 0{
            bopLabel.textColor = .blue
            avgBOPLabel.textColor = .blue
        }else if bop < 0{
            bopLabel.textColor = .red
            avgBOPLabel.textColor = .red
        }else{
            bopLabel.textColor = .darkGray
            avgBOPLabel.textColor = .darkGray
        }
        bopLabel.text? = "\(calc.intFormat(num: bop))円"
        if work > 0{
            workLabel.textColor = .blue
            avgWorkLabel.textColor = .blue
        }else if work < 0{
            workLabel.textColor = .red
            avgWorkLabel.textColor = .red
        }else{
            workLabel.textColor = .darkGray
            avgWorkLabel.textColor = .darkGray
        }
        workLabel.text? = "\(calc.intFormat(num: work))円"
        machineCountLabel.text = "\(calc.intFormat(num: idx.count))台"
        dateCountLabel.text = "\(dateCount)日"
        winCountLabel.text = "\(winCount)勝:\(loseCount)負:\(idx.count - winCount - loseCount)分"
        winRateLabel.text = "\(round(Double(winCount) / Double(dateCount) * 10000) / 100)%"
        totalStartLabel.text = "\(calc.intFormat(num: start))回転"
        if dateCount == 0{
            avgStartLabel.text = "0回転"
        }else{
            avgStartLabel.text = "\(start / dateCount)回転"
        }
        let rate = round(Double(rental) / Double(inPOS) * 100) / 100
        rateHavePlayLabel.text = "\(rate)%"
        avgBOPLabel.text = "\(calc.intFormat(num: bop / dateCount))円"
        avgWorkLabel.text = "\(calc.intFormat(num: work / dateCount))円"
        luckLabel.text = "\(calc.intFormat(num: bop - work))円"
        if (bop - work) > 0{
            luckLabel.textColor = .blue
        }else if (bop - work) < 0{
            luckLabel.textColor = .red
        }else{
            luckLabel.textColor = .darkGray
        }
        
        rateLabel.text = "\(round(Double(dif + inPOS) / Double(inPOS) * 10000) / 100)%"
        rangeBallLabel.text = "\(calc.intFormat(num: dif))玉"
        if dif > 0{
            rangeBallLabel.textColor = .blue
        }else if dif < 0{
            rangeBallLabel.textColor = .red
        }else{
            rangeBallLabel.textColor = .darkGray
        }
        
        maximumMoneyLabel.text = "\(calc.intFormat(num: maxMoney))円"
        minimumMoneyLabel.text = "\(calc.intFormat(num: minMoney))円"
        
        
        
        
    }
    
}
