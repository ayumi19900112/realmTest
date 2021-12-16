//
//  CategoryDetailViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/02.
//

import UIKit

class CategoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var dataArray = [DataResult]()
    var categoryNumber = 0
    var machineID = 0
    var hallID = 0
    var outData = [DataResult]()
    
    @IBOutlet weak var categoryDetailTableView: UITableView!
    
    
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
        
        dataArray.forEach{
            print("収支", $0.bop)
        }
        

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
