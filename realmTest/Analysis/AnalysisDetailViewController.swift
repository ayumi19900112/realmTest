//
//  AnalysisDetailViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/11/24.
//

import UIKit
import RealmSwift
import Charts
import SwiftUI

class AnalysisDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var analysisTabelView: UITableView!
    
    @IBOutlet weak var datePickerStart: UIDatePicker!   //開始日
    @IBOutlet weak var datePickerFin: UIDatePicker!     //終了日
    
    @IBOutlet weak var chartView: UIView!
    
    
    var categoryNumber = 0
    var categoryList: [String]!
    var result: Results<ResultTable>!
    var dr = [DataResult()]
    
    var hitIndex = [Int]()
    
    var chartBOP = [Int]()          //収支
    var chartWork = [Int]()         //仕事量
    var chartWrite = [[Int]]()      //表示
    static var chartDate = [String]()      //日付
    
    var dateArray = [Date]()
    var bopArray = [Int]()
    var workArray = [Int]()
    
    

     
    override func viewDidLoad() {
        super.viewDidLoad()
        //DatePickerSetting
        datePickerStart.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePickerFin.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        datePickerStart.date = formatter.date(from: "2021/01/01")!
        datePickerStart.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerStart.maximumDate = Date()
        datePickerFin.minimumDate = formatter.date(from: "2021/01/01")!
        datePickerFin.maximumDate = Date()
        
        //tableView
        analysisTabelView.delegate = self
        analysisTabelView.dataSource = self
        analysisTabelView.register (UINib(nibName: "AnalysisTableViewCell", bundle: nil),forCellReuseIdentifier:"AnalysisCell")
        self.analysisTabelView.estimatedRowHeight = 110
        self.analysisTabelView.rowHeight = UITableView.automaticDimension
        
        
        setData()
        

        if hitIndex.count != 0{
            getChart()
        }
        
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cellの内容を設定する。
        if hitIndex.count != 0{
            let cell = analysisTabelView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as! AnalysisTableViewCell
            cell.setDate(result: result, idx: hitIndex)
            return cell
        }else{
            let cell = analysisTabelView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath)
            cell.textLabel!.text = "稼働データがありません"
            cell.textLabel?.textAlignment = .center
            return cell
        }

    }
    
    //Cellがタップされたとき
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       // セルの選択を解除
       tableView.deselectRow(at: indexPath, animated: true)
       // 別の画面に遷移
       performSegue(withIdentifier: "ToTotalAnalysis", sender: nil)
   }

    
    //MARK: - DatePicker
    @objc func datePickerChanged(picker: UIDatePicker) {
        if picker == self.datePickerStart{
            self.datePickerFin.minimumDate = self.datePickerStart.date
        }else if picker == self.datePickerFin{
            self.datePickerStart.maximumDate = self.datePickerFin.date
        }
        setData()
        analysisTabelView.reloadData()
        getChart()
    }
    
    func setData(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //Realm
        let realm = try! Realm()
        result = realm.objects(ResultTable.self).sorted(byKeyPath: "date")
        hitIndex = [Int]()
        for i in 0 ..< result.count{
            //let resultDate = dateFromString(string: result[i].date, format: "yyyy/MM/dd")
            let resultDate = dateFromString(string: result[i].date, format: "yyyy/MM/dd")
            
            
            if resultDate >= datePickerStart.date && resultDate <= datePickerFin.date{
                let dres = DataResult()
                dres.setResult(data: result[i])
                dr.append(dres)
                hitIndex.append(i)
            }
        }

    }
    

    // MARK: - iosCharts
    func getChart(){
        
        //self.chartView = UIView()
        let subviews = chartView.subviews
        for chartView in subviews {
            chartView.removeFromSuperview()
        }
        chartBOP.removeAll()
        chartWork.removeAll()
        chartWrite.removeAll()
        let chartItem = ["収支", "仕事量"]
        var totalBOP = 0
        var totalWork = 0
        AnalysisDetailViewController.chartDate.removeAll()
        for i in 0 ..< hitIndex.count{
            totalBOP += result[hitIndex[i]].playResult
            totalWork += result[hitIndex[i]].workResult
            chartBOP.append(totalBOP)
            chartWork.append(totalWork)
            AnalysisDetailViewController.chartDate.append(result[hitIndex[i]].date)
        }
        
        print("bop", chartBOP)
        print("work", chartWork)
        var i = 1
        while i < chartBOP.count{
            if AnalysisDetailViewController.chartDate[i] == AnalysisDetailViewController.chartDate[i-1]{
                chartBOP[i-1] = chartBOP[i]
                chartWork[i-1] = chartWork[i]
                AnalysisDetailViewController.chartDate.remove(at: i)
                chartBOP.remove(at: i)
                chartWork.remove(at: i)
            }else{
                i += 1
            }
        }
        chartWrite.append(chartBOP)
        chartWrite.append(chartWork)
        
        
        let rect = CGRect(x:0, y: 0, width: self.chartView.frame.width, height: self.chartView.frame.height)

        let chartView = LineChartView(frame: rect)
        chartView.noDataText = "稼働データがありません"
        chartView.drawGridBackgroundEnabled = false

        var entries = [[ChartDataEntry]]()
        var dataSets = [LineChartDataSet]()
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false

        
        for i in 0 ..< chartWrite.count{
            //空の配列を追加する
            entries.append([ChartDataEntry]())
            for (j, d) in chartWrite[i].enumerated() {
                entries[i].append(ChartDataEntry(x: Double(j), y: Double(d) ))
            }
            if i >= 2 {
                break
            }
            let dataSet = LineChartDataSet(entries: entries[i], label: "\(chartItem[i])")
            if i == 0{
                dataSet.colors = ([UIColor.blue])
            }else{
                dataSet.colors = [UIColor.green]
            }
            dataSet.drawCirclesEnabled = false
            
            dataSets.append(dataSet)
             
        }
         

        //chartView.data = LineChartData(dataSet: dataSet)　→ LineChartData(dataSets: dataSets as! [IChartDataSet])
        chartView.data = LineChartData(dataSets: dataSets as! [IChartDataSet])
        
        
        //labelCountはChartDataEntryと同じ数だけ入れます。
        chartView.xAxis.labelCount = chartBOP.count
        //granularityは1.0で固定
        chartView.xAxis.granularity = 1.0
        //ここが今回のメイン。下記のclassを生成。chartView.xAxisはエラーにもある通りget-onlyです。　valueFormatterにChartFormatterを割り当てます。
        let formatter = ChartFormatter()
        chartView.xAxis.valueFormatter = formatter

        
        

        self.chartView.addSubview(chartView)
        
        
    }
    
    class ChartFormatter: NSObject, IAxisValueFormatter {
            //よくある例がどれも１２ヶ月なので干支にしてみました。
            let xAxisValues = chartDate

            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                //granularityを１.０、labelCountを１２にしているおかげで引数のvalueは1.0, 2.0, 3.0・・・１１.０となります。
                if chartDate.count == 1{
                    if value == -1.0{
                        return ""
                    }else if value == 1.0{
                        return ""
                    }
                    return chartDate[0]
                    
                }else{
                    return xAxisValues[Int(value)]
                }
                
            }

        }
    

    
    func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AnalysisTotalViewController {
            // 遷移先のクラスのプロパティに値を代入する
            
            vc.result = self.result
            vc.idx = self.hitIndex
        }

    }
}
