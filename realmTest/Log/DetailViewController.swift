//
//  DetailViewController.swift
//  PachinkoLog
//


import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var calc: Calc!
    var hallName: String!
    var machineName: String!
    let sectionTitle = ["プレイ条件", "投資", "スタート", "大当たり回数（理論値）"]
    
    let playList = ["稼働日", "稼働ホール", "交換率", "稼働機種", "台番号"]
    let investmentList = ["現金投資", "開始時持ち玉", "終了時持ち玉", "差玉", "収支", "仕事量", "損益金額", "持ち玉比率"]
    var startList = ["総回転数", "通常回転数", "回転率", "電サポ回転数", "電サポ比率"]
    var bonusNameList: [String]!
    var resultPlayList = ["", "", "", "", ""]
    var resultInvestmentList = ["", "", "", "", "", "", "", ""]
    var resultStartList = ["", "", "", "", ""]
    var BonusCountList: [Int]!
    var BonusAmountList: [Double]!
    var resultBonusCountList: [String]!
    var clv: CurrentLogViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.register (UINib(nibName: "DetailTableViewCell", bundle: nil),forCellReuseIdentifier:"DetailCell")
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        self.detailTableView.estimatedRowHeight = 110
        self.detailTableView.rowHeight = UITableView.automaticDimension
        BonusCountList = calc.getBonusCountList()
        BonusCountList.removeFirst()
        BonusAmountList = calc.getBonusAmountList()
        bonusNameList = calc.getBonusNameList()
        bonusNameList.removeFirst()
        resultBonusCountList = [String](repeating: "", count: self.bonusNameList.count)
        
        setPlayList()
        setInvestmentList()
        setStartList()
        setBonusCount()
        // Do any additional setup after loading the view.
    }
    
    func setPlayList() {
        let dt = Date()
        let dateFormatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        self.resultPlayList[0] = dateFormatter.string(from: dt)
        self.resultPlayList[1] = self.hallName
        self.resultPlayList[2] = "\(calc.formatDoubleNumber(num: calc.getRateMoney()))円/\(calc.formatDoubleNumber(num: calc.getRateBall()))玉"
        self.resultPlayList[3] = self.machineName
        self.resultPlayList[4] = "\(calc.getNumber())番台"
    }
    
    func setInvestmentList() {
        self.resultInvestmentList[0] = "\(calc.intFormat(num: calc.getInvestment()))円"
        self.resultInvestmentList[1] = "\(calc.intFormat(num: calc.getFirstPos()))玉"
        self.resultInvestmentList[2] = "\(calc.intFormat(num: calc.getCurrentPos()))玉"
        self.resultInvestmentList[3] = "\(calc.intFormat(num: calc.getDifference()))玉"
        self.resultInvestmentList[4] = "\(calc.intFormat(num: calc.getBOP()))円"
        self.resultInvestmentList[5] = "\(calc.intFormat(num: calc.getWork()))円"
        self.resultInvestmentList[6] = "\(calc.intFormat(num: calc.getBOP() - calc.getWork()))円"
        self.resultInvestmentList[7] = "\(calc.getHaveBallRate(money: calc.getInvestment()))%"
    }
    
    func setStartList() {
        let start = calc.getStart()
        let support = calc.getBonusCountList()[0]
        let rate = round((Double(support) / Double(start) * 100) * 100) / 100
        self.resultStartList[0] = "\(calc.intFormat(num: start + support + calc.getSKR()))回転"       //総回転
        self.resultStartList[1] = "\(calc.intFormat(num: start))回転"                                 //通常スタート
        self.resultStartList[2] = "\(calc.getTurnOver())回転"             //回転率
        self.resultStartList[3] = "\(calc.intFormat(num: support))回転"   //電サポ回転数
        self.resultStartList[4] = "\(rate)%"        //電サポ率
        
        if bonusNameList.last == "小当R"{
            self.resultStartList.append("\(calc.getSKR())回転")
            let skrRate = round(Double(calc.getSKR()) / Double(calc.getStart()) * 10000) / 100
            self.resultStartList.append("\(skrRate)%")
            self.startList.append("小当たりRUSH")
            self.startList.append("小当たりRUSH比率")
            bonusNameList.removeLast()
            resultBonusCountList.removeLast()
        }
    }
    //ホールA
    func setBonusCount() {
        for i in 0 ..< bonusNameList.count{
            if self.bonusNameList[i] != "小当R"{
                var bonusTotalList = calc.getBonusTotalList()
                bonusTotalList.removeFirst()
                let imaginarybonus = round(Double(calc.getStart()) / bonusTotalList[i] * 10) / 10
                self.resultBonusCountList[i] = "\(BonusCountList[i])回（\(imaginarybonus)回）"
            }
        }
    }
    
    
    //MARK:- tableView
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
               return resultPlayList.count
           } else if section == 1 {
               return resultInvestmentList.count
           } else if section == 2 {
            return resultStartList.count
           } else if section == 3 {
            return resultBonusCountList.count
           } else {
            return 0
           }
       }
    
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cellの内容を設定する。
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        if indexPath.section == 0 {
            cell.setLabel(left: playList[indexPath.row], right: resultPlayList[indexPath.row])
        } else if indexPath.section == 1 {
            cell.setLabel(left: investmentList[indexPath.row], right: resultInvestmentList[indexPath.row])
            if indexPath.row > 2 && indexPath.row < 7{
                cell.judgeColor(number: resultInvestmentList[indexPath.row])
            }
        } else if indexPath.section == 2 {
            cell.setLabel(left: startList[indexPath.row], right: resultStartList[indexPath.row])
        } else if indexPath.section == 3 {
            if bonusNameList[indexPath.row] != "小当R"{
                cell.setLabel(left: bonusNameList[indexPath.row], right: resultBonusCountList[indexPath.row])
            }
        }
        
        return cell
    }
    
    //MARK:- Button
    
    @IBAction func resetButton(_ sender: Any) {
        actionSheet()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let dt = Date()
        let dateFormatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        let rtToday = dateFormatter.string(from: dt)
        let rtHallID = getHallID(name: hallName)
        let rtMachineID = getMachineID(name: machineName)
        let rtPlayResult = calc.getBOP()
        let rtWrokResult = calc.getWork()
        let rtStart = calc.getStart()
        let rtBonusCount = intJoined(numList: calc.getBonusCountList())
        let rtBonusAmount = doubleJoined(numList: calc.getBonusAmountList())
        let rtInvestment = calc.getInvestment()
        let rtRental = calc.getRental()
        let rtRateMoney = calc.getRateMoney()
        let rtRateBall = calc.getRateBall()
        let rtInPos = calc.getInPos()
        let rtNumber = calc.getNumber()
        let rtDifference = calc.getDifference()
        
        
        let alert: UIAlertController = UIAlertController(title: "稼働終了しますか？", message: "保存してトップ画面に戻りますか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "稼働終了する", style: UIAlertAction.Style.default, handler:{ [self]
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let realm = try! Realm()
            
            let result = ResultTable(value: ["date": rtToday, "hallID": rtHallID, "machineID": rtMachineID, "playResult": rtPlayResult, "workResult": rtWrokResult, "start": rtStart, "bonusCount": rtBonusCount, "bonusAmount": rtBonusAmount, "investment": rtInvestment, "rental": rtRental, "rateMoney": rtRateMoney, "rateBall": rtRateBall, "inPOS": rtInPos, "memo": "", "number": rtNumber, "defference": rtDifference])
            try! realm.write{
                realm.add(result)
            }
            let alert2: UIAlertController = UIAlertController(title: "貯玉確認", message: "貯玉後:\(calc.getCurrentPos())玉", preferredStyle:  UIAlertController.Style.alert)
            // OKボタン
            let defaultAction2: UIAlertAction = UIAlertAction(title: "貯玉する", style: UIAlertAction.Style.default, handler:{ [self]
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                let realm = try! Realm()
                
                let resultHall = realm.objects(HallTable.self).filter("name == %@", self.hallName).first
                try! realm.write{
                    resultHall?.save = calc.getCurrentPos()
                }
                let insert = InsertData()
                insert.calc = self.calc
                insert.insertData(hallName: self.hallName, machineID: getMachineID(name: self.machineName))
                clv.returnTop()
                dismiss(animated: true)
            })
            // キャンセルボタン
            let cancelAction2: UIAlertAction = UIAlertAction(title: "貯玉しない", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action2: UIAlertAction!) -> Void in
                self.clv.returnTop()
                self.dismiss(animated: true)
            })
            // ③ UIAlertControllerにActionを追加
            alert2.addAction(cancelAction2)
            alert2.addAction(defaultAction2)

            // ④ Alertを表示
            present(alert2, animated: true, completion: nil)
            //clv.returnTop()
            //dismiss(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
        let alert2: UIAlertController = UIAlertController(title: "貯玉確認", message: "貯玉後:\(calc.getCurrentPos())玉", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction2: UIAlertAction = UIAlertAction(title: "貯玉する", style: UIAlertAction.Style.default, handler:{ [self]
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let realm = try! Realm()
            
            let resultHall = HallTable(value: ["save": calc.getCurrentPos()])
            try! realm.write{
                realm.add(resultHall)
            }
            clv.returnTop()
            dismiss(animated: true)
        })
        // キャンセルボタン
        let cancelAction2: UIAlertAction = UIAlertAction(title: "貯玉しない", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action2: UIAlertAction!) -> Void in
            self.clv.returnTop()
            self.dismiss(animated: true)
        })
        // ③ UIAlertControllerにActionを追加
        alert2.addAction(cancelAction2)
        alert2.addAction(defaultAction2)

        // ④ Alertを表示
        present(alert2, animated: true, completion: nil)




    }
    
    //MARK:- actionSheet
    private func actionSheet() {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        //var flag = false
        let alert: UIAlertController = UIAlertController(title: "ログが消失します", message: "ログをリセットして最初の画面に戻りますか？", preferredStyle:  UIAlertController.Style.alert)
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "リセットする", style: UIAlertAction.Style.default, handler:{ [self]
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            clv.returnTop()
            dismiss(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)

    }
    
    private func getMachineID(name:String) -> Int{
        let realm = try! Realm()
        let result = realm.objects(MachineTable.self).filter("name = %@", name)
        return result[0].id
    }
    
    private func getHallID(name:String) -> Int{
        let realm = try! Realm()
        let result = realm.objects(HallTable.self).filter("name = %@", name)
        return result[0].id
    }
    
    private func intJoined(numList: [Int]) -> String{
       // var strList: [String]
        var strList = [String](repeating: "", count: numList.count)
        for i in 0 ..< numList.count{
            strList[i] = (String(numList[i]))
        }
        return strList.joined(separator: "/")
    }
    
    private func doubleJoined(numList: [Double]) -> String{
       // var strList: [String]
        var strList = [String](repeating: "", count: numList.count)
        for i in 0 ..< numList.count{
            strList[i] = (String(numList[i]))
        }
        return strList.joined(separator: "/")
    }
    
    
}
