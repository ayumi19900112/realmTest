//
//  InsertData.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/01/07.
//

import Foundation
import Alamofire

class InsertData{
    var calc: Calc!
    let url = "https://pachinkolog.com/api/record.php"
    //let url = "https://webhook.site/10fcf546-b0e8-47a2-9ef1-730ee3009881?"
    func insertData(hallName: String, machineID: Int){
        /// DateFomatterクラスのインスタンス生成
        let dateFormatter = DateFormatter()
         
        /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
         
        /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "yyyy-MM-dd"
         
        let date = dateFormatter.string(from: Date())
        print("date", date)
        let number = calc.getNumber()
        let bop = calc.getBOP()
        let work = calc.getWork()
        let start = calc.getStart()
        let bonusCount = calc.getBonusCountList().map{String($0)}.joined(separator: "/")
        let bonusAmount = calc.getBonusAmountList().map{String($0)}.joined(separator: "/")
        let investment = calc.getInvestment()
        let rateMoney = calc.rateMoney
        let rateBall = calc.rateBall
        let inPOS = calc.getInPos()
        let defference = calc.getDifference()
        print("defference", defference)
        
        AF.request(url, method: .post, parameters:["date":date,
                                                   "machineID":machineID,
                                                   "hallName": hallName,
                                                   "number": number,
                                                   "bop": bop,
                                                   "work": work,
                                                   "start": start,
                                                   "bonusCount": bonusCount,
                                                   "bonusAmount": bonusAmount,
                                                   "investment": investment,
                                                   "rateMoney": rateMoney,
                                                   "rateBall": rateBall,
                                                   "inPOS": inPOS,
                                                   "defference": defference
                                                  ]).responseData(completionHandler: { response in
            
            
        })
        
    }
    
    
}
