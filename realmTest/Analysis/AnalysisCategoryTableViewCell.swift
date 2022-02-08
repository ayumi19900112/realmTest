//
//  AnalysisCategoryTableViewCell.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/01.
//

import UIKit
import RealmSwift

class AnalysisCategoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var totalBOPLabel: UILabel!
    @IBOutlet weak var totalWorkLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var winCountLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var totalStartLabel: UILabel!
    @IBOutlet weak var avgStartLabel: UILabel!
    @IBOutlet weak var rateHavePlayLabel: UILabel!
    @IBOutlet weak var avgBOPLabel: UILabel!
    @IBOutlet weak var avgWorkLabel: UILabel!
    @IBOutlet weak var luckLabel: UILabel!
    @IBOutlet weak var ratePayLabel: UILabel!
    @IBOutlet weak var defferenceLabel: UILabel!
    
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(categoryName: String, data: DataResult, categoryNumber: Int){
        let calc = LogCalc()
        let realm = try! Realm()
        var result: Results<ResultTable>!
        if categoryNumber == 1{
            result = realm.objects(ResultTable.self).filter("hallID == %@", data.hallID).sorted(byKeyPath: "date")
        }else if categoryNumber == 2{
            result = realm.objects(ResultTable.self).filter("machineID == %@", data.machineID).sorted(byKeyPath: "date")
        }
        
        var dateCount = 1
        var winCount = 0
        var loseCount = 0
        var max = 0
        var min = 0
        var i = 1
        var rental = 0
        while i < result.count{
            if result[i-1].date != result[i].date{
                dateCount += 1
            }
            i += 1
        }
        for i in 0 ..< result.count{
            if result[i].playResult > 0{
                winCount += 1
            }else if result[i].playResult < 0{
                loseCount += 1
            }
            
            if result[i].playResult > max{
                max = result[i].playResult
            }
            if result[i].playResult < min{
                min = result[i].playResult
            }
            
        }
        let evenCount = result.count - winCount - loseCount
        
        
        
        
        
        self.categoryNameLabel.text = categoryName
        self.totalWorkLabel.text = "\(calc.intFormat(num: data.work))円"
        self.totalBOPLabel.text = "\(calc.intFormat(num: data.bop))円"
        self.playCountLabel.text = "\(result.count)台"
        self.dayCountLabel.text = "\(dateCount)日"
        self.winCountLabel.text = "\(winCount)勝:\(loseCount)負:\(evenCount)分"
        self.winRateLabel.text = "\(round(Double(winCount) / Double(result.count) * 10000) / 100)%"
        self.totalStartLabel.text = "\(calc.intFormat(num: data.start))回転"
        self.avgStartLabel.text = "\(calc.intFormat(num: data.start / dateCount))回転"
        let rate =  round((1.0 - (Double(data.investment) / 1000.0 * Double(data.rental)) / Double(data.inPOS)) * 10000) / 100
        //let rate = round(Double(data.inPOS) / Double(data.inPOS + data.rental) * 10000) / 100
        self.rateHavePlayLabel.text = "\(rate)%"
        self.avgBOPLabel.text = "\(calc.intFormat(num: data.bop / dateCount))円"
        self.avgWorkLabel.text = "\(calc.intFormat(num: data.work / dateCount))円"
        self.luckLabel.text = "\(calc.intFormat(num: data.bop - data.work))円"
        self.ratePayLabel.text = "\(round(Double(data.defference + data.inPOS) / Double(data.inPOS) * 10000) / 100)%"
        self.defferenceLabel.text = "\(calc.intFormat(num: data.defference))玉"
        self.maximumLabel.text = "\(calc.intFormat(num: max))円"
        self.minimumLabel.text = "\(calc.intFormat(num: min))円"
        
        if data.bop > 0{
            totalBOPLabel.textColor = .blue
            avgBOPLabel.textColor = .blue
        }else if data.bop < 0{
            totalBOPLabel.textColor = .red
            avgBOPLabel.textColor = .red
        }else{
            totalBOPLabel.textColor = .darkGray
            avgBOPLabel.textColor = .darkGray
        }
        if data.work > 0{
            totalWorkLabel.textColor = .blue
            avgWorkLabel.textColor = .blue
        }else if data.bop < 0{
            totalWorkLabel.textColor = .red
            avgWorkLabel.textColor = .red
        }else{
            totalWorkLabel.textColor = .darkGray
            avgWorkLabel.textColor = .darkGray
        }
        if data.bop - data.work > 0{
            luckLabel.textColor = .blue
        }else if data.bop - data.work < 0{
            luckLabel.textColor = .red
        }else{
            luckLabel.textColor = .darkGray
        }
        if data.defference > 0{
            defferenceLabel.textColor = .blue
        }else if data.defference < 0{
            defferenceLabel.textColor = .red
        }else{
            defferenceLabel.textColor = .darkGray
        }
    }
    
    
}
