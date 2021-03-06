//
//  ViewController.swift
//  My_Framework_Test
//
//  Created by Ara Hakobyan on 23/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import AHProvider

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        useLetsbuild()
        useGuardian()
    }
    
    let provider = AHProvider<TestAPI>()
    
    func useLetsbuild() {
        provider.requestDecodable(.letsbuild) { (response: AHResult<User>) in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let result):
                print(result)
            }
        }

        provider.request(.letsbuild) { (response: AHResult<[String: Any]>) in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let result):
                print(result)
            }
        }
    }
    
    func useGuardian() {
        provider.requestDecodable(.guardian(pageSize: "2")) { (response: AHResult<NewsFeed>) in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let result):
                print(result)
            }
        }
    }
    
}

