//
//  LogTableViewCell.swift
//  PachinkoLog
//

import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(start: String, bonus: String){
        startLabel.text = start
        bonusLabel.text = bonus
    }
    
}
