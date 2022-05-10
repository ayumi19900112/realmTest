//
//  ExpectedBalanceCellTableViewCell.swift
//  
//
//  Created by 東純己 on 2022/05/05.
//

import UIKit

class ExpectedBalanceCellTableViewCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLeftLabel(value: Int){
        let calc = LogCalc()
        self.leftLabel.text = "\(calc.intFormat(num: value))スタート"
    }
    
    func setRightLabel(value: Int){
        let calc = LogCalc()
        self.rightLabel.text = "\(calc.intFormat(num: value))円"
        if value > 0{
            self.rightLabel.textColor = .blue
        }else if value < 0{
            self.rightLabel.textColor = .red
        }
    }
    
}
