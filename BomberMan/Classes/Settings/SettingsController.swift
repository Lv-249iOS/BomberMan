//
//  SettingsController.swift
//  BomberMan
//
//  Created by Kristina Del Rio Albrechet on 9/22/17.
//  Copyright © 2017 Lv-249 iOS. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    let settingModel = SettingsModel.shared
    var currentPage: Int?
    
    @IBOutlet weak var choosingPlayMode: UIScrollView!
    @IBOutlet weak var heroChoosingPickerView: UIPickerView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         fillchoosingPlayModeView()
        setContentOffsetForImageScroll(with: view.frame.width)
    }
    func fillchoosingPlayModeView() {
        //print(choosingPlayMode.subviews.count)
        for i in 0 ..< settingModel.gameModeArray.count {
            let rect = CGRect(x: view.bounds.width * CGFloat(i),
                              y: 0,
                              width: view.bounds.width,
                              height: choosingPlayMode.bounds.height)
            
            let imageView = UIImageView(frame: rect)
            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
            
            imageView.image = settingModel.gameModeArray[i]
            
            choosingPlayMode.contentSize.width = view.bounds.width * CGFloat(i + 1)
            choosingPlayMode.addSubview(imageView)
            
        }
    }
    func setContentOffsetForImageScroll(with width: CGFloat) {
        let pointOffset = CGPoint(x: width * CGFloat(currentPage ?? settingModel.currentPage), y: 0)
        choosingPlayMode.setContentOffset(pointOffset, animated: true)
    }
    
}
