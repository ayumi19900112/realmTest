//
//  CurrentLogViewController.swift
//  PachinkoLog
//


import UIKit
import RealmSwift
import SwiftUI



class CurrentLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource, UITabBarDelegate {
    @IBOutlet weak var titleHallLabel: UILabel!
    @IBOutlet weak var titleMachineLabel: UILabel!
    @IBOutlet weak var resultTimeLabel: UILabel!
    
    @IBOutlet weak var currentBallStepper: UIStepper!      //ステッパー
    @IBOutlet weak var investmentStepper: UIStepper!
    //前のviewからの情報
    var firstStart: Int!        //打ち始めスタート
    var firstPos: Int!          //打ち始め持ち玉
    var rateMoney: Double!      //交換率（円）
    var rateBall: Double!       //交換率（玉）
    var hallID: Int!            //ホールID
    var machineID: Int!         //機種ID
    var rental: Int!            //貸し玉
    var number: Int!
    
    var logStart: [Int] = []          // スタート履歴
    var logFlag = ["開始"]      // 大当たり履歴
    var bonusCount: [Int] = []      //大当たり回数記録用
    var bonusAmountArray: [Double] = []
    var yutime = YuTime()
    var pivotAmountIndex = 1     //大当たり基準をどれにするか
    
    //Itemの紐付け
    //input
    @IBOutlet weak var investmetTextField: UITextField!     //現金投資
    @IBOutlet weak var currentBallTextField: UITextField!   //現在持ち玉
    @IBOutlet weak var currentStartTextField: UITextField!  //現在スタート
    @IBOutlet weak var bonusPickerView: UIPickerView!       //大当たりピッカー
    var pickerList = ["電サポ抜け", ""]
    @IBOutlet weak var inputButton: UIButton!               //計算してみる
    
    //bonusamount
    @IBOutlet weak var bonusTableView: UITableView!     //大当たり出玉入力
    @IBOutlet weak var setAmountButton: UIButton!       //基準値設定
    //log
    @IBOutlet weak var logTableView: UITableView!       //log情報
    //result
    @IBOutlet weak var resultStartLabel: UILabel!       //スタート
    @IBOutlet weak var resultTurnOverLabel: UILabel!
    @IBOutlet weak var resultBOPLabel: UILabel!              //収支
    @IBOutlet weak var resultWorkLabel: UILabel!             //仕事量
    @IBOutlet weak var resultHaveRate: UILabel!             //持ち玉比率
    @IBOutlet weak var ytLabel: UILabel!
    @IBOutlet weak var ytResultLabel: UILabel!
    @IBOutlet weak var ytCountLabel: UILabel!
    @IBOutlet weak var ytCountResultLabel: UILabel!
    
    
    @IBOutlet weak var addTableButton: UIButton!        //結果を登録する
    
    //計算用
    let calc = Calc()
    var bonusName: [String]!
    var totalProbability: [Double]!
    var bonusAmount: Double!
    var bonusRate: [Double]!
    
    //realm
    let realm = try! Realm()
    var machineList: Results<MachineTable>!
    var hallList: Results<HallTable>!
    
    //UserDefaults用クラス
    let ud = UD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true        //ナビゲーションバー非表示
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false       //スワイプで戻る無効
        
        bonusTableView.register(UINib(nibName: "BonusAmountTableViewCell", bundle: nil),forCellReuseIdentifier:"BonusAmountCell")
        logTableView.register(UINib(nibName: "LogTableViewCell", bundle: nil),forCellReuseIdentifier:"LogCell")
        

        if logStart.count == 0{
            logStart.append(firstStart)
        }
        
        //delegate,datasource
        logTableView.delegate = self
        logTableView.dataSource = self
        bonusTableView.delegate = self
        bonusTableView.dataSource = self
        bonusPickerView.delegate = self
        bonusPickerView.dataSource = self
        
        //realm
        machineList = realm.objects(MachineTable.self).filter("id == %@", machineID!)
        hallList = realm.objects(HallTable.self).filter("id = %@", hallID!)
        titleMachineLabel.text = machineList[0].name
        titleHallLabel.text = hallList[0].name
        
