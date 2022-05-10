//
//  ViewController.swift
//  realmTest
//
//  Created on 2021/09/10.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var machineNameTableView: UITableView!
    @IBOutlet weak var machineSearchBar: UISearchBar!
    @IBOutlet weak var dataCountLabel: UILabel!
    
    var realm = try! Realm()
    var machineNameList: Results<MachineTable>!
    var indexNum = Int()
    var machine = Machine()
    
    var articles:[[String: Any]] = []
    var machineList:[[String: Any]] = []{
        didSet{
            machineNameTableView.reloadData()
        }
    }
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("realmパス：\(Realm.Configuration.defaultConfiguration.fileURL!)")        //Realmの保存場所
        self.machineNameTableView.delegate = self
        self.machineNameTableView.dataSource = self
        machineSearchBar.delegate = self
        self.machineNameList = realm.objects(MachineTable.self).sorted(byKeyPath: "id", ascending: false)
        
        //完了ボタン
        //キーボードに完了のツールバーを作成
        let doneToolbar = UIToolbar()
        doneToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButtonTaped))
        doneToolbar.items = [spacer, doneButton]
        machineSearchBar.inputAccessoryView = doneToolbar
        
        getMachineData()
        
        print("カウント", self.machineList.count)
        
        for i in 0 ..< machineList.count{
            print("i = ", i)
            print(self.machineList[i]["name"])
        }
        //NotificationCenterを定義
        let notificationCenter = NotificationCenter.default
/*
        //observerを追加
        notificationCenter.addObserver(
            self,
            selector: #selector(checkLog),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
*/
        

        
        
         
    }
    override func viewWillAppear(_ animated: Bool) {
        getMachineData()
        
    }

    
    // MARK: - TableViewの処理
    //tableViewに表示する行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataCountLabel.text = "\(self.machineList.count)件表示"
        return self.machineList.count
    }
    
    //tableViewに表示するセルの値を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = machineNameTableView.dequeueReusableCell(withIdentifier: "MachineNameCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let name = self.machineList[indexPath.row]["name"]
        cell.textLabel?.text = "\(self.machineList[indexPath.row]["name"] as! String)(1/\(self.machineList[indexPath.row]["probability"] as! String))"
        return cell
    }

    // MARK: - segueの処理
    // セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = self.machineNameTableView.indexPathForSelectedRow
        self.machineSearchBar.text = ""
        machineNameTableView.deselectRow(at: index!, animated: true)
        self.machine.setMachine(info: machineList[index!.row])
        var result = realm.objects(MachineTable.self).filter("id == %@", self.machine.id)

        if result.count == 0{
            let machineObject: MachineTable = MachineTable(value: ["id": machine.id,
                                                                   "name": machine.name,
                                                                   "bonusName": self.machineList[index!.row]["bonusName"] as! String,
                                                                   "totalProbability": self.machineList[index!.row]["totalProbability"] as! String,
                                                                   "bonusAmount": self.machineList[index!.row]["bonusAmount"] as! String,
                                                                   "bonusRate": self.machineList[index!.row]["bonusRate"] as! String,
                                                                   "probability": Double(self.machineList[index!.row]["probability"] as! String)!,
                                                                   "playTime": Int(self.machineList[index!.row]["playTime"] as! String)!,
                                                                   "firstPlay": Double(self.machineList[index!.row]["firstPlay"] as! String)!,
                                                                   "c": Int(self.machineList[index!.row]["c"] as! String)!,
                                                                   "searchWord": self.machineList[index!.row]["searchWord"] as! String])
            try! realm.write{
                realm.add(machineObject)
            }
        }else{
            if result[0].totalProbability != self.machineList[index!.row]["totalProbability"] as! String{
                try! realm.write{
                    result.first?.totalProbability = self.machineList[index!.row]["totalProbability"] as! String
                }
            }
            if result.first?.name != machine.name{
                try! realm.write{
                    result.first?.name = machine.name
                }
            }
            if result.first?.bonusName != self.machineList[index!.row]["bonusName"] as! String{
                try! realm.write{
                    result.first?.bonusName = self.machineList[index!.row]["bonusName"] as! String
                }
            }
            if result.first?.bonusAmount != self.machineList[index!.row]["bonusAmount"] as! String{
                try! realm.write{
                    result.first?.bonusAmount = self.machineList[index!.row]["bonusAmount"] as! String
                }
            }
            if result.first?.bonusRate != self.machineList[index!.row]["bonusRate"] as! String{
                try! realm.write{
                    result.first?.bonusRate = self.machineList[index!.row]["bonusRate"] as! String
                }
            }
            if result.first?.playTime != machine.playTime{
                try! realm.write{
                    result.first?.playTime = machine.playTime
                }
            }
            if result.first?.c != machine.c{
                try! realm.write{
                    result.first?.c = machine.c
                }
            }
            if result.first?.probability != machine.probability{
                try! realm.write{
                    result.first?.probability = machine.probability
                }
            }
        }
        
        
        
        
        if segue.identifier == "toConditionsInput" {
            
            let nextView = segue.destination as! ConditionsInput
            //nextView.machineID = Int(exactly: self.machineNameList[index!.row].id)!
            nextView.machineID = machine.id
        }
    }
    
    // MARK: - searchBarの処理
    //  検索バーに入力があったら呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        search()
    }
         
    
    func search(){
        var word = machineSearchBar.text!
        word = word.applyingTransform(.hiraganaToKatakana, reverse: true)!      //ひらがなに変換
        word = word.applyingTransform(.fullwidthToHalfwidth, reverse: false)!   //半角にへんかん
        word = word.lowercased()            //小文字に変換
        self.machineList = [[String: Any]]()
        if machineSearchBar.text == "" {
            //machineNameList = realm.objects(MachineTable.self).sorted(byKeyPath: "id", ascending: false)
            self.machineList = self.articles
        } else {
            //machineNameList = realm.objects(MachineTable.self).filter("name LIKE '*\(word)*' OR searchWord LIKE '*\(word)*'").sorted(byKeyPath: "id", ascending: false)
            for i in 0 ..< articles.count{
                let name = articles[i]["name"] as! String
                let searchWord = articles[i]["searchWord"] as! String
                if name.contains(word.lowercased()){
                    self.machineList.append(self.articles[i])
                }else if searchWord.contains(word.lowercased()){
                    self.machineList.append(self.articles[i])
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.machineSearchBar.endEditing(true)
    }
    
    //MARK: - JSON
    func getMachineData(){
        let url: URL = URL(string: "http://pachinkolog.com/json.php")!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            do  {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                //DispatchQueue.main.async() { () -> Void in
                let articles = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
                DispatchQueue.main.async() { () -> Void in
                    self.articles = articles
                    self.machineList = articles
                    self.search()
                }
            }catch {
                print(error)
            }
        })
        task.resume()
    }
    
    //MARK: - 完了ボタン
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        machineSearchBar.endEditing(true)
    }
    
/*
    @objc func checkLog(){
        let UD = UD()
        print("投資金額：", UD.getInvestment())
    }
 */
    
    func loadData() -> CurrentLogViewController! {
        guard let data = UserDefaults.standard.data(forKey: "data") else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CurrentLogViewController
    }
    
}
