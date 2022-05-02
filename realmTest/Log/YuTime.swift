//
//  YuTime.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/12.
//

import Foundation

class YuTime{
    var machineID = 0
    var yuCount = 0
    var yuValue = 0
    var bonusNum = [Double]()
    var yutimeNum = [Double]()
    var bonusAmount = [Double]()
    var bonusProbability = 0.0
    var rateHaveBall = 0.0
    var haveBall = 0
    var rateMoney = 0.0
    var rateBall = 0.0
    var currentStart = 0
    var turnOver = 0.0
    var rental = 0
    var toYT = 0
    var densapo = 0

    var ytList:[[String: Any]] = []
    
    var semaphore : DispatchSemaphore!
    
    func getData(){
            semaphore = DispatchSemaphore(value: 0)

            // Httpリクエストの生成
            var request = URLRequest(url: URL(string: "http://pachinkolog.com/yutimejson.php")!)
            request.httpMethod = "GET"

            // HTTPリクエスト実行
            URLSession.shared.dataTask(with: request, completionHandler: requestCompleteHandler).resume()

            // requestCompleteHandler内でsemaphore.signal()が呼び出されるまで待機する
            semaphore.wait()
            print("request completed")
        }

        func requestCompleteHandler(data:Data?,res:URLResponse?,err:Error?){
            do  {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                
                self.ytList = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
            }catch {
                print(error)
            }
            semaphore.signal()
        }


    
    func calcYuValue() -> Bool{
        var flag = false
        if toYT < 0{
            toYT = 0
        }
        if ytList.count > 0 && (yuCount + densapo) > currentStart{
            for i in 0 ..< ytList.count{
                if Int(ytList[i]["id"] as! String)! == self.machineID{
                    bonusNum = (ytList[i]["bonus"] as! String).components(separatedBy: "/").map{Double($0)!}
                    yutimeNum = (ytList[i]["yutime"] as! String).components(separatedBy: "/").map{Double($0)!}
                    flag = true
                }
            }
        }
        if flag{
            let rate = self.rateMoney / self.rateBall
            var notYT = 0.0
            var yt = 0.0
            for i in 0 ..< bonusNum.count{
                notYT += bonusNum[i] * bonusAmount[i]
                yt += yutimeNum[i] * bonusAmount[i]
            }
            if(toYT <= 0){
                yuValue = Int(yt / Double(rateBall) * Double(rateMoney))
                return flag
            }
            var tenjoutoutaturitu = pow(1.0 - (1.0 / bonusProbability), Double(toYT))
            var tenjoukomiooatarikakuritu = 1.0/(1.0/bonusProbability/(1.0 - Double(tenjoutoutaturitu)))
            var heikintoushitamasuu = tenjoukomiooatarikakuritu / turnOver * 250.0
            var heikinkaishuutamasuu = (Double(tenjoutoutaturitu) * yt) + ((1.0 - Double(tenjoutoutaturitu)) * notYT)

            rateHaveBall = (tenjoukomiooatarikakuritu - (tenjoukomiooatarikakuritu - (Double(haveBall) / 250.0 * turnOver))) / tenjoukomiooatarikakuritu
            if rateHaveBall > 1.0{
                rateHaveBall = 1.0
            }
            
            var motitanka = ((heikinkaishuutamasuu / tenjoukomiooatarikakuritu) - (250.0 / turnOver)) * rate
            var genkintanka = (heikinkaishuutamasuu / tenjoukomiooatarikakuritu * rate) - (1000.0 * (250.0 / Double(rental)) / turnOver)
            yuValue = Int((motitanka * rateHaveBall + genkintanka * (1.0 - rateHaveBall)) * tenjoukomiooatarikakuritu)
            
            
            print(heikintoushitamasuu)
        }
        return flag
    }
    
    func aveInvestBall()  -> Int{
        
        
        return 0
    }
    
}
