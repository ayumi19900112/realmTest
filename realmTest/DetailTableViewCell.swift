//
//  DetailTableViewCell.swift
//  PachinkoLog
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    func setLabel(left: String, right: String) {
        leftLabel.text = left
        rightLabel.text = right
    }
    
    func judgeColor(number: String){
        let str = (number.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        let num = Int(str.joined())!
        if num != 0{
            if number.contains("-"){
                rightLabel.textColor = .red
            }else{
                rightLabel.textColor = .blue
            }
        }
        
        print("\(leftLabel.text!)  =  \(num)")
    }
    
    
}