        //大当たり出玉
        setMachineInfo()
        //pickerに表示する文字列
         setPickerList()
        //calcset
        bonusAmountArray = machineList[0].bonusAmount.components(separatedBy: "/").map{Double($0)!}
        setCalc()
        
        currentBallTextField.text = String(firstPos)
        currentStartTextField.text = String(firstStart)
        
        //bonusCountを0にする
        for _ in 0 ..< bonusName!.count {
            bonusCount.append(0)
        }
        
        //大当たり出玉のボタンタイトルをセット
        setAmountButton.setTitle("\(bonusName[1])基準で設定", for: .normal)
        //遊タイムラベル
        ytResultLabel.text = ""
        ytLabel.text = ""
        ytCountLabel.text = ""
        ytCountResultLabel.text = ""
        /*
        for i in 0 ..< bonusRate.count{
            let amount = bonusAmount[1] * bonusRate[i]
            bonusAmountArray[i] = amount
        }
        */
        //PickerViewの選択状態を""にする
        bonusPickerView.selectRow(1, inComponent: 0, animated: false)
        
        //キーボードに完了のツールバーを作成
        let doneToolbar = UIToolbar()
        doneToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTaped))
        doneToolbar.items = [spacer, doneButton]
        investmetTextField.inputAccessoryView = doneToolbar
        currentBallTextField.inputAccessoryView = doneToolbar
        currentStartTextField.inputAccessoryView = doneToolbar
           
    }

    
    // MARK:- tableView
    //要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bonusTableView{
            return bonusName.count
        }else{
            return logStart.count
        }
    }
    
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bonusTableView {
            let bonusAmountCell = tableView.dequeueReusableCell(withIdentifier: "BonusAmountCell", for: indexPath) as! BonusAmountTableViewCell
            bonusAmountArray = machineList[0].bonusAmount.components(separatedBy: "/").map{Double($0)!}
            bonusAmountCell.setLabel(label: bonusName[indexPath.row])
            let num = round(bonusAmountArray[indexPath.row] * 100) / 100
            bonusAmountCell.setTextField(number: String(num))
            
            bonusAmountCell.tag = indexPath.row
            bonusAmountCell.machineID = self.machineID
            
            return bonusAmountCell
        }else{
            let logCell = logTableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogTableViewCell
            logCell.setLabel(start: String(logStart[indexPath.row]), bonus: logFlag[indexPath.row])
            return logCell
        }
    }
    

    
    // セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == logTableView && indexPath.row != 0{
            return true
        }else{
            return false
        }
    }

    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            actionSheet(indexPath: indexPath)
       }
    }
    
    // セルがタップされたとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == bonusTableView{
            if indexPath.row > 0 && bonusName[indexPath.row] != "小当R"{
                pivotAmountIndex = indexPath.row
                setAmountButton.setTitle("\(bonusName[indexPath.row])基準で設定", for: .normal)
            }
        }
    }

    
    func textFieldDidEndEditing(textField: UITextField) {
      if let cell = textField.superview?.superview as? UITableViewCell,
         let indexPath = bonusTableView.indexPath(for: cell){
      }
    }

    
    
    // MARK:- Button
    //基準で設定
    @IBAction func setBonusAmountButton(_ sender: Any) {
        machineList = realm.objects(MachineTable.self).filter("id == %@", machineID!)
        let pa = machineList[0].bonusAmount.components(separatedBy: "/").map{Double($0)!}

        for i in 1 ..< bonusAmountArray.count{
            if bonusName[i] != "小当R"{
                bonusAmountArray[i] = round(pa[pivotAmountIndex] * (bonusRate[i] / bonusRate[pivotAmountIndex]) * 10) / 10
            }else{
                bonusAmountArray[i] = pa[i]
            }
        }
        var strArr = [String](repeating: "0.0", count: self.bonusAmountArray.count)
        strArr[0] = String(pa[0])
        for i in 1 ..< strArr.count{
            strArr[i] = String(bonusAmountArray[i])
        }
        do{
            try realm.write{
                machineList[0].bonusAmount = strArr.joined(separator: "/")
            }
        }catch {
                print("Error")
        }
        bonusTableView.reloadData()
    }
    
    
    

    //計算ボタン
    @IBAction func calcButton(_ sender: Any){
        setMachineInfo()
        
        guard investmetTextField.text != "" else {
            alert(message: "現金投資が未入力です！")
            return
        }
        guard currentStartTextField.text != "" else {
            alert(message: "現在スタートが未入力です！")
            return
        }
        guard currentBallTextField.text != "" else {
            alert(message: "現在持ち玉が未入力です！")
            return
        }
        if checkText() == false{
            return
        }
        //キーボードを閉じる
        view.endEditing(true)
        //大当たり出玉を入れる
        //setBonusAmount()
        
        //logList更新
        if logFlag.last != "" {
            logStart.append(Int(currentStartTextField.text!)!)
        }else{
            logStart[logStart.count - 1] = Int(currentStartTextField.text!)!
        }

        if bonusPickerView.selectedRow(inComponent: 0) != 1 && logFlag.last != ""{
            logFlag.append(pickerList[bonusPickerView.selectedRow(inComponent: 0)])
        }else{
            if logFlag.last == "" {
                logFlag[logFlag.count - 1] = (pickerList[bonusPickerView.selectedRow(inComponent: 0)])
            }else{
                logFlag.append(pickerList[bonusPickerView.selectedRow(inComponent: 0)])
            }
        }
        
        //計算

        setCalc()
        
        let start = calc.getStart()     //スタート
        self.resultStartLabel.text = "\(String(start))回転"
        self.resultTurnOverLabel.text = "\(String(calc.getTurnOver()))回転"
        self.resultBOPLabel.text = "\(calc.intFormat(num: calc.getBOP()))円"
        if calc.getBOP() < 0{
            resultBOPLabel.textColor = .red
        }else if calc.getBOP() > 0{
            resultBOPLabel.textColor = .blue
        }
        self.resultWorkLabel.text = "\(calc.intFormat(num: calc.getWork()))円"
        if calc.getWork() < 0 {
            resultWorkLabel.textColor = .red
        }else if calc.getWork() > 0{
            resultWorkLabel.textColor = .blue
        }
        self.resultHaveRate.text = "\(String(calc.getHaveBallRate(money: Int(investmetTextField!.text!)!)))%"
        

        //tableViewReload
        logTableView.reloadData()
        let section = self.logTableView.numberOfSections - 1
        let row = self.logTableView.numberOfRows(inSection: section) - 1
        let indexPath = NSIndexPath(row: row, section: section)
        logTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        bonusPickerView.selectRow(1, inComponent: 0, animated: false)
        currentStartTextField.text = ""
        
        //計算結果ラベルに打刻
        let dt = Date()
        let dateFormatter = DateFormatter()

        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Hm", options: 0, locale: Locale(identifier: "ja_JP"))
        self.resultTimeLabel.text = "計算結果 \(dateFormatter.string(from: dt))"
        
        //遊タイム計算
        yutime.machineID = self.machineID
        yutime.rateBall = self.rateBall
        yutime.rateMoney = self.rateMoney
        yutime.haveBall = Int(currentBallTextField!.text!)!
        yutime.bonusAmount = self.bonusAmountArray
        yutime.bonusProbability = machineList[0].probability
        if logFlag[logFlag.count - 2] == "電サポ抜け"{
            yutime.densapo = logStart[logStart.count - 2]
        }
        yutime.currentStart = logStart.last!
        yutime.turnOver = calc.getTurnOver()
        yutime.yuCount = machineList[0].playTime
        yutime.toYT = machineList[0].playTime - Int(logStart.last!)
        yutime.rental = self.rental
        
        yutime.getData()
        if yutime.calcYuValue(){
            ytLabel.text = "YT期待値"
            ytResultLabel.text = "\(calc.intFormat(num: yutime.yuValue))円"
            if yutime.yuValue > 0{
                ytResultLabel.textColor = .blue
            }else if yutime.yuValue < 0{
                ytResultLabel.textColor = .red
            }else{
                ytResultLabel.textColor = .black
            }
            ytCountLabel.text = "YTまで"
            ytCountResultLabel.text = "\(yutime.toYT)回転"
            //ytCountResultLabel.text = "\(yutime.yuCount - yutime.currentStart)回転"
        }else{
            
            ytLabel.text = ""
            ytResultLabel.text = ""
            ytCountLabel.text = ""
            ytCountResultLabel.text = ""
             
        }
        
        
        saveUserDefaults()      //userDefaultsに保存

    }
    
    
    @IBAction func resultButton(_ sender: Any) {
        performSegue(withIdentifier: "ToDetailSegue", sender: nil)
    }
    
    //MARK:- segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            // 遷移先のクラスのプロパティに値を代入する
            
            vc.calc = self.calc
            vc.machineName = machineList[0].name
            vc.hallName = hallList[0].name
            vc.clv = self
        }
    }

    // MARK:-　変数に計算用の情報を代入
    func setMachineInfo (){
        bonusName = machineList[0].bonusName.components(separatedBy: "/")
        totalProbability = machineList[0].totalProbability.components(separatedBy: "/").map{Double($0)!}
        bonusRate = machineList[0].bonusRate.components(separatedBy: "/").map{Double($0)!}
        bonusAmountArray = machineList[0].bonusAmount.components(separatedBy: "/").map{Double($0)!}
    }
    
    func setPickerList (){
        for i in 2 ..< bonusName.count + 1 {
            pickerList.append(bonusName[i - 1])
        }
        if machineList[0].c != 0{
            pickerList.append("c時短")
        }
        if machineList[0].playTime != 0{
            pickerList.append("遊タイム突入")
        }
        
    }
    
    func setBonusAmount (){
        for i in 0 ..< bonusName.count{
            let indexpath: IndexPath = IndexPath(row: i, section: 0)
            let cellZero = bonusTableView.cellForRow(at: indexpath)
            let textField = cellZero?.contentView.viewWithTag(1) as? UITextField
            guard textField!.text != "" else {
                alert(message: "大当たり出玉が未入力！")
                return
            }
            if Double(textField!.text!) == nil{
                alert(message: "大当たり出玉は半角数値を入力してください")
                return
            }
            let pivotAmount = Double(textField!.text!)
            bonusAmountArray[i] = round(pivotAmount! * 10) / 10
        }
        
    }
    

    // MARK:- pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return pickerList[row]
    }

    //MARK:- その他
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        investmetTextField.endEditing(true)
        currentStartTextField.endEditing(true)
        currentBallTextField.endEditing(true)
    }
    
    //アラート
    private func alert(message: String) {
         let alertController = UIAlertController(title: "エラー",message: message, preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(action)
         present(alertController, animated: true, completion: nil)
     }
    
    private func actionSheet(indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{ [self]
            // 削除処理
            (action: UIAlertAction!) -> Void in
            self.logStart.remove(at: indexPath.row)
            self.logFlag.remove(at: indexPath.row)
            logTableView.reloadData()
        })
        // キャンセル処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }
    
    func setCalc() {
        calc.setFirstPos(number: self.firstPos)
        calc.setCurrentPos(number: Int(currentBallTextField!.text!)!)
        calc.setFirstStart(number: self.firstStart)
        calc.setCurrentStart(number: Int(currentStartTextField!.text!)!)
        calc.setRateBall(number: self.rateBall)
        calc.setRateMoney(number: self.rateMoney)
        calc.setSetRental(number: self.rental)
        calc.setNumber(number: self.number)
        calc.setBonusNameList(array: bonusName)
        calc.setStartLogList(array: logStart)
        calc.setBonusLogList(array: logFlag)
        calc.setInvestment(number: Int(investmetTextField!.text!)!)
        calc.setBonusTotalList(array: totalProbability)
        calc.setBonusAmountList(array: bonusAmountArray)
        calc.calcBonusCount()
    }
    
    func returnTop(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkText() -> Bool{
        if Int(investmetTextField.text!) == nil{
            alert(message: "現金投資は正の整数を半角で入力してください")
            return false
        }else if Int(investmetTextField.text!)! < 0{
            alert(message: "現金投資は正の整数か0を入力してください")
            return false
        }
        if Int(investmetTextField.text!) == nil{
            alert(message: "現金投資は正の整数を半角で入力してください")
            return false
        }else if Int(investmetTextField.text!)! < 0{
            alert(message: "現金投資は正の整数か0を入力してください")
            return false
        }
        if Int(currentBallTextField.text!) == nil{
            alert(message: "現在持ち玉は正の整数を半角で入力してください")
            return false
        }else if Int(currentBallTextField.text!)! < 0{
            alert(message: "現在持ち玉は正の整数か0を入力してください")
            return false
        }
        if Int(currentStartTextField.text!) == nil{
            alert(message: "現在スタートは正の整数を半角で入力してください")
            return false
        }else if Int(currentStartTextField.text!)! < 0{
            alert(message: "現在スタートは正の整数か0を入力してください")
            return false
        }
        return true
    }
    
    @IBAction func changeToYT(_ sender: Any) {
        var alertTextField: UITextField?

                let alert = UIAlertController(
                    title: "到達までのスタート数を変更",
                    message: "低確率\(machineList[0].playTime)回転で遊タイム突入",
                    preferredStyle: UIAlertController.Style.alert)
                alert.addTextField(
                    configurationHandler: {(textField: UITextField!) in
                        alertTextField = textField
                        textField.text = String(self.yutime.toYT)
                        textField.placeholder = "到達まであと何回転かを入力"
                        textField.keyboardType = .numberPad
                        // textField.isSecureTextEntry = true
                })
                alert.addAction(
                    UIAlertAction(
                        title: "Cancel",
                        style: UIAlertAction.Style.cancel,
                        handler: nil))
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: UIAlertAction.Style.default) { _ in
                        if let text = alertTextField?.text {
                            self.ytCountResultLabel.text = text + "回転"
                            self.yutime.toYT = Int(text)!
                            if self.yutime.calcYuValue(){
                                self.ytResultLabel.text = "\(self.calc.intFormat(num: self.yutime.yuValue))円"
                                if self.yutime.yuValue > 0{
                                    self.ytResultLabel.textColor = .blue
                                }else if self.yutime.yuValue < 0{
                                    self.ytResultLabel.textColor = .red
                                }else{
                                    self.ytResultLabel.textColor = .black
                                }
                            }
                            
                        }
                    }
                )

                self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - stepper
    
    @IBAction func stepper(_ sender: Any) {
        var ball = 0
        if currentBallTextField.text == ""{
            ball = 0
        }else{
            ball = Int(currentBallTextField.text!)!
        }
        let printBall = Int(currentBallStepper.value) + ball
        if printBall < 0{
            currentBallTextField.text = "0"
        }else{
            currentBallTextField.text = String(printBall)
        }
        currentBallStepper.value = 0.0
    }
    
    @IBAction func moneyStepper(_ sender: Any) {
        var money = 0
        if investmetTextField.text == ""{
            money = 0
        }else{
            money = Int(investmetTextField.text!)!
        }
        let printMoney = Int(investmentStepper.value) + money
        if printMoney < 0{
            investmetTextField.text = "0"
        }else{
            investmetTextField.text = String(printMoney)
        }
        investmentStepper.value = 0.0
        
    }
    
    // MARK: - UserDefaults
    //userDefaultsに保存
    func saveUserDefaults(){
        //userDefaultsに保存
        /*
        ud.firstPos = self.firstPos
        ud.firstStart = self.firstStart
        ud.logStart = self.logStart
        ud.logBonus = self.logFlag
        ud.investment = Int(investmetTextField.text!)!
        ud.currentPos = Int(currentBallTextField.text!)!
        ud.number = self.number
        ud.machineID = self.machineID
        ud.hallID = self.hallID
        ud.setData()
         */
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        else{
            return
        }
        UserDefaults.standard.set(data, forKey: "data")
        UserDefaults.standard.synchronize()
        
    }
    
    func showUserDefaults(){
        print("投資金額：", ud.getInvestment())
        print("投資金額：", ud.getInvestment())
        print("投資金額：", ud.getInvestment())
        print("投資金額：", ud.getInvestment())
    }
    
    // MARK: -仕事量タップしたとき
    
    
    
}
