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
    var machineName = String()
    var number = Int()
    var bop = Int()
    var work = Int()
    var start = Int()
    var bonusName = [String]()
    var bonusCount = [Int]()
    var bonusAmount = [Double]()
    var defference = Int()
    
    
    func setResult(data: ResultTable){
        var hall: Results<HallTable>!
        let realm = try! Realm()
        self.date = StringToDate(dateValue: data.date, format: "yyyy/MM/dd")
        hall = realm.objects(HallTable.self).filter("id == %@", data.hallID)
        self.hall = hall[0].name
        var machine: Results<MachineTable>!
        machine = realm.objects(MachineTable.self).filter("id == %@", data.machineID)
        self.machineName = machine[0].name
        self.number = data.number
        self.bop = data.playResult
        self.work = data.workResult
        self.start = data.start
        self.bonusName = machine[0].bonusName.components(separatedBy: "/")
        self.bonusCount = data.bonusCount.components(separatedBy: "/").map{ Int($0)!}
        self.bonusAmount = data.bonusAmount.components(separatedBy: "/").map{ Double($0)!}
        self.defference = data.defference
        
    }
    
    func StringToDate(dateValue: String, format: String) -> Date {
       let dateFormatter = DateFormatter()
       dateFormatter.calendar = Calendar(identifier: .gregorian)
       dateFormatter.dateFormat = format
       return dateFormatter.date(from: dateValue) ?? Date()
   }
}
