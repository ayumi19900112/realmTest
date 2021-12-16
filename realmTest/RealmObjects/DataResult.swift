//
//  DataResult.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/11/28.
//

import Foundation
import RealmSwift

class DataResult{
    var date = Date()
    var hall = String()
    var hallID = Int()
    var machineName = String()
    var machineID = Int()
    var number = Int()
    var bop = Int()
    var work = Int()
    var investment = Int()
    var inPOS = Int()
    var start = Int()
    var bonusName = [String]()
    var bonusCount = [Int]()
    var bonusAmount = [Double]()
    var defference = Int()
    var rental = Int()
    
    
    func setResult(data: ResultTable){
        var hall: Results<HallTable>!
        let realm = try! Realm()
        self.date = StringToDate(dateValue: data.date, format: "yyyy/MM/dd")
        hall = realm.objects(HallTable.self).filter("id == %@", data.hallID)
        self.hall = hall[0].name
        self.hallID = data.hallID
        var machine: Results<MachineTable>!
        machine = realm.objects(MachineTable.self).filter("id == %@", data.machineID)
        self.machineName = machine[0].name
        self.machineID = data.machineID
        self.number = data.number
        self.bop = data.playResult
        self.work = data.workResult
        self.investment = data.investment
        self.inPOS = data.inPOS
        self.start = data.start
        self.bonusName = machine[0].bonusName.components(separatedBy: "/")
        self.bonusCount = data.bonusCount.components(separatedBy: "/").map{ Int($0)!}
        self.bonusAmount = data.bonusAmount.components(separatedBy: "/").map{ Double($0)!}
        self.defference = data.defference
        self.rental = data.rental
        
    }
    
    func StringToDate(dateValue: String, format: String) -> Date {
       let dateFormatter = DateFormatter()
       dateFormatter.calendar = Calendar(identifier: .gregorian)
       dateFormatter.dateFormat = format
       return dateFormatter.date(from: dateValue) ?? Date()
   }
}
