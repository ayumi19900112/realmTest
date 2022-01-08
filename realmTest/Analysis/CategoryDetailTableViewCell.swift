//
//  CategoryDetailTableViewCell.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/02.
//

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hallNameLabel: UILabel!
    @IBOutlet weak var machineNameLabel: UILabel!
    @IBOutlet weak var bopLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var rateStartLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var luckLabel: UILabel!
    @IBOutlet weak var defferenceLabel: UILabel!
    @IBOutlet weak var rateBallLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var leftRateStartLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(data: DataResult, categoryNumber: Int){
        let calc = LogCalc()
        
        self.dateLabel.text = replaceDate(date: data.date)
        self.hallNameLabel.text = data.hall
        self.machineNameLabel.text = data.machineName
        self.numberLabel.text = "\(data.number)番台"
        self.bopLabel.text = "\(calc.intFormat(num: data.bop))円"
        self.investmentLabel.text = "\(calc.intFormat(num: data.investment))円"
        self.startLabel.text = "\(calc.intFormat(num: data.start))回転"
        let rateStart = round(Double(data.start) / Double(data.inPOS) * 250.0 * 100) / 100
        self.rateStartLabel.text = "\(rateStart)回転"
        self.workLabel.text = "\(calc.intFormat(num: data.work))円"
        self.luckLabel.text = "\(calc.intFormat(num: data.bop - data.work))円"
        self.defferenceLabel.text = "\(calc.intFormat(num: data.defference))玉"
        let rate = Double((data.inPOS - data.investment * data.rental / 1000) / data.inPOS)
        self.rateBallLabel.text = "\(round(rate * 10000.0) / 100)%"
        if data.bop > 0{
            self.bopLabel.textColor = .blue
        }else if data.bop < 0{
            self.bopLabel.textColor = .red
        }else{
            self.bopLabel.textColor = .darkGray
        }
        if data.work > 0{
            self.workLabel.textColor = .blue
        }else if data.work < 0{
            self.workLabel.textColor = .red
        }else{
            self.workLabel.textColor = .darkGray
        }
        if data.defference > 0{
            self.defferenceLabel.textColor = .blue
        }else if data.defference < 0{
            self.defferenceLabel.textColor = .red
        }else{
            self.defferenceLabel.textColor = .darkGray
        }
        if data.bop - data.work > 0{
            self.luckLabel.textColor = .blue
        }else if data.bop - data.work < 0{
            self.luckLabel.textColor = .red
        }else{
            self.luckLabel.textColor = .darkGray
        }
    }
    
    func replaceDate(date: Date) -> String{
        /// DateFomatterクラスのインスタンス生成
        let dateFormatter = DateFormatter()
         
        /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
         
        /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: date)
         
        /*
        /// データ変換（Date→テキスト）
        let dateString = dateFormatter.string(from: Date())
        print(dateString)   // "2020年4月25日(土) 16時8分56秒"
         */
    }
    
}
