//
//  InsertData.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/01/07.
//

import Foundation
import Alamofire

class DeleteData{
    var date = ""
    var machineID = 0
    var hallName = ""
    var number = 0
    var start = 0
    var inPOS = 0
    var defference = 0
    
    let url = "https://pachinkolog.com/api/delete.php"
    func deleteData(){
        
        AF.request(url, method: .post, parameters:["date":getFormattedDateString(dateString: date)!,
                                                   "machineID":machineID,
                                                   "hallName": hallName,
                                                   "number": number,
                                                   "start": start,
                                                   "inPOS": inPOS,
                                                   "defference": defference
                                                  ]).responseData(completionHandler: { response in
            
            
        })
        
    }
    
    func getFormattedDateString(dateString: String, from fromFormat: String = "yyyy/MM/dd", to toFormat: String = "yyyy-MM-dd") -> String? {
            let dateFormatter = DateFormatter()
            // DateFormatterのロケールやその他指定は各自変えて下さい
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = fromFormat
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: date)
        }
}
