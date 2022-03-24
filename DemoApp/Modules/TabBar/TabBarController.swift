//
//  TabBarController.swift
//  DemoApp
//
//  Created by Aline Arely Ordonez Garcia on 17/04/21.
//

import UIKit

typealias AppTabs = (search: UIViewController, category: UIViewController, favorite: UIViewController)

class TabBarController: UITabBarController, TabBarPresenterToViewProtocol {
    
    
    var presenter: TabBarViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBar.backgroundColor = UIColor(red: 90/255, green: 112/255, blue: 145/255, alpha: 1)
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        self.tabBar.barTintColor = UIColor(red: 90/255, green: 112/255, blue: 145/255, alpha: 1)
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
