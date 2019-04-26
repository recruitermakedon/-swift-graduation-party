//
//  ViewControllerItem3.swift
//  Gradient
//
//  Created by Александр Македон on 4/11/19.
//  Copyright © 2019 Алек Мак. All rights reserved.
//

import UIKit

class ViewControllerItem2: CustomViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color1 = UIColor(red: 20 / 254, green: 9 / 245, blue: 49 / 235, alpha: 1.0).cgColor
        let color2 = UIColor(red:  156  / 255, green: 17 / 255, blue: 71 / 255, alpha: 1.0).cgColor
        let color3 = UIColor(red:  55  / 255, green: 10 / 255, blue: 97 / 255, alpha: 0.5).cgColor
        let color4 = UIColor(red:  120  / 255, green: 39 / 255, blue: 105 / 255, alpha: 0.8).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.startPoint = CGPoint(x:  0.2, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 0.9)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // Do any additional setup after loading the view.
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
