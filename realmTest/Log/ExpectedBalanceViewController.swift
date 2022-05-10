
import UIKit
import RealmSwift

class ExpectedBalanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    @IBOutlet weak var rateHaveBallLabel: UILabel!
    var rateMoney = 0.0     //交換率（円）
    var rateBall = 0.0      //交換率（玉）
    var rateHaveBall = 0.0  //持ち玉比率
    var rateCycle = 0.0     //回転率
    var machineID = 0       //機種ID
    let realm = try! Realm()
    var start = [Int](repeating: 0, count: 3000/50)
    
    var bonusAmountArray = [Double]()
    var bonusProbabilityArray = [Double]()
    
    @IBOutlet weak var expectedBalanceTableView: UITableView!
    
    
    var machine: Results<MachineTable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        expectedBalanceTableView.register(UINib(nibName: "ExpectedBalanceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "expectedBalanceCell")
        exchangeRateLabel.text = "\(rateMoney)円/\(rateBall)玉"
        rateHaveBallLabel.text = String(rateHaveBall)
        //realmから機種情報取得
        machine = realm.objects(MachineTable.self).filter("id == %@", machineID)
        bonusAmountArray = machine[0].bonusAmount.components(separatedBy: "/").map{Double($0)!}
        bonusProbabilityArray = machine[0].totalProbability.components(separatedBy: "/").map{Double($0)!}
        
        expectedBalanceTableView.dataSource = self
        expectedBalanceTableView.delegate = self
        
        for i in 0 ..< start.count{
            if i == 0{
                start[i] = 50
            }else{
                start[i] = start[i-1] + 50
            }
        }
        
        print(rateHaveBall)
        
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return start.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expectedBalanceTableView.dequeueReusableCell(withIdentifier: "expectedBalanceCell", for: indexPath) as! ExpectedBalanceCellTableViewCell
        //cell.textLabel?.text = "\(self.machineList[indexPath.row]["name"] as! String)(1/\(self.machineList[indexPath.row]["probability"] as! String))"
        cell.setLeftLabel(value: start[indexPath.row])
        cell.setRightLabel(value: calcExpectedBalance(start: start[indexPath.row]))
        return cell
    }
    
    func calcExpectedBalance(start: Int) -> Int{
        var m = 0.0
        var g = 0.0
        for i in 0 ..< bonusAmountArray.count{
            m += Double(bonusAmountArray[i] / bonusProbabilityArray[i])
            g += Double(bonusAmountArray[i] / bonusProbabilityArray[i] * (rateMoney / rateBall))
        }
        m = (m  - Double(250.0 / rateCycle)) * Double(rateMoney / rateBall)
        g = g - (1000.0 / rateCycle)
        print("m",m)
        print("g",g)
        print("start",start)
        let r = (m * (rateHaveBall / 100.0) + g * (1.0 - (rateHaveBall / 100.0))) * Double(start)
        return Int(r)
    }
    
}
