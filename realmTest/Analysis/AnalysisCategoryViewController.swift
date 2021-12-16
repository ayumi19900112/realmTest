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
        datePickerBegin.date = formatter.date(from: "2021/01/01")!
        datePickerBegin.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerBegin.maximumDate = Date()
        datePickerFin.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerFin.maximumDate = Date()
        
        setData()

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
        
        //categoryDataArray = dataArray
        print("1.categoryDataArray ")
        categoryDataArray.forEach{
            print("収支　", $0.bop)
            print("スタート", $0.start)
        }
        print("1.dataArray ")
        dataArray.forEach{
            print("収支　", $0.bop)
            print("スタート", $0.start)
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
        print("2.categoryDataArray ")
        categoryDataArray.forEach{
            print("収支　", $0.bop)
            print("スタート", $0.start)
        }
        print("2.dataArray ")
        dataArray.forEach{
            print("収支　", $0.bop)
            print("スタート", $0.start)
        }
        
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
}
