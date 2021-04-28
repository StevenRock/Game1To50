//
//  TabBarViewController.swift
//  EasyGoRecorder
//
//  Created by Steven Lin on 2020/5/14.
//  Copyright © 2020 yulinhu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        
        let transperentBlackColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)

            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            transperentBlackColor.setFill()
            UIRectFill(rect)

            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                tabBar.backgroundImage = image
            }

            UIGraphicsEndImageContext()
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
