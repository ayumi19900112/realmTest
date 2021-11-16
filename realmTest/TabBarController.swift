//
//  TabBarController.swift
//  PachinkoLog
//


import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func tabBarController(_ tabBarController: UITabBarController,didSelect viewController: UIViewController){

        if viewController.children.count > 0 {
            for vc in viewController.children {
                if String(reflecting: type(of : vc)) == "PachinkoLog.CurrentLogViewController" {
                    flag = false
                }else if String(reflecting: type(of: vc)) == "PachinkoLog.ConditionsInput" {
                    flag = false
                }
            }
        } else {
            flag = true
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.children.count > 0 {
            for vc in viewController.children {
                if String(reflecting: type(of : vc)) == "PachinkoLog.CurrentLogViewController" {
                    return flag
                }
            }
        }

        return true
    }
    




}
