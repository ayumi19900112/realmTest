//
//  CategoryDetailViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/02.
//

import UIKit
import SwiftUI

class CategoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var dataArray = [DataResult]()
    var categoryNumber = 0
    var machineID = 0
    var hallID = 0
    var outData = [DataResult]()
    var sortKey = 0
    var sortDesc = true
    
    @IBOutlet weak var categoryDetailTableView: UITableView!
    
    @IBOutlet weak var sortKeyButton: UIButton!
    @IBOutlet weak var sortDescButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView
        categoryDetailTableView.dataSource = self
        categoryDetailTableView.delegate = self
        categoryDetailTableView.register (UINib(nibName: "CategoryDetailTableViewCell", bundle: nil),forCellReuseIdentifier:"CategoryDetailCell")
        self.categoryDetailTableView.estimatedRowHeight = 110
        self.categoryDetailTableView.rowHeight = UITableView.automaticDimension
        
        dataArray.sort{$0.date > $1.date}
        if categoryNumber == 1{
            for i in 0 ..< dataArray.count{
                if self.hallID == dataArray[i].hallID{
                    outData.append(dataArray[i])
                }
            }
        }else if categoryNumber == 2{
            for i in 0 ..< dataArray.count{
                if machineID == dataArray[i].machineID{
                    outData.append(dataArray[i])
                }
            }
        }
        self.sortKeyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //sort()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryDetailTableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell", for: indexPath) as! CategoryDetailTableViewCell
        cell.setLabel(data: outData[indexPath.row], categoryNumber: self.categoryNumber)
        return cell
    }
    
    // MARK: - ActionSheet
    func showKeyActionSheet(){
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "ソートします", message:  "ソートキーを選んでください", preferredStyle:  UIAlertController.Style.actionSheet)
        // 確定ボタンの処理
        let confirmAction5: UIAlertAction = UIAlertAction(title: "日付順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 5
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("日付順", for: .normal)
        })
        let confirmAction0: UIAlertAction = UIAlertAction(title: "収支順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 0
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("収支順", for: .normal)
        })
        let confirmAction1: UIAlertAction = UIAlertAction(title: "仕事量順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 1
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("仕事量順", for: .normal)
        })
        let confirmAction2: UIAlertAction = UIAlertAction(title: "スタート順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 2
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("スタート順", for: .normal)
        })
        let confirmAction3: UIAlertAction = UIAlertAction(title: "損益額順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 3
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("損益額順", for: .normal)
        })
        let confirmAction4: UIAlertAction = UIAlertAction(title: "回転率順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.sortKey = 4
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortKeyButton.setTitle("回転率順", for: .normal)
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction5)
        alert.addAction(confirmAction0)
        alert.addAction(confirmAction1)
        alert.addAction(confirmAction2)
        alert.addAction(confirmAction3)
        alert.addAction(confirmAction4)
        

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    func showDescAction(){
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "ソートします", message:  "降順か昇順かを選んでください", preferredStyle:  UIAlertController.Style.actionSheet)
        // 確定ボタンの処理
        let confirmAction0: UIAlertAction = UIAlertAction(title: "降順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            //降順
            self.sortDesc = true
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortDescButton.setTitle("降順", for: .normal)
        })
        let confirmAction1: UIAlertAction = UIAlertAction(title: "昇順", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            //昇順
            self.sortDesc = false
            self.sort()
            self.categoryDetailTableView.reloadData()
            self.sortDescButton.setTitle("昇順", for: .normal)
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction0)
        alert.addAction(confirmAction1)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Sort
    func sort(){
        if sortKey == 0{
            if(sortDesc){
                outData.sort{$0.bop > $1.bop}
            }else{
                outData.sort{$0.bop < $1.bop}
            }
        }else if sortKey == 1{
            if(sortDesc){
                outData.sort{$0.work > $1.work}
            }else{
                outData.sort{$0.work < $1.work}
            }
        }else if sortKey == 2{
            if(sortDesc){
                outData.sort{$0.start > $1.start}
            }else{
                outData.sort{$0.start < $1.start}
            }
        }else if sortKey == 3{
            if(sortDesc){
                outData.sort{($0.bop - $0.work) > ($1.bop - $1.work)}
            }else{
                outData.sort{($0.bop - $0.work) < ($1.bop - $1.work)}
            }
        }else if sortKey == 4{
            if(sortDesc){
                outData.sort{(Double($0.start) / Double($0.inPOS)) > (Double($1.start) / Double($1.inPOS))}
            }else{
                outData.sort{(Double($0.start) / Double($0.inPOS)) < (Double($1.start) / Double($1.inPOS))}
            }
        }else if sortKey == 5{
            if(sortDesc){
                outData.sort{$0.date > $1.date}
            }else{
                outData.sort{$0.date < $1.date}
            }
        }
    }
    
    @IBAction func sortKeyButtonAction(_ sender: Any) {
        showKeyActionSheet()
    }
    
    @IBAction func sortDescButtonAction(_ sender: Any) {
        showDescAction()
    }
    

}
