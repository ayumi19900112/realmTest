//
//  BonusAmountTableViewCell.swift
//  PachinkoLog

import UIKit
import RealmSwift

class BonusAmountTableViewCell: UITableViewCell {
    @IBOutlet weak var bonusNameLabel: UILabel!
    @IBOutlet weak var bonusAmountTextField: UITextField!
    var pivotAmount = 0.0
    var machineID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bonusAmountTextField.keyboardType = UIKeyboardType.decimalPad
        //キーボードに完了のツールバーを作成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let minusButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(toggleMinus))
        toolbar.items = [minusButton]
        bonusAmountTextField.inputAccessoryView = toolbar
        
        let doneToolbar = UIToolbar()
        doneToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTaped))
        doneToolbar.items = [minusButton, spacer, doneButton]
        bonusAmountTextField.inputAccessoryView = doneToolbar
        
        bonusAmountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(label: String){
        bonusNameLabel.text = label
    }
    func setTextField(number: String){
        if number != "" {
            bonusAmountTextField.text = number
        }else{
            bonusAmountTextField.text = "0"
        }
    }
    
    
    func setPoivotAmount(machineID: Int){
        let realm = try! Realm()
        let machineList = realm.objects(MachineTable.self).filter("id == %@", machineID).first
        print(machineList)
    }
    
    //MARK:- 完了ボタン
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        bonusAmountTextField.endEditing(true)
    }
    
    @objc func toggleMinus(){

        // Get text from text field
        if var text = bonusAmountTextField.text , text.isEmpty == false{

            // Toggle
            if text.hasPrefix("-") {
                text = text.replacingOccurrences(of: "-", with: "")
            }else{
                text = "-\(text)"
            }
            bonusAmountTextField.text = text
        }
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        let realm = try! Realm()
        let machineList = realm.objects(MachineTable.self).filter("id == %@", machineID).first
        var amountArray = machineList!.bonusAmount.components(separatedBy: "/").map{Double($0)!}
        var amountArrayStr = machineList!.bonusAmount.components(separatedBy: "/").map{($0)}
        if bonusAmountTextField.text != "" && Double(bonusAmountTextField.text!) != nil{
            amountArrayStr[self.tag] = bonusAmountTextField!.text!
        }else{
            amountArrayStr[self.tag] = "0.0"
        }
        do{
            try realm.write{
                machineList?.bonusAmount = amountArrayStr.joined(separator: "/")
            }
        }catch {
                print("Error")
        }

   }

}
