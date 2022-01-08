//
//  EditHallViewController.swift
//  PachinkoLog
//

import UIKit
import RealmSwift

class EditHallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var hallNameTextField: UITextField!
    @IBOutlet weak var rateMoneyTextField: UITextField!
    @IBOutlet weak var rateBallTextField: UITextField!
    @IBOutlet weak var hallListTableView: UITableView!
    @IBOutlet weak var hallSearchBar: UISearchBar!
    @IBOutlet weak var saveBallTextField: UITextField!
    
    
    let realm = try! Realm()
    var hallList: Results<HallTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hallListTableView.register (UINib(nibName: "HallEditTableViewCell", bundle: nil),forCellReuseIdentifier:"HallCell")
        hallList = realm.objects(HallTable.self).sorted(byKeyPath: "name")
        
        hallListTableView.dataSource = self
        hallListTableView.delegate = self
        self.hallSearchBar.delegate = self
        // Do any additional setup after loading the view.
        
        //完了ボタン
        //キーボードに完了のツールバーを作成
        let doneToolbar = UIToolbar()
        doneToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTaped))
        doneToolbar.items = [spacer, doneButton]
        hallNameTextField.inputAccessoryView = doneToolbar
        rateMoneyTextField.inputAccessoryView = doneToolbar
        rateBallTextField.inputAccessoryView = doneToolbar
        saveBallTextField.inputAccessoryView = doneToolbar
        hallSearchBar.inputAccessoryView = doneToolbar
        
        let numberStr = ""
        print("変換 -> \(Double(numberStr))")
        //let numberDbl = Double(numberStr)
    }
    
    // 完全に全ての読み込みが完了時に実行
    override func viewDidAppear(_ animated: Bool) {
        self.hallListTableView.reloadData()
    }
    //MARK: - 完了ボタン
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        hallNameTextField.endEditing(true)
        rateBallTextField.endEditing(true)
        rateMoneyTextField.endEditing(true)
        saveBallTextField.endEditing(true)
        hallSearchBar.endEditing(true)
    }
    // MARK: - TabelView
    //Cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hallList.count
    }
    //Cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hallListTableView.dequeueReusableCell(withIdentifier: "HallCell", for: indexPath) as! HallEditTableViewCell
        cell.setHallLabel(name: hallList[indexPath.row].name)
        cell.setRateLabel(money: hallList[indexPath.row].rateMoney, ball: hallList[indexPath.row].rateBall)
        cell.setSave(save: hallList[indexPath.row].save, money: hallList[indexPath.row].rateMoney, ball: hallList[indexPath.row].rateBall)
        return cell
    }
    
    //section使う時に必須のメソッド
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        hallSearchBar.placeholder = "ホール名入力"
//        search.delegate = self //これを書かないとsearchButtonClickedとかのdelegate動かない
        return hallSearchBar
    }

    //searchBarの幅に合わせる為に必要な処理
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     
    //選択されたセルを更新
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        
        let hallName = hallList[indexPath.row].name
        var updateHallName = hallList[indexPath.row].name
        var updateRateMoney = hallList[indexPath.row].rateMoney
        var updateRateBall = hallList[indexPath.row].rateBall
        var updateSaveBall = hallList[indexPath.row].save
        var flag = true
        //アラートコントローラー
        let alert = UIAlertController(title: "\(hallName)を更新します", message: "各項目を入力してください", preferredStyle: .alert)
        var alertController: UIAlertController!
        //OKボタンを生成
        let okAction = UIAlertAction(title: "更新する", style: .default) { [self] (action:UIAlertAction) in
            //複数のtextFieldのテキストを格納
            guard let textFields:[UITextField] = alert.textFields else {return}
            //textからテキストを取り出していく
            for textField in textFields {
                if textField.tag == 1 {
                    if textField.text != ""{
                        updateHallName = textField.text!
                    }else{
                        flag = false
                    }
                }else if textField.tag == 2{
                    if textField.text != "" && Double(textField.text!) != nil{
                        updateRateMoney = Double(textField.text!)!
                    }else{
                        flag = false
                    }
                }else if textField.tag == 3{
                    if textField.text != "" && Double(textField.text!) != nil{
                        updateRateBall = Double(textField.text!)!
                    }else{
                        flag = false
                    }
                }else if textField.tag == 4{
                    if textField.text == ""{
                        textField.text = "0"
                    }
                    if textField.text != "" && Int(textField.text!) != nil{
                        updateSaveBall = Int(textField.text!)!
                    }else{
                        flag = false
                    }
                }
            }
            let target = realm.objects(HallTable.self).filter("id == %@", hallList[indexPath.row].id).first
            if flag == true{
                do{
                    try realm.write{
                        target?.name = updateHallName
                        target?.rateMoney = updateRateMoney
                        target?.rateBall = updateRateBall
                        target?.save = updateSaveBall
                        printAlert(title: "更新成功", message: "更新できました")
                    }
                }catch {
                  printAlert(title: "更新失敗", message: "数値が入力されていないか、テキストが入力されていない可能性がありました")
                }
                hallListTableView.reloadData()
            }else{
                printAlert(title: "更新失敗", message: "数値が入力されていないか、テキストが入力されていない可能性がありました")
            }
        }
        //OKボタンを追加
        alert.addAction(okAction)
        
        //Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //Cancelボタンを追加
        alert.addAction(cancelAction)
        
        //TextFieldを２つ追加
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "ホール名"
            text.text = updateHallName
            text.tag = 1
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "交換率（円）"
            text.text = String(updateRateMoney)
            text.keyboardType = .decimalPad
            text.tag = 2
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "交換率（玉）"
            text.text = String(updateRateBall)
            text.keyboardType = .decimalPad
            text.tag = 3
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "貯玉（玉）"
            text.text = String(updateSaveBall)
            text.keyboardType = .numberPad
            text.tag = 4
        }
        
            
        //アラートを表示
        present(alert, animated: true, completion: nil)
        //present(alertController, animated: true, completion: nil)
    
        
    }
    
    // セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Cellの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            actionSheet(indexPath: indexPath)
       }
    }

    // MARK: - searchBarの処理
    //  検索バーに入力があったら呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if hallSearchBar.text == "" {
            hallList = realm.objects(HallTable.self)
        } else {
            hallList = realm.objects(HallTable.self).filter("name LIKE '*\(hallSearchBar.text!)*'")
        }
        hallListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.hallSearchBar.endEditing(true)
    }
    
    //MARK: - Button
    
    @IBAction func addButton(_ sender: Any) {
  
        if hallNameTextField.text == "" {
            printAlert(title: "エラー", message: "ホール名を入力してください")
            return
        }
        if rateMoneyTextField.text == ""{
            printAlert(title: "エラー", message: "交換率が未入力です")
            return
        }
        if rateBallTextField.text == ""{
            printAlert(title: "エラー", message: "交換率が未入力です")
            return
        }
        if rateBallTextField.text == ""{
            printAlert(title: "エラー", message: "交換率が未入力です")
            return
        }
        if saveBallTextField.text == ""{
            saveBallTextField.text = "0"
        }
        print("玉：\(Double(rateBallTextField.text!))")
        print("円：\(Double(rateMoneyTextField.text!))")
        
        if Double(rateBallTextField.text!) == nil {
            printAlert(title: "エラー", message: "交換率に数値を入力してください")
            return
        }
        if Double(rateMoneyTextField.text!) == nil {
            printAlert(title: "エラー", message: "交換率に数値を入力してください")
            return
        }
        if Int(saveBallTextField.text!) == nil {
            printAlert(title: "エラー", message: "貯玉に数値を入力してください")
            return
        }
        let addHallName = String(hallNameTextField.text!)
        let addRateMoney = Double(rateMoneyTextField.text!)!
        let addRateBall = Double(rateBallTextField.text!)!
        let addSaveBall = Int(saveBallTextField.text!)!
        
        let result = realm.objects(HallTable.self).filter("name == %@", addHallName).first
        if result?.name == hallNameTextField.text {
            printAlert(title: "登録失敗", message: "既に登録されているホールです")
        }else{
            let addHall = HallTable(value: ["id": createNewId(), "name": addHallName, "rateBall": addRateBall, "rateMoney": addRateMoney, "save": addSaveBall])
            
            try! realm.write{
                realm.add(addHall)
                printAlert(title: "登録成功", message: "\(addHallName)\n\(addRateMoney)円/\(addRateBall)玉\n\(addSaveBall)玉")
                hallNameTextField.text = ""
                rateBallTextField.text = ""
                rateMoneyTextField.text = ""
            }
        }
        hallListTableView.reloadData()
        
    }
    
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(HallTable.self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
    
// MARK: - Alert
//アラート
    func printAlert(title: String, message: String){
        let alertController = UIAlertController(title: title,message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }


    private func actionSheet(indexPath: IndexPath) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        var flag = false
        let alert: UIAlertController = UIAlertController(title: "確認", message: "このホールで稼働したログも同時に削除されますが本当によろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{ [self]
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let targetHall = realm.objects(HallTable.self).filter("id == %@", hallList[indexPath.row].id)
            let targetLog = realm.objects(ResultTable.self).filter("hallID == %@", hallList[indexPath.row].id)
            do{
                try realm.write{
                    realm.delete(targetHall)
                    realm.delete(targetLog)
                }
            }catch {
                print("Error \(error)")
            }
            hallListTableView.reloadData()
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
}
