//
//  AnalysisTotalCellTableViewCell.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/01.
//

import UIKit
import RealmSwift

class AnalysisTotalCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hallLabel: UILabel!
    @IBOutlet weak var machineNameLabel: UILabel!
    @IBOutlet weak var bopLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startRateLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var luckLabel: UILabel!
    @IBOutlet weak var defferenceLabel: UILabel!
    @IBOutlet weak var rateBallLabel: UILabel!
    var machineTable: Results<MachineTable>!
    var hallTable: Results<HallTable>!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ResultTable){
        let realm = try! Realm()
        let calc = LogCalc()
        machineTable = realm.objects(MachineTable.self).filter("id == %@", data.machineID)
        self.machineNameLabel.text = machineTable[0].name
        hallTable = realm.objects(HallTable.self).filter("id == %@", data.hallID)
        self.hallLabel.text = hallTable[0].name
        self.bopLabel.text = "\(calc.intFormat(num: data.playResult))円"
        if data.playResult > 0{
            self.bopLabel.textColor = .blue
        }else if data.playResult < 0{
            self.bopLabel.textColor = .red
        }else{
            self.bopLabel.textColor = .darkGray
        }
        
        self.dateLabel.text = replaceDate(date: data.date)
        self.investmentLabel.text = "\(calc.intFormat(num: data.investment))円"
        self.startLabel.text = "\(calc.intFormat(num: data.start))回転"
        self.startRateLabel.text = "\(round(Double(data.start) / (Double(data.inPOS) / 250.0) * 100) / 100)回転"
        self.workLabel.text = "\(calc.intFormat(num: data.workResult))円"
        if data.workResult > 0{
            self.workLabel.textColor = .blue
        }else if data.playResult < 0{
            self.workLabel.textColor = .red
        }else{
            self.workLabel.textColor = .darkGray
        }
        self.luckLabel.text = "\(calc.intFormat(num: data.playResult - data.workResult))円"
        if data.playResult - data.workResult > 0{
            self.luckLabel.textColor = .blue
        }else if data.playResult - data.workResult < 0{
            self.luckLabel.textColor = .red
        }else{
            self.luckLabel.textColor = .darkGray
        }
        
        self.defferenceLabel.text = "\(calc.intFormat(num: data.defference))玉"
        if data.defference > 0{
            self.defferenceLabel.textColor = .blue
        }else if data.defference < 0{
            self.defferenceLabel.textColor = .red
        }else{
            self.defferenceLabel.textColor = .darkGray
        }
        let rate = Double((data.investment * data.rental / 1000) / data.inPOS)
        self.rateBallLabel.text = "\(round(rate * 10000) / 100)%"
    }
    
    func replaceDate(date: String) -> String{
        let arr:[String] = date.components(separatedBy: "/")
        return "\(arr[0])年\(arr[1])月\(arr[2])日"
    }
    
}
