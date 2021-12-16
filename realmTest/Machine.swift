//
//  Machine.swift
//  
//
//  Created by 東純己 on 2021/12/07.
//

import Foundation
class Machine{
    var id: Int!
    var name: String!
    var bonusName: [String]!
    var totalProbability: [Double]!
    var bonusAmount: [Double]!
    var bonusRate: [Double]!
    var probability: Double!
    var playTime: Int!
    var c: Int!
    
    func setMachine(info: [String: Any]){
        
        self.id = Int(info["id"] as! String) as! Int
        self.name = info["name"] as! String
        self.bonusName = (info["bonusName"] as! String).components(separatedBy: "/")
        var arr = (info["totalProbability"] as! String).components(separatedBy: "/")
        self.totalProbability = toDouble(arr: arr)
        arr = (info["bonusAmount"] as! String).components(separatedBy: "/")
        self.bonusAmount = toDouble(arr: arr)
        arr = (info["bonusRate"] as! String).components(separatedBy: "/")
        self.bonusRate = toDouble(arr: arr)
        
        self.probability = Double(info["probability"] as! String) as! Double
        self.playTime = Int(info["playTime"] as! String) as! Int
        self.c = Int(info["c"] as! String) as! Int

        
    }
    
    func toInt(arr: [String]) -> [Int]{
        var intArray = [Int]()
        for i in 0 ..< arr.count{
            intArray.append(Int(arr[i])!)
        }
        return intArray
    }
    
    func toDouble(arr: [String]) -> [Double]{
        var doubleArray = [Double]()
        for i in 0 ..< arr.count{
            doubleArray.append(Double(arr[i])!)
        }
        return doubleArray
    }
}
