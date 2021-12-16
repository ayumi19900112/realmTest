//
//  Calc.swift
//  PachinkoLog
//


import Foundation

class Calc{
    var investment: Int!        //現金投資
    var firstStart: Int!        //打ち始めスタート
    var currentStart: Int!      //現在スタート
    var firstPos: Int!          //打ち始め持ち玉
    var currentPos: Int!        //現在持ち玉
    var rateMoney: Double!      //交換率（円）
    var rateBall: Double!       //交換率（玉）
    var rental: Int!            //貸し玉
    var number: Int!
    var bonusNameList: [String]!    //大当たり種類
    var bonusAmountList: [Double]!  //大当たり出玉
    var bonusCountList: [Int]!      //大当たり回数
    var bonusTotalList: [Double]!   //トータル確率
    var bonusLogList: [String]!     //大当たりログ
    var startLogList: [Int]!        //スタートログ

    
    func setInvestment(number: Int) {
        self.investment = number
    }
    
    func setFirstStart(number: Int) {
        self.firstStart = number
    }
    
    func setFirstPos(number: Int) {
        self.firstPos = number
    }
    
    func setRateMoney(number: Double) {
        self.rateMoney = number
    }
    
    func setRateBall(number: Double) {
        self.rateBall = number
    }
    
    func setSetRental(number: Int) {
        self.rental = number
    }
    
    func setCurrentStart(number: Int) {
        self.currentStart = number
    }
    
    func setCurrentPos(number: Int) {
        self.currentPos = number
    }
    
    func setNumber(number: Int) {
        self.number = number
    }
    
    func setBonusNameList(array: [String]) {
        self.bonusNameList = array
    }
    
    func setBonusLogList(array: [String]) {
        self.bonusLogList = array
    }
    
    func setStartLogList(array: [Int]) {
        self.startLogList = array
    }
    
    func setBonusAmountList(array: [Double]) {
        self.bonusAmountList = array
    }
    
    func setBonusCountList(array: [Int]) {
        self.bonusCountList = array
    }
    
    func setBonusTotalList(array: [Double]) {
        self.bonusTotalList = array
    }
    
    func getBonusNameList() -> [String] {
        return self.bonusNameList
    }
    
    func getRateMoney() -> Double {
        return self.rateMoney
    }
    
    func getRateBall() -> Double{
        return self.rateBall
    }
    
    func getInvestment() -> Int{
        return self.investment
    }
    
    func getFirstPos() -> Int{
        return self.firstPos
    }
    
    func getCurrentPos() -> Int{
        return self.currentPos
    }
    
    func getRental() -> Int{
        return self.rental
    }
    
    func getNumber() -> Int{
        return self.number
    }
    
    func getBonusAmountList() -> [Double]{
        return self.bonusAmountList
    }
    
    func getBonusTotalList() -> [Double]{
        return self.bonusTotalList
    }
    
    
    func getStart() -> Int{
        var start = (-1) * self.firstStart
        for i in 1 ..< self.startLogList.count {
            if self.bonusLogList[i-1] == "開始"{
                start += self.startLogList[i]
            }else if self.bonusLogList[i-1] == "電サポ抜け" && self.bonusLogList[i-1] != "小当R"{      //update
                start += self.startLogList[i] - self.startLogList[i-1]
            }
        }
        return start
    }
    
