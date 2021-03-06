//
//  LogCalc.swift
//  PachinkoLog
//


import Foundation
import RealmSwift

class LogCalc{
    var date: String!
    var hallID: Int!
    var machineID: Int!
    var playResult: Int!
    var workResult: Int!
    var start: Int!
    var bonusCount: [Int]!
    var bonusAmount: [Double]!
    var investment: Int!
    var rental: Int!
    var rateMoney: Double!
    var rateBall: Double!
    var inPos: Int!
    var memo: String!
    var number: Int!
    var skrRate = "0.0%"
    
//MARK:- set
    func setDate(str: String){
        self.date = str
    }
    func setHallID(id: Int){
        self.hallID = id
    }
    func setMachineID(id: Int){
        self.machineID = id
    }
    func setPlayResult(number: Int){
        self.playResult = number
    }
    func setWorkResult(number: Int){
        self.workResult = number
    }
    func setStart(number: Int){
        self.start = number
    }
    func setBonusCount(array: String){
        let arr:[String] = array.components(separatedBy: "/")
        var count = [Int](repeating: 0, count: arr.count)
        for i in 0 ..< arr.count{
            count[i] = Int(arr[i])!
        }
        self.bonusCount = count
    }
    func setBonusAmount(array: String){
        let arr:[String] = array.components(separatedBy: "/")
        var amount = [Double](repeating: 0.0, count: arr.count)
        for i in 0 ..< arr.count{
            amount[i] = Double(arr[i])!
        }
        self.bonusAmount = amount
    }
    func setInvestment(number: Int){
        self.investment = number
    }
    func setRental(number: Int){
        self.rental = number
    }
    func setRateMoney(number: Double){
        self.rateMoney = number
    }
    func setRateBall(number: Double){
        self.rateBall = number
    }
    func setInPos(number: Int){
        self.inPos = number
    }
    func setMemo(memo: String){
        self.memo = memo
    }
    func setNumber(number: Int){
        self.number = number
    }
    
    //MARK:- get
    func getMachineID() -> Int{
        return self.machineID
    }
    func getDate() -> String{
        let arr:[String] = self.date.components(separatedBy: "/")
        return "\(arr[0])???\(arr[1])???\(arr[2])???"
    }
    func getHallName() -> String {
        let realm = try! Realm()
        let result = realm.objects(HallTable.self).filter("id == %@", self.hallID!).first
        return result!.name
    }
    func getMachineName() -> String {
        let realm = try! Realm()
        let result = realm.objects(MachineTable.self).filter("id == %@", self.machineID!).first
        return result!.name
    }
    func getNumber() -> String{
        return "\(self.number!)??????"
    }
    func getRate() -> String {
        return "\(formatDoubleNumber(num: self.rateMoney))???/\(formatDoubleNumber(num: self.rateBall))???"
    }
    func getInvestment() -> String {
        let numStr = intFormat(num: self.investment)
        return "\(numStr)???"
    }
    func getPlayResult() -> String {
        let numStr = intFormat(num: self.playResult)
        return "\(numStr)???"
    }
    func getWorkResult() -> String {
        let numStr = intFormat(num: self.workResult)
        return "\(numStr)???"
    }
    func getLuckMoney() -> String {
        let numStr = intFormat(num: self.playResult - self.workResult)
        return "\(numStr)???"
    }
    func getDifference() -> String {
        var total = 0.0
        for i in 0 ..< self.bonusAmount.count{
            total += Double(self.bonusCount[i]) * bonusAmount[i]
        }
        var strNum = formatDoubleNumber(num: round(total - Double(self.inPos)))
        strNum = intFormat(num: Int(strNum)!)
        return "\(strNum)???"
    }
    func getRateBall() -> String {
        let asMoney = Double(self.investment) / 1000.0 * Double(self.rental)
        let rate = (1.0 - (asMoney / Double(self.inPos))) * 100.0
        return "\(round(rate * 100) / 100)%"
    }
    func getTotalStart() -> String {
        let numStr = intFormat(num: self.bonusCount[0] + self.start)
        return "\(numStr)??????"
    }
    func getStart() -> String {
        let numStr = intFormat(num: self.start)
        return "\(numStr)??????"
    }
    func getSupportStart() -> String {
        let numStr = intFormat(num: self.bonusCount[0])
        return "\(numStr)??????"
    }
    func getRateSupport() -> String {
        let rate = Double(self.bonusCount[0]) / Double(self.start)
        return "\(round(rate * 10000) / 100)%"
    }
    func getBonusCount() -> [String] {
        var count = [String](repeating: "", count: self.bonusCount.count)
        for i in 0 ..< self.bonusCount.count{
            count[i] = "\(self.bonusCount[i])???"
        }
        return count
    }
    
    func getBonusAmount() -> [String]{
        var amount = [String](repeating: "", count: self.bonusAmount.count)
        for i in 0 ..< self.bonusAmount.count{
            amount[i] = "\(bonusAmount[i])???"
        }
        return amount
    }
    
    func getTurnOver() -> String{
        var to = Double(self.start) / (Double(self.inPos) / 250.0)
        to = round(to * 100) / 100
        return "\(to)??????"
    }
    
    func getSKR() -> String{
        let realm = try! Realm()
        let result = realm.objects(MachineTable.self).filter("id == %@", self.machineID).first
        let bn = result?.bonusName.components(separatedBy: "/")
        if bn?.last == "??????R"{
            var rate = Double(bonusCount.last!) / Double(start)
            rate = round(rate * 10000) / 100
            skrRate = "\(rate)%"
            return "\(bonusCount.last!)???"
        }else{
            return "0???"
        }
    }
    
    func getRateSKR() -> String{
        return skrRate
    }
    
    
    //MARK:- Format
    func formatDoubleNumber(num: Double) -> String {
        return removeZero(String(num))
    }
    
    func removeZero(_ str: String) -> String {

        // ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????

        if let d: String.Index = str.firstIndex(of: ".") {
            // ??????????????????????????????????????????

            let s: String.Index = str.startIndex
            let e: String.Index = str.endIndex

            // ???????????????????????????

            let tmpIntStr: String = String(str[s ..< d])
            let intStr: String = String(Int(tmpIntStr) ?? 0)

            // ?????????????????????????????????????????????(???)

            // ???????????????????????????
            let deciDouble: Double = Double(String(str[d ..< e])) ?? 0.0
            let tmpStr: String = String(String(deciDouble).dropFirst())
            let deciStr: String = tmpStr == ".0" ? "" : tmpStr


            return intStr + deciStr

        } else {
            // ????????????????????????????????????

            // ?????????????????????????????????????????????(???)
            return String(Int(str) ?? 0)
        }
    }
    
    //????????????????????????????????????
    func intFormat(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
                
        let cmNum = NSNumber(value: num)
        let cmNumString = formatter.string(from: cmNum)!
        return cmNumString
    }
    
    func doubleFormat(num: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
                
        let cmNum = NSNumber(value: num)
        let cmNumString = formatter.string(from: cmNum)!
        return cmNumString
    }
}
