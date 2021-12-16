//
//  MachineTable.swift
//  realmTest
//


import Foundation
import SwiftUI
import RealmSwift

class MachineTable: Object {
    //機種ID
    @objc dynamic var id : Int = 0
    //機種名
    @objc dynamic var name : String = ""
    //当たり種類
    @objc dynamic var bonusName: String = ""
    //トータル確率
    @objc dynamic var totalProbability: String = ""
    //当たり出玉
    @objc dynamic var bonusAmount: String = ""
    //当たり比率
    @objc dynamic var bonusRate: String = ""
    //通常時確率
    @objc dynamic var probability: Double = 0.0
    //遊タイム有無
    @objc dynamic var playTime: Int = 0
    //初当たり出玉
    @objc dynamic var firstPlay: Double = 0.0
    //C時短　ありなら１　なしなら０
    @objc dynamic var c: Int = 0
    //検索ワード
    @objc dynamic var searchWord = ""
    
    //プライマリーキーの設定
    /*
    override static func primaryKey() -> String? {
        return "id"
    }
 */
    
    func csvLoad(filename:String)->[String]{
        //csvファイルを格納するための配列を作成
        var csvArray:[String] = []
        //csvファイルの読み込み
        let csvBundle = Bundle.main.path(forResource: "machineName", ofType: "csv")
        
        do {
            //csvBundleのパスを読み込み、UTF8に文字コード変換して、NSStringに格納
            let csvData = try String(contentsOfFile: csvBundle!,
                                     encoding: String.Encoding.utf8)
            //改行コードが\n一つになるようにします
            var lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            lineChange = lineChange.replacingOccurrences(of: "\n\n", with: "\n")
            //"\n"の改行コードで区切って、配列csvArrayに格納する
            csvArray = lineChange.components(separatedBy: "\n")
            //csvArray.removeLast()
            csvArray.removeFirst()
        }
        catch {
            print("エラー")
        }
        return csvArray
    }
    
    func saveCsvValue(csvStr:String) -> MachineTable {
        // CSVなのでカンマでセパレート
        let splitStr = csvStr.components(separatedBy: ",")

        let result = MachineTable(value: ["id": Int(splitStr[0])!
                                          , "name": splitStr[1]
                                          , "bonusName": splitStr[2]
                                          , "totalProbability": splitStr[3]
                                          , "bonusAmount": splitStr[4]
                                          , "bonusRate": splitStr[5]
                                          , "probability": Double(splitStr[6])!
                                          , "playTime": Int(splitStr[7])!
                                          ,"firstPlay": Double(splitStr[8])!
                                          , "c": Int(splitStr[9])!
                                          ,"searchWord": splitStr[10]])
        
 
        return result
        
    }
}

