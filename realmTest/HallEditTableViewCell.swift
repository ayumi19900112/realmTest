//
//  HallEditTableViewCell.swift
//  PachinkoLog
//

import UIKit

class HallEditTableViewCell: UITableViewCell {
    @IBOutlet var hallNameLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    
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
        self.rateLabel.text? = "\(money)円/\(ball)玉"
        self.rateLabel.adjustsFontSizeToFitWidth = true
    }
    
}
