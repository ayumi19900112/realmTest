//
//  HallTable.swift
//  PachinkoLog
//


import Foundation
import SwiftUI
import RealmSwift

class HallTable: Object {
    //機種ID
    @objc dynamic var id : Int = 0
    //機種名
    @objc dynamic var name : String = ""
    //交換率
    @objc dynamic var rateBall : Double = 0.0
    @objc dynamic var rateMoney : Double = 0.0
    //貯玉
    @objc dynamic var save: Int = 0
    
    
    //プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
