//
//  UD.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/02/08.
//

import Foundation
class UD{
    let userDefaults = UserDefaults.standard
    var firstPos = 0
    var firstStart = 0
    var logStart = [0]
    var logBonus = [""]
    var bonusCount = [0]
    var investment = 0
    var currentStart = 0
    var currentPos = 0
    var machineID = 0
    var number = 0
    var hallID = 0
    var rateMoney = 0.0
    var rateBall = 0.0
    var rental = 0
    
    
    func setData(){
        userDefaults.set(machineID, forKey: "machineID")
        userDefaults.set(number, forKey: "number")
        userDefaults.set(hallID, forKey: "hallID")
        userDefaults.set(firstPos, forKey: "firstPos")
        userDefaults.set(firstStart, forKey: "firstStart")
        userDefaults.set(logStart, forKey: "logStart")
        userDefaults.set(logBonus, forKey: "logBonus")
        userDefaults.set(bonusCount, forKey: "bonusCount")
        userDefaults.set(investment, forKey: "investment")
        print("UDclassInvestment", self.investment)
        userDefaults.set(currentStart, forKey: "currentStart")
        userDefaults.set(currentPos, forKey: "currentPos")
        userDefaults.set(rateMoney, forKey: "rateMoney")
        userDefaults.set(rateBall, forKey: "rateBall")
        userDefaults.set(rental, forKey: "rental")
    }
    
    func getFirstPOS() -> Int{
        return userDefaults.integer(forKey: "firstPos")
    }
    func getFirstStart() -> Int{
        return userDefaults.integer(forKey: "firstStart")
    }
    func getLogStart() -> [Int]{
        return (userDefaults.array(forKey: "logStart") as? [Int])!
    }
    func getLogBonus() -> [String]{
        return userDefaults.array(forKey: "logBonus") as! [String]
    }
    func getBonusCount() -> [Int]{
        return (userDefaults.array(forKey: "bonusCount") as? [Int]) ??  [0]
    }
    func getInvestment() -> Int{
        return userDefaults.integer(forKey: "investment")
    }
    func getCurrentStart() -> Int{
        return userDefaults.integer(forKey: "currentStart")
    }
    func getCurrentPOS() -> Int{
        return userDefaults.integer(forKey: "currentPos")
    }
    func getHallID() -> Int{
        return userDefaults.integer(forKey: "halID")
    }
    func getMachineID() -> Int{
        return userDefaults.integer(forKey: "machineID")
    }
    func getNumber() -> Int{
        return userDefaults.integer(forKey: "number")
    }
    func getRateMoney() -> Double{
        return userDefaults.double(forKey: "rateMoney")
    }
    func getRateBall() -> Double{
        return userDefaults.double(forKey: "rateBall")
    }
    func getRental() -> Int{
        return userDefaults.integer(forKey: "rental")
    }
        
    
    func allRemove(){
        userDefaults.removeObject(forKey: "firstPos")
        userDefaults.removeObject(forKey: "logStart")
        userDefaults.removeObject(forKey: "logBonus")
        userDefaults.removeObject(forKey: "investment")
        userDefaults.removeObject(forKey: "currentStart")
        userDefaults.removeObject(forKey: "currentPos")
        userDefaults.removeObject(forKey: "number")
        userDefaults.removeObject(forKey: "machineID")
        userDefaults.removeObject(forKey: "hallID")
        userDefaults.removeObject(forKey: "rateMoney")
        userDefaults.removeObject(forKey: "rateBall")
        userDefaults.removeObject(forKey: "rental")
    }
}
