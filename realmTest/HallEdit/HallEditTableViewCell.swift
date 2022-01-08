//
//  HallEditTableViewCell.swift
//  PachinkoLog
//

import UIKit

class HallEditTableViewCell: UITableViewCell {
    @IBOutlet var hallNameLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var exchangeMoneyLabel: UILabel!
    
    let calc = LogCalc()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setHallLabel(name: String){
        self.hallNameLabel.text? = name
    }
    
    func setRateLabel(money: Double, ball: Double){
        self.rateLabel.text? = "\(removeZero(String(money))!)円/\(removeZero(String(ball))!)玉"
        self.rateLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setSave(save: Int, money: Double, ball: Double){
        saveLabel.text = "\(calc.intFormat(num: save))玉"
        var exchangeMoney = Int(Double(save) / ball)
        exchangeMoney = Int(Double(exchangeMoney) * money)
        exchangeMoneyLabel.text = "\(calc.intFormat(num: exchangeMoney))円"
    }
    
    
    func removeZero(_ str: String) -> String? {
        guard let d = Double(str) else {
            return nil
        }

        var t = String(d)

        if let range = t.range(of: ".0") {
            t.replaceSubrange(range, with: "")
        }

        return t
    }
}
