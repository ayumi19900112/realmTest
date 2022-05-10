//
//  SaveUserDefaults.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/05/10.
//

import Foundation
class SaveUserDefaluts{
    func setStartDate(date: Date){
        UserDefaults.standard.set(date, forKey: "startDate")
        print("date---------", date)
    }
    
    func getStartDate() -> Date{
        return UserDefaults.standard.object(forKey: "startDate")! as! Date
    }
}
