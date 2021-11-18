//
//  PlayLogViewController.swift
//  PachinkoLog
//

import UIKit
import FSCalendar
import RealmSwift



class PlayLogViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate{

    
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var dailyLogTable: UITableView!
    @IBOutlet weak var resultBOPLabel: UILabel!
    @IBOutlet weak var resultWorkLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    
    
    let realm = try! Realm()
    var logList: Results<ResultTable>!
    var machineList: Results<MachineTable>!
    var hallList: Results<HallTable>!
    var event:Results<ResultTable>!
    var da = [String]()
    var test = 0
    var logCalc = LogCalc()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //カレンダー
        fsCalendar.locale = Locale(identifier: "ja")
        self.fsCalendar.firstWeekday = 2
        fsCalendar.appearance.titleWeekendColor = .red
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        self.fsCalendar.reloadData()
        
        //realm
        logList = realm.objects(ResultTable.self)
        hallList = realm.objects(HallTable.self)
        machineList = realm.objects(MachineTable.self)
        calendarCurrentPageDidChange(fsCalendar)
        let date = Date()
        event = logList.filter("date == %@", dateFormat(date: Date()))
        
        //tableview

        self.dailyLogTable.register (UINib(nibName: "PlayLogCellTableViewCell", bundle: nil),forCellReuseIdentifier:"DailyLogCell")
        self.dailyLogTable.dataSource = self
        self.dailyLogTable.delegate = self
        self.dailyLogTable.estimatedRowHeight = 110
        self.dailyLogTable.rowHeight = UITableView.automaticDimension

        
    }
    // 完全に全ての読み込みが完了時に実行
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.subviews.forEach {
            if $0.tag == 1{
                $0.removeFromSuperview()
            }
            if $0.tag == 2{
                $0.removeFromSuperview()
            }
        }
        let printDate = dateFormat(date: date)
        let dayResult = realm.objects(ResultTable.self).filter("date = %@", printDate)
        var bop = 0
        var work = 0
        if dayResult.count > 0{
            for i in 0 ..< dayResult.count{
                bop += dayResult[i].playResult
                work += dayResult[i].workResult
            }
            let bopLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.height * 0.48, width: 40, height: 20))
            let workLabel = UILabel(frame: CGRect(x: 10, y: cell.frame.height * 0.77, width: 40, height: 20))
            bopLabel.tag = 1
            workLabel.tag = 2
            bopLabel.font = UIFont.systemFont(ofSize: 10)
            workLabel.font = UIFont.systemFont(ofSize: 10)
            bopLabel.text = numberFormat(num: bop)
            workLabel.text = numberFormat(num: work)
            bopLabel.textAlignment = NSTextAlignment.right
            workLabel.textAlignment = NSTextAlignment.right
            bopLabel.adjustsFontSizeToFitWidth = true
            workLabel.adjustsFontSizeToFitWidth = true
            
            if bop > 0 {
                bopLabel.textColor = UIColor.blue
            }else if bop < 0{
                bopLabel.textColor = UIColor.red
            }
            if work > 0 {
                workLabel.textColor = UIColor.blue
            }else if work < 0{
                workLabel.textColor = UIColor.red
            }
            bopLabel.layer.cornerRadius = cell.bounds.width/2
            cell.addSubview(bopLabel)
            cell.addSubview(workLabel)
        }
        

    }

    //MARK:- calendar
    // 日付タップされたとき
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        event = logList.filter("date == %@", dateFormat(date: date))
        dailyLogTable.reloadData()
        self.fsCalendar.reloadData()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let values = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year], from: self.fsCalendar.currentPage)
        let month = String(format: "%02d", values.month!)       // -> 0001
        let searchText = String(values.year!) + "/" + month
        let calc = logList.filter("date BEGINSWITH[c] %@", "\(searchText)").sorted(byKeyPath: "date", ascending: true)
        var totalPlayResult = 0
        var totalWorkResult = 0
        for i in 0 ..< calc.count {
            totalPlayResult += calc[i].playResult
            totalWorkResult += calc[i].workResult
        }
        resultBOPLabel.text = "\(logCalc.intFormat(num: totalPlayResult))円"
        if totalPlayResult > 0{
            resultBOPLabel.textColor = .blue
        }else if totalPlayResult < 0{
            resultBOPLabel.textColor = .red
        }else{
            resultBOPLabel.textColor = .black
        }
        resultWorkLabel.text = "\(logCalc.intFormat(num: totalWorkResult))円"
        if totalWorkResult > 0{
            resultWorkLabel.textColor = .blue
        }else if totalWorkResult < 0{
            resultWorkLabel.textColor = .red
        }else{
            resultWorkLabel.textColor = .black
        }
        
        //月間稼働日数と月間勝率
        if calc.count != 0{
            var dayArr = [""]
            var totalArr = [0]
            var day = ""
            dayArr[0] = calc[0].date
            day = calc[0].date
            totalArr[0] = calc[0].playResult
        
            var total = calc[0].playResult
            for i in 1 ..< calc.count{
                if day == calc[i].date{
                    totalArr[totalArr.count - 1] += calc[i].playResult
                }else{
                    totalArr.append(calc[i].playResult)
                    dayArr.append(calc[i].date)
                    day = calc[i].date
                }
            }
            print(dayArr)
            print(totalArr)
            dayCountLabel.text = "\(dayArr.count)日"
            var win = 0
            for i in 0 ..< totalArr.count{
                if totalArr[i] > 0{
                    win += 1
                }
            }
            winRateLabel.text = "\(round(Double(win) / Double(dayArr.count) * 10000) / 100)%"
        }else{
            dayCountLabel.text = "0日"
            winRateLabel.text = "0.0%"
        }

    }

    //MARK:- tableView
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
        
    }
    //cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyLogCell", for: indexPath) as! PlayLogCellTableViewCell
        cell.textLabel?.numberOfLines = 0
        let hallName = hallList.filter("id == %@", event[indexPath.row].hallID)
        cell.hallNameLabel.text? = hallName[0].name
        let machineName = machineList.filter("id == %@", event[indexPath.row].machineID)
        cell.setMachineName(name: machineName[0].name)
        cell.setResultBOP(num: event[indexPath.row].playResult)
        cell.setResultWork(num: event[indexPath.row].workResult)
        return cell
    }
    //セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            actionSheet(indexPath: indexPath)
        }
    }

     //Cellがタップされたとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logCalc.setDate(str: event[indexPath.row].date)
        logCalc.setHallID(id: event[indexPath.row].hallID)
        logCalc.setMachineID(id: event[indexPath.row].machineID)
        logCalc.setPlayResult(number: event[indexPath.row].playResult)
        logCalc.setWorkResult(number: event[indexPath.row].workResult)
        logCalc.setStart(number: event[indexPath.row].start)
        logCalc.setBonusCount(array: event[indexPath.row].bonusCount)
        logCalc.setBonusAmount(array: event[indexPath.row].bonusAmount)
        logCalc.setInvestment(number: event[indexPath.row].investment)
        logCalc.setRental(number: event[indexPath.row].rental)
        logCalc.setRateMoney(number: event[indexPath.row].rateMoney)
        logCalc.setRateBall(number: event[indexPath.row].rateBall)
        logCalc.setInPos(number: event[indexPath.row].inPOS)
        logCalc.setMemo(memo: "")
        logCalc.setNumber(number: event[indexPath.row].number)

        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        performSegue(withIdentifier: "ToDetailLog", sender: nil)
    }
    
    //segue実行前に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailLogViewController {
            // 遷移先のクラスのプロパティに値を代入する
            
            vc.calc = self.logCalc
        }

    }
 

    //MARK:- format
    //日付のフォーマット指定
   func dateFormat(date: Date) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "YYYY/MM/dd"
       let text = dateFormatter.string(from: date)
       return text
   }
    
    //数値をカンマ区切りにする
    func numberFormat(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
                
        let cmNum = NSNumber(value: num)
        let cmNumString = formatter.string(from: cmNum)!
        return cmNumString
    }
    
    private func actionSheet(indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(title: "確認", message: "本当に削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{ [self]
            // 削除処理
            (action: UIAlertAction!) -> Void in
            try! realm.write{
                realm.delete(event[indexPath.row])
            }
            dailyLogTable.reloadData()
            self.fsCalendar.reloadData()
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

}