    func calcBonusCount() {
        bonusCountList = [Int](repeating: 0, count: self.bonusNameList.count)
        
        for i in 1 ..< self.bonusNameList.count{
            self.bonusCountList[i] = 0
            for j in 0 ..< self.bonusLogList.count{
                if self.bonusLogList[j] == self.bonusNameList[i]{
                    bonusCountList[i] += 1
                }
            }
        }
        self.bonusCountList[0] = support()
        //update
        if self.bonusNameList.last == "小当R"{
            self.bonusCountList[self.bonusCountList.count - 1] = getSKR()
        }
    }
    //update
    func getSKR() -> Int{
        var skr = 0
        for i in 1 ..< self.bonusLogList.count{
            if self.bonusLogList[i-1] == "小当R" && self.bonusLogList[i] != ""{
                skr += self.startLogList[i] - self.startLogList[i-1]
            }
        }
        return skr
    }
    //総出玉
    func getBonusAmount(bonusCount: [Int], bonusAmount: [Double]) -> Int {
        var amount = 0.0
        for i in 0 ..< self.bonusCountList.count{
            amount += Double(bonusCount[i]) * bonusAmount[i]
        }
        return Int(amount)
    }
    //収支
    func getBOP() -> Int{
        let firstPrize = floor(Double(self.firstPos) / self.rateBall) * self.rateMoney
        let finishPrize = floor(Double(self.currentPos) / self.rateBall) * self.rateMoney
        return Int(finishPrize) - Int(firstPrize) - self.investment
    }
    //仕事量
    func getWork() -> Int{
        let start = Double(getStart())
        var imaginaryBonus = 0.0
        var realBonus = 0.0
        for i in 0 ..< bonusNameList.count {
            imaginaryBonus += (Double(start) / self.bonusTotalList[i]) * self.bonusAmountList[i]
            realBonus += Double(self.bonusCountList[i]) * bonusAmountList[i]
        }
        return self.getBOP() - Int((floor((realBonus - imaginaryBonus) / self.rateBall)) * self.rateMoney)

    }
    //250玉ベース
    func getTurnOver() -> Double {
        let asMoney = Double(self.investment) / 1000.0 * Double(self.rental)

        let asBall = self.getBonusAmount(bonusCount: bonusCountList, bonusAmount:bonusAmountList) - self.currentPos + self.firstPos
        let collect = (asMoney + Double(asBall)) / 250.0
        return round(Double(self.start(startList: startLogList, bonusList: bonusLogList)) / collect * 100) / 100
    }
    //投資玉÷250
    func getInPos() -> Int {
        let asMoney = Double(self.investment) / 1000.0 * Double(self.rental)
        let asBall = self.getBonusAmount(bonusCount: bonusCountList, bonusAmount:bonusAmountList) - self.currentPos + self.firstPos
        let collect = (asMoney + Double(asBall)) / 250.0
        return Int(collect * 250)
        
        
    }
    //差玉
    func getDifference() -> Int {
        let dif = currentPos - firstPos - (investment * rental / 1000)
        return dif
    }
    //大当たり回数
    func getBonusCountList() -> [Int] {
        return self.bonusCountList
    }
    
    //持ち玉比率
    func getHaveBallRate(money: Int) -> Double{
        let asMoney = Double(self.investment) / 1000.0 * Double(self.rental)
        var rate = (1.0 - (asMoney / Double(getInPos()))) * 100.0
        if rate < 0.0{
            rate = 0.0
        }
        return round(rate * 100) / 100
        
    }
    //MARK:- format
    func formatDoubleNumber(num: Double) -> String {
        return removeZero(String(num))
    }
    
    func removeZero(_ str: String) -> String {
        // 整数部分のの文字列にだけ処理をかけるので小数部分をもつものを持たないもので処理を分岐
        if let d: String.Index = str.firstIndex(of: ".") {
            // 小数部分が存在する場合の処理
            let s: String.Index = str.startIndex
            let e: String.Index = str.endIndex

            // 整数部分を取り出す
            let tmpIntStr: String = String(str[s ..< d])
            let intStr: String = String(Int(tmpIntStr) ?? 0)

            // 小数部分を取り出す
            let deciDouble: Double = Double(String(str[d ..< e])) ?? 0.0
            let tmpStr: String = String(String(deciDouble).dropFirst())
            let deciStr: String = tmpStr == ".0" ? "" : tmpStr


            return intStr + deciStr

        } else {
            // 整数部分に対して変換処理をする
            return String(Int(str) ?? 0)
        }
    }
 
    //数値をカンマ区切りにする
    func intFormat(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
                
        let cmNum = NSNumber(value: num)
        let cmNumString = formatter.string(from: cmNum)!
        return cmNumString
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- その他
    
    func start(startList: [Int], bonusList: [String]) -> Int{
        //start計算
        var start = 0
        var support = 0
        //var statement = true
        start -= startList[0]
        for i in 1 ..< startList.count {
            if bonusList[i-1] == "開始"{
                start += startList[i]
            }else if bonusList[i-1] == "電サポ抜け"{
                start += startList[i] - startList[i-1]
            }else{
                support += startList[i]
            }
        }
        return start
    }
    
    //電サポ回数計算
    
    func support() -> Int{
        //start計算
        var support = 0
        for i in 1 ..< startLogList.count {
            if bonusLogList[i-1] == "開始"{
            }else if bonusLogList[i-1] == "電サポ抜け"{
            }else if bonusLogList[i-1] != "小当R" && bonusLogList[i-1] != "遊タイム突入"{
                support += startLogList[i]
            }else if bonusLogList[i-1] == "遊タイム突入"{
                support += startLogList[i] - startLogList[i-1]
            }
 
        }
        return support
    }

    
}
