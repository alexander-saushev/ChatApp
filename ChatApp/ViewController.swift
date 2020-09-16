//
//  ViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func logCalledMethodName(_ methodName: String) {
        #if DEBUG
        print(methodName)
        print("")
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logCalledMethodName(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logCalledMethodName(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        logCalledMethodName(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logCalledMethodName(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logCalledMethodName(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logCalledMethodName(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        logCalledMethodName(#function)
    }
    
}
