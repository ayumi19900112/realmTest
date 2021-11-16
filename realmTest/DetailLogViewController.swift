//
//  DetailLogViewController.swift
//  PachinkoLog
//


import UIKit
import RealmSwift

class DetailLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let sectionTitle = ["プレイ条件", "投資", "スタート", "大当たり回数", "大当たり出玉"]
    let playList = ["稼働日", "稼働ホール", "交換率", "稼働機種", "台番号"]
    let investmentList = ["現金投資", "収支", "仕事量", "ツキ金額", "差玉", "持ち玉比率"]
    var startList = ["総回転数", "通常回転数", "回転率", "電サポ回転数", "電サポ比率"]
    var bonusCountList: [String]!
    var bonusAmountList: [String]!
    
    var resultPlayList = ["", "", "", "", ""]
    var resultInvestmentList = ["", "", "", "", "", ""]
    var resultStartList = ["", "", "", "", ""]
    var resultBonusNameList: [String]!
    var resultBonusCountList: [String]!
    var resultBonusAmountList: [String]!
    
    var calc: LogCalc!
    let realm = try! Realm()
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register (UINib(nibName: "DetailTableViewCell", bundle: nil),forCellReuseIdentifier:"DetailCell")
        self.detailTableView.estimatedRowHeight = 110
        self.detailTableView.rowHeight = UITableView.automaticDimension
        
        setBonusNameList()
        setPlayList()
        setInvestmentList()
        setBonusCount()
        setBonusAmount()
        setStartList()
        
        
        print("resultBonusName = \(resultBonusNameList)")
        print("resultBonusAmount = \(resultBonusAmountList)")
        print("resultBonusCount = \(resultBonusCountList)")
        // Do any additional setup after loading the view.
    }
    
    func setPlayList() {
        resultPlayList[0] = calc.getDate()
        resultPlayList[1] = calc.getHallName()
        resultPlayList[2] = calc.getRate()
        resultPlayList[3] = calc.getMachineName()
        resultPlayList[4] = calc.getNumber()
    }
    
    func setInvestmentList() {
        resultInvestmentList[0] = calc.getInvestment()
        resultInvestmentList[1] = calc.getPlayResult()
        resultInvestmentList[2] = calc.getWorkResult()
        resultInvestmentList[3] = calc.getLuckMoney()
        resultInvestmentList[4] = calc.getDifference()
        resultInvestmentList[5] = calc.getRateBall()
    }
    
    func setStartList() {
        resultStartList[0] = calc.getTotalStart()
        resultStartList[1] = calc.getStart()
        resultStartList[2] = calc.getTurnOver()
        resultStartList[3] = calc.getSupportStart()
        resultStartList[4] = calc.getRateSupport()
        if resultBonusNameList.last == "小当R"{
            startList.append("小当たりRUSH")
            //resultStartList.append(resultBonusCountList.last!)
            resultStartList.append(calc.getSKR())
            //let machineBonusCount = result?.bonusCount.components(separatedBy: "/")
            //print("machineBonusCount = \(machineBonusCount)")
            //let rate = round(Double(machineBonusCount.last) / Double(result?.start) * 10000) / 100
            startList.append("小当たりRUSH比率")
            //let rate = "\(round(Double(resultBonusCountList) / Double(calc.getStart())! * 10000) / 100)%"
            resultStartList.append(calc.getRateSKR())
        }
        
    }
    func setBonusNameList(){
        let result = realm.objects(MachineTable.self).filter("id == %@", calc.getMachineID()).first
        resultBonusNameList = result?.bonusName.components(separatedBy: "/")
        resultBonusNameList.removeFirst()

    }
    
    func setBonusCount() {
        let result = realm.objects(MachineTable.self).filter("id == %@", calc.getMachineID()).first
        bonusCountList = (result?.bonusName.components(separatedBy: "/"))!
        bonusCountList.removeFirst()

        resultBonusCountList = calc.getBonusCount()
        resultBonusCountList.removeFirst()
        if resultBonusNameList.last == "小当R"{
            bonusCountList.removeLast()
        }
    }
    
    func setBonusAmount() {
        let result = realm.objects(MachineTable.self).filter("id == %@", calc.getMachineID()).first
        bonusAmountList = (result?.bonusName.components(separatedBy: "/"))!
        bonusAmountList[0] = "電サポ増減"
        resultBonusAmountList = calc.getBonusAmount()

    }
    

    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        //セクションの数
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //セクションのタイトルを設定する。
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //一つのセクションに入れるCellの数を指定する。
        if section == 0{
            return playList.count
        } else if section == 1 {
            return investmentList.count
        } else if section == 2 {
         return startList.count
        } else if section == 3 {
            return bonusCountList.count
        } else if section == 4{
            return bonusAmountList.count
        }else{
         return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cellの内容を設定する。
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        
        if indexPath.section == 0 {
            cell.setLabel(left: playList[indexPath.row], right: resultPlayList[indexPath.row])
        }else if indexPath.section == 1{
            cell.setLabel(left: investmentList[indexPath.row], right: resultInvestmentList[indexPath.row])
            if indexPath.row > 0 && indexPath.row < 5{
                cell.judgeColor(number: resultInvestmentList[indexPath.row])
            }
        }else if indexPath.section == 2{
            cell.setLabel(left: startList[indexPath.row], right: resultStartList[indexPath.row])
        }else if indexPath.section == 3{
            if bonusCountList[indexPath.row] != "小当R"{
                cell.setLabel(left: bonusCountList[indexPath.row], right: resultBonusCountList[indexPath.row])
            }
        }else if indexPath.section == 4{
            cell.setLabel(left: bonusAmountList[indexPath.row], right: resultBonusAmountList[indexPath.row])
            if indexPath.row == 0{
                cell.judgeColor(number: resultBonusAmountList[indexPath.row])
            }
        }
        return cell
    }
    
    

}

