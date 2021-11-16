//
//  LogTable.swift
//  PachinkoLog

import Foundation
import RealmSwift


class ResultTable: Object {
    //日付
    @objc dynamic var date : String = ""
    //ホールID
    @objc dynamic var hallID : Int = 0
    //機種ID
    @objc dynamic var machineID : Int = 0
    //台番号
    @objc dynamic var number: Int = 0
    //収支
    @objc dynamic var playResult : Int = 0
    //仕事量
    @objc dynamic var workResult : Int = 0
    //スタート
    @objc dynamic var start : Int = 0
    
    //大当たり回数
    @objc dynamic var bonusCount: String = ""
    //大当たり出玉
    @objc dynamic var bonusAmount: String = ""
    //投資
    @objc dynamic var investment: Int = 0
    //貸し玉
    @objc dynamic var rental: Int = 0
    //交換率（金額）
    @objc dynamic var rateMoney: Double = 0.0
    //交換率（玉数）
    @objc dynamic var rateBall: Double = 0.0
    //使用玉数
    @objc dynamic var inPOS: Int = 0
 
    @objc dynamic var memo: String = ""

}
