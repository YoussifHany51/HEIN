//
//  TabBarController.swift
//  HEIN
//
//  Created by Youssif Hany on 03/09/2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let tabBar = self.tabBar
        let homeItem = tabBar.items![0]
        homeItem.title = "Home"
        homeItem.image = UIImage(named: "home_icon")

        let searchItem = tabBar.items![1]
        searchItem.title = "Search"
        searchItem.image = UIImage(named: "search_icon")

        let profileItem = tabBar.items![2]
        profileItem.title = "Profile"
        profileItem.image = UIImage(named: "profile_icon")
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
