//
//  AnalysisCategoryViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/01.
//

import UIKit
import RealmSwift

class AnalysisCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var datePickerBegin: UIDatePicker!
    @IBOutlet weak var datePickerFin: UIDatePicker!
    @IBOutlet weak var analysisTableView: UITableView!
    @IBOutlet weak var sortKeyButton: UIButton!
    @IBOutlet weak var sortDescButton: UIButton!
    
    var sortKey = 0
    var sortDesc = true
    
    var resultPlay: Results<ResultTable>!
    var resultHall: Results<HallTable>!
    var dataArray = [DataResult]()
    var hitIndex = [Int]()
    var categoryDataArray = [DataResult]()
    var hallID = 0
    var machineID = 0
    
    var categoryNumber = Int()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if categoryNumber == 1{
            self.title = "ホール別"
        }else if categoryNumber == 2{
            self.title = "機種別"
        }
        
        //tableView
        self.analysisTableView.dataSource = self
        self.analysisTableView.delegate = self
        analysisTableView.register (UINib(nibName: "AnalysisCategoryTableViewCell", bundle: nil),forCellReuseIdentifier:"CategoryCell")
        
        //datePicker
        datePickerBegin.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePickerFin.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if SaveUserDefaluts().getStartDate() == nil{
            datePickerBegin.date = formatter.date(from: "2021/01/01")!
        }else{
            datePickerBegin.date = SaveUserDefaluts().getStartDate()
        }
        datePickerBegin.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerBegin.maximumDate = Date()
        datePickerFin.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerFin.maximumDate = Date()
        
        setData()
        sortKeyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sort()
        
        
       

        // Do any additional setup after loading the view.
    }
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = analysisTableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! AnalysisCategoryTableViewCell
        var cn = ""
        if categoryNumber == 1{
            cn = dataArray[indexPath.row].hall
        }else if categoryNumber == 2{
            cn = dataArray[indexPath.row].machineName
        }
                    
        cell.setLabel(categoryName: cn, data: dataArray[indexPath.row], categoryNumber: self.categoryNumber)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        if self.categoryNumber == 1{
            self.hallID = dataArray[indexPath.row].hallID
        }else if self.categoryNumber == 2{
            self.machineID = dataArray[indexPath.row].machineID
        }
        // 別の画面に遷移
        performSegue(withIdentifier: "ToCategoryDetailAnalysis", sender: nil)
    }
    
    
    //MARK: - DatePicker
    @objc func datePickerChanged(picker: UIDatePicker) {
        if picker == self.datePickerBegin{
            self.datePickerFin.minimumDate = self.datePickerBegin.date
            SaveUserDefaluts().setStartDate(date: self.datePickerBegin.date)
        }else if picker == self.datePickerFin{
            self.datePickerBegin.maximumDate = self.datePickerFin.date
        }
        setData()
        analysisTableView.reloadData()
    }
    
    func setData(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //Realm
        let realm = try! Realm()
        resultPlay = realm.objects(ResultTable.self).sorted(byKeyPath: "date")
        dataArray = [DataResult]()
        categoryDataArray = [DataResult]()
        for i in 0 ..< resultPlay.count{
            let resultDate = dateFromString(string: resultPlay[i].date, format: "yyyy/MM/dd")
            if resultDate >= datePickerBegin.date && resultDate <= datePickerFin.date{
                let data = DataResult()
                data.setResult(data: resultPlay[i])
                dataArray.append(data)
                categoryDataArray.append(data)
            }
        }
        
        
        if categoryNumber == 1{
            dataArray.sort{$0.hallID < $1.hallID}
        }else if categoryNumber == 2{
            dataArray.sort{$0.machineID < $1.machineID}
        }
        
        var i = 1
        while i < dataArray.count{
            if categoryNumber == 1{
                if dataArray[i].hallID == dataArray[i-1].hallID{
                    dataArray[i-1].bop += dataArray[i].bop
                    dataArray[i-1].work += dataArray[i].work
                    dataArray[i-1].start += dataArray[i].start
                    dataArray[i-1].investment += dataArray[i].investment
                    dataArray[i-1].defference += dataArray[i].defference
                    dataArray[i-1].inPOS += dataArray[i].inPOS
                    dataArray.remove(at: i)
                }else{
                    i += 1
                }
            }else if categoryNumber == 2{
                if dataArray[i].machineID == dataArray[i-1].machineID{
                    dataArray[i-1].bop += dataArray[i].bop
                    dataArray[i-1].work += dataArray[i].work
                    dataArray[i-1].start += dataArray[i].start
                    dataArray[i-1].investment += dataArray[i].investment
                    dataArray[i-1].defference += dataArray[i].defference
                    dataArray[i-1].inPOS += dataArray[i].inPOS
                    dataArray.remove(at: i)
                }else{
                    i += 1
                }
            }
        }
    }
    
    
    

    // MARK: - ActionSheet
    func showKeyActionSheet(){
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "ソートします", message:  "ソートキーを選んでください", preferredStyle:  UIAlertController.Style.actionSheet)
        // 確定ボタンの処理
        let confirmAction0: UIAlertAction = UIAlertAction(title: "収支順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 0
            self.sort()
            self.analysisTableView.reloadData()
            self.sortKeyButton.setTitle("収支順", for: .normal)
        })
        let confirmAction1: UIAlertAction = UIAlertAction(title: "仕事量順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 1
            self.sort()
            self.analysisTableView.reloadData()
            self.sortKeyButton.setTitle("仕事量順", for: .normal)
        })
        let confirmAction2: UIAlertAction = UIAlertAction(title: "総スタート順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 2
            self.sort()
            self.analysisTableView.reloadData()
            self.sortKeyButton.setTitle("総スタート順", for: .normal)
        })
        let confirmAction3: UIAlertAction = UIAlertAction(title: "損益額順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 3
            self.sort()
            self.analysisTableView.reloadData()
            self.sortKeyButton.setTitle("損益額順", for: .normal)
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction0)
        alert.addAction(confirmAction1)
        alert.addAction(confirmAction2)
        alert.addAction(confirmAction3)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    func showDescAction(){
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "ソートします", message:  "降順か昇順かを選んでください", preferredStyle:  UIAlertController.Style.actionSheet)
        // 確定ボタンの処理
        let confirmAction0: UIAlertAction = UIAlertAction(title: "降順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            //降順
            self.sortDesc = true
            self.sort()
            self.analysisTableView.reloadData()
            self.sortDescButton.setTitle("降順", for: .normal)
        })
        let confirmAction1: UIAlertAction = UIAlertAction(title: "昇順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            //昇順
            self.sortDesc = false
            self.sort()
            self.analysisTableView.reloadData()
            self.sortDescButton.setTitle("昇順", for: .normal)
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction0)
        alert.addAction(confirmAction1)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Format
    func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoryDetailViewController {
            // 遷移先のクラスのプロパティに値を代入する
            categoryDataArray = [DataResult]()
            for i in 0 ..< resultPlay.count{
                let resultDate = dateFromString(string: resultPlay[i].date, format: "yyyy/MM/dd")
                if resultDate >= datePickerBegin.date && resultDate <= datePickerFin.date{
                    let data = DataResult()
                    data.setResult(data: resultPlay[i])
                    categoryDataArray.append(data)
                }
            }
            vc.dataArray = categoryDataArray
            vc.categoryNumber = self.categoryNumber
            vc.hallID = self.hallID
            vc.machineID = self.machineID
        }

    }
    
    // MARK: - Sort
    func sort(){
        if sortKey == 0{
            if(sortDesc){
                dataArray.sort{$0.bop > $1.bop}
            }else{
                dataArray.sort{$0.bop < $1.bop}
            }
        }else if sortKey == 1{
            if(sortDesc){
                dataArray.sort{$0.work > $1.work}
            }else{
                dataArray.sort{$0.work < $1.work}
            }
        }else if sortKey == 2{
            if(sortDesc){
                dataArray.sort{$0.start > $1.start}
            }else{
                dataArray.sort{$0.start < $1.start}
            }
        }else if sortKey == 3{
            if(sortDesc){
                dataArray.sort{($0.bop - $0.work) > ($1.bop - $1.work)}
            }else{
                dataArray.sort{($0.bop - $0.work) < ($1.bop - $1.work)}
            }
        }
    }
    
    
    @IBAction func sortKeyButton(_ sender: Any) {
        showKeyActionSheet()
    }
    
    @IBAction func sortDescButton(_ sender: Any) {
        showDescAction()
    }
}
