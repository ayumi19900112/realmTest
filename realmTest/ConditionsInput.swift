//
//  ConditionsInput.swift
//  realmTest
//


import UIKit
import RealmSwift

class ConditionsInput: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var nameLabel: UILabel!                  //機種名ラベル
    @IBOutlet weak var hallTableView: UITableView!
    @IBOutlet weak var hallSearchBar: UISearchBar!
    @IBOutlet weak var hallNameLabel: UILabel!              //ホールラベル
    @IBOutlet weak var firstPosTextField: UITextField!      //打ち始め持ち玉textField
    @IBOutlet weak var firstStartTextField: UITextField!    //打ち始めスタートtextField
    @IBOutlet weak var rateMoneyTextField: UITextField!     //rate(円)textField
    @IBOutlet weak var rateBallTextField: UITextField!      //rate(玉)textField
    @IBOutlet weak var rentalTextField: UITextField!        //貸し玉
    @IBOutlet weak var numberTextField: UITextField!        //台番号
    
    
    var hallID = 0
    var machineID: Int!
    
    var hallList: Results<HallTable>!
    var machineNameList: Results<MachineTable>!
    
    var hallSelect = false
    
    
    var realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hallSearchBar.delegate = self
        self.hallTableView.delegate = self
        self.hallTableView.dataSource = self
        
        self.machineNameList = realm.objects(MachineTable.self).filter("id == \(machineID!)")
        nameLabel.text! = machineNameList[0].name
        hallList = realm.objects(HallTable.self)
        setAmount()
        
        //完了ボタン
        //キーボードに完了のツールバーを作成
        let doneToolbar = UIToolbar()
        doneToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTaped))
        doneToolbar.items = [spacer, doneButton]
        firstPosTextField.inputAccessoryView = doneToolbar
        firstStartTextField.inputAccessoryView = doneToolbar
        rateMoneyTextField.inputAccessoryView = doneToolbar
        rateBallTextField.inputAccessoryView = doneToolbar
        rentalTextField.inputAccessoryView = doneToolbar
        hallSearchBar.inputAccessoryView = doneToolbar
        numberTextField.inputAccessoryView = doneToolbar
        
    }
    
    func setAmount(){
        let lastResult = realm.objects(ResultTable.self).filter("machineID == %@", machineID)
        if lastResult.count != 0{
            do{
                try realm.write{
                    let amount = lastResult.last?.bonusAmount
                    machineNameList[0].bonusAmount = amount!
                }
            }catch{
                
            }
        }
    }
    // MARK: - addHallButton
    
    @IBAction func addHallButtonAction(_ sender: Any) {
        
        var flag = true
        var addHallName = ""
        var addRateMoney = 0.0
        var addRateBall = 0.0
        //アラートコントローラー
        let alert = UIAlertController(title: "ホールを新たに追加します", message: "各項目を入力してください", preferredStyle: .alert)
        
        //OKボタンを追加
        let okAction = UIAlertAction(title: "追加する", style: .default) { [self] (action:UIAlertAction) in
            //複数のtextFieldのテキストを格納
            guard let textFields:[UITextField] = alert.textFields else {return}
            //textからテキストを取り出していく
            for textField in textFields {
                if textField.tag == 1 {
                    if textField.text == ""{
                        flag = false
                    }else{
                        addHallName = textField.text!
                    }
                }else if textField.tag == 2{
                    if textField.text == "" && Double(textField.text!) == nil{
                        flag = false
                    }else{
                        addRateMoney = Double(textField.text!)!
                    }
                }else{
                    if textField.text == "" && Double(textField.text!) == nil{
                        flag = false
                    }else{
                        addRateBall = Double(textField.text!)!
                    }
                }
            }
            
            if flag == true{
                let addHallTable = HallTable(value: ["id": createNewId(), "name": addHallName, "rateBall": addRateBall, "rateMoney": addRateMoney, "save": 0])
                do{
                    try realm.write{
                        realm.add(addHallTable)
                        printAlert(title: "追加成功", message: "追加できました")
                    }
                }catch {
                  printAlert(title: "追加失敗", message: "数値が入力されていないか、テキストが入力されていない可能性がありました")
                }
                hallTableView.reloadData()
            }else{
                printAlert(title: "追加失敗", message: "数値が入力されていないか、テキストが入力されていない可能性がありました")
            }
            
            
        }
        
        alert.addAction(okAction)
        //Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //Cancelボタンを追加
        alert.addAction(cancelAction)
        
        
        //TextFieldを２つ追加
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "ホール名"
            //text.text = updateHallName
            text.tag = 1
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "交換率（円）"
            //text.text = String(updateRateMoney)
            text.keyboardType = .decimalPad
            text.tag = 2
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "交換率（玉）"
            //text.text = String(updateRateBall)
            text.keyboardType = .decimalPad
            text.tag = 3
        }
        
        //アラートを表示
        present(alert, animated: true, completion: nil)
        

    }
    
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(HallTable.self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
    
    
    // MARK: - tableView
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hallList.count
    }
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hallTableView.dequeueReusableCell(withIdentifier: "HallNameCell", for: indexPath)
        let name = self.hallList[indexPath.row]
        cell.textLabel?.text = name.name
        return cell
    }
    
    //タップされたとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hallSelect = true
        hallNameLabel.text = hallList[indexPath.row].name
        rateMoneyTextField.text = String(hallList[indexPath.row].rateMoney)
        rateBallTextField.text = String(hallList[indexPath.row].rateBall)
        self.hallID = hallList[indexPath.row].id
        hallNameLabel.textColor = .black
    }

    // MARK:- searchBarの処理
    //  検索バーに入力があったら呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if hallSearchBar.text == "" {
            hallList = realm.objects(HallTable.self)
        } else {
            hallList = realm.objects(HallTable.self).filter("name LIKE '*\(hallSearchBar.text!)*'")
        }
        hallTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.hallSearchBar.endEditing(true)
    }
    
    @IBAction func startLogButton(_ sender: Any) {
        if hallSelect == false {
            hallNameLabel.textColor = .red
            hallNameLabel.text = "ホールを選択してください！！！"
        }
    }
    
    // MARK:- segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrentLogView" {
            guard self.numberTextField.text != "" else {
                alert(message: "台番号が未入力です！")
                return
            }
            guard self.firstPosTextField.text != "" else {
                alert(message: "開始時持ち玉が未入力です！")
                return
            }
            guard self.firstStartTextField.text != "" else {
                alert(message: "開始時スタートが未入力です！")
                return
            }
            guard self.rentalTextField.text != "" else {
                alert(message: "貸し玉が未入力です！")
                return
            }
            guard self.rateMoneyTextField.text != "" && self.rateBallTextField.text != "" else {
                alert(message: "交換率が未入力です！")
                return
            }
            if textCheck() == false{
                return
            }
            let nextView = segue.destination as! CurrentLogViewController
            nextView.firstStart = Int(firstStartTextField.text!)        //打ち始めスタート
            nextView.firstPos = Int(firstPosTextField.text!)            //打ち始め持ち玉
            nextView.hallID = Int(self.hallID)                          //ホールID
            nextView.rateMoney = Double(self.rateMoneyTextField.text!)  //交換率（円）
            nextView.rateBall = Double(self.rateBallTextField.text!)    //交換率（玉）
            nextView.machineID = Int(self.machineID!)                   //機種ID
            nextView.rental = Int(self.rentalTextField.text!)           //貸し玉
            nextView.number = Int(self.numberTextField.text!)           //台番号
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            super.shouldPerformSegue(withIdentifier: "toCurrentLogView", sender: sender)

            // When the switch is off, it cancels the segue. 
            return hallSelect
        }
    
    //MARK:- 完了ボタン
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        firstPosTextField.endEditing(true)
        firstStartTextField.endEditing(true)
        rateMoneyTextField.endEditing(true)
        rateBallTextField.endEditing(true)
        rentalTextField.endEditing(true)
        hallSearchBar.endEditing(true)
        numberTextField.endEditing(true)
    }
    //MARK:- Alert
    //アラート
    private func alert(message: String) {
         let alertController = UIAlertController(title: "エラー",message: message, preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(action)
         present(alertController, animated: true, completion: nil)
     }
    
    private func textCheck() -> Bool{
        if Int(numberTextField.text!) == nil{
            alert(message: "台番号は半角数値で入力してください")
            return false
        }
        if Int(firstPosTextField.text!) == nil{
            alert(message: "開始時持ち玉は半角数値で入力してください")
            return false
        }else if Int(firstPosTextField.text!)! < 0{
            alert(message: "開始時持ち玉は正の整数か0を入力してください")
        }
        if Int(firstStartTextField.text!) == nil{
            alert(message: "開始時スタートは半角数値で入力してください")
            return false
        }else if Int(firstStartTextField.text!)! < 0{
            alert(message: "開始時スタートは正の整数か0を入力してください")
            return false
        }
        if Int(rentalTextField.text!) == nil{
            alert(message: "貸し玉は半角数値で入力してください")
            return false
        }else if Int(rentalTextField.text!)! <= 0{
            alert(message: "貸し玉は正の整数で入力してください")
            return false
        }
        if Double(rateMoneyTextField.text!) == nil{
            alert(message: "交換率は数値を入力してください")
            return false
        }else if Double(rateMoneyTextField.text!)! <= 0{
            alert(message: "交換率は正の数値を入力してください")
            return false
        }
        if Double(rateBallTextField.text!) == nil{
            alert(message: "交換率は数値を入力してください")
            return false
        }else if Double(rateBallTextField.text!)! <= 0{
            alert(message: "交換率は正の数値を入力してください")
            return false
        }
        return true
    }
    
    func printAlert(title: String, message: String){
        let alertController = UIAlertController(title: title,message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
