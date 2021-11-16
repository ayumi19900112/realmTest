//
//  PlayLogCellTableViewCell.swift
//  PachinkoLog
//


import UIKit
import RealmSwift

class PlayLogCellTableViewCell: UITableViewCell {
    @IBOutlet weak var hallNameLabel: UILabel!
    @IBOutlet weak var machineNameLabel: UILabel!
    @IBOutlet weak var resultBOPLabel: UILabel!
    @IBOutlet weak var resultWorkLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //cell.contentView.addSubView(cellHeaderView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setHallName(name: String){
        self.hallNameLabel.text = name
    }
    
    func setMachineName(name: String){
        self.machineNameLabel.text = name
    }
    
    func setResultBOP(num: Int){
        
        if num < 0{
            resultBOPLabel.textColor = .red
        }else if num > 0{
            resultBOPLabel.textColor = .blue
        }
        let calc = Calc()
        let output = calc.intFormat(num: num)
        self.resultBOPLabel.text = "\(output)円"
    }
    
    func setResultWork(num: Int){
        
        if num < 0{
            resultWorkLabel.textColor = .red
        }else if num > 0{
            resultWorkLabel.textColor = .blue
        }
        let calc = Calc()
        let output = calc.intFormat(num: num)
        self.resultWorkLabel.text = "\(output)円"
    }
}
