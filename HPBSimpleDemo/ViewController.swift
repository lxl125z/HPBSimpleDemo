//
//  ViewController.swift
//  HPBSimpleDemo
//
//  Created by 刘晓亮 on 2019/1/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func authorizedLoginClick(_ sender: UIButton) {
       HPBWalletApi.registerAppURLSchemes("HPBSimpleDemo")
        let reqModel = HPBWalletBaseReq()
        HPBWalletApi.sendReq(reqModel)
    }
    

}

