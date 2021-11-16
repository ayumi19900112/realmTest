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
    
    var realm = try! Realm()
    var machineNameList: Results<MachineTable>!
    var indexNum = Int()
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("realmのパス：\(Realm.Configuration.defaultConfiguration.fileURL!)")        //Realmの保存場所
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
        
        
        
        //CSV読み込み
        let machine = MachineTable()
        let results = realm.objects(MachineTable.self)
        try! realm.write {
            realm.delete(results)
        }
        let csvArray = machine.csvLoad(filename: "machineName")
        for csvStr in csvArray {
            let value = machine.saveCsvValue(csvStr: csvStr)
            let realm = try! Realm()
            
            do {
                try! realm.write {
                    realm.add(value)
                }
            } catch {
                print("えらー")
            }
        }
    }
    

    
    // MARK:- TableViewの処理
    //tableViewに表示する行数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.machineNameList.count
    }
    
    //tableViewに表示するセルの値を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = machineNameTableView.dequeueReusableCell(withIdentifier: "MachineNameCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let name = self.machineNameList[indexPath.row]
        cell.textLabel?.text = "\(name.name)(1/\(name.probability))"
        return cell
    }

    // MARK:- segueの処理
    // セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = self.machineNameTableView.indexPathForSelectedRow
        //indexNum = idx!.row
        
        machineNameTableView.deselectRow(at: index!, animated: true)
        if segue.identifier == "toConditionsInput" {
            let nextView = segue.destination as! ConditionsInput
            nextView.machineID = Int(exactly: self.machineNameList[index!.row].id)!
        }
    }
    
    // MARK:- searchBarの処理
    //  検索バーに入力があったら呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if machineSearchBar.text == "" {
            machineNameList = realm.objects(MachineTable.self).sorted(byKeyPath: "id", ascending: false)
        } else {
            machineNameList = realm.objects(MachineTable.self).filter("name LIKE '*\(machineSearchBar.text!)*'").sorted(byKeyPath: "id", ascending: false)
        }
        machineNameTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.machineSearchBar.endEditing(true)
    }
    
    //MARK:- 完了ボタン
    //完了ボタンタップ時に、キーボードを閉じる
    @objc
    func doneButtonTaped(sender: UIButton) {
        machineSearchBar.endEditing(true)
    }
    
}



