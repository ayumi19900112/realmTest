//
//  FirestoreExtention.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/05/10.
//

import Foundation
import FirebaseFirestore
class FirestoreExtention{
//MARK:プレミアム会員に申し込んだ時
    //ProductID 商品ID
    //Expired 期間
    //items 製品名
    //completion クロージャ
   static func PremiumSubscription(ProductID:String,Expired:Date,items:String,completion: @escaping (Bool)->()){
       let uid = UUID().uuidString      //uid USERID
//        print("items : ",items)
       let updateReceipt = [
           "Uid":uid,
           "Receipt":items,
           "ProductID":ProductID,
           "Created_At":Timestamp(),
           "Expired":Expired,
           "Updated_At":Timestamp()
       ] as [String : Any]
       
       Firestore.firestore().collection("Receipt").document(uid).updateData(updateReceipt) { (Error) in
           if let Error = Error {
               print("Error",Error)
               completion(false)
               return
           }
           completion(true)
       }
   }
}
