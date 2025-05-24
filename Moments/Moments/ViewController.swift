//
//  ViewController.swift
//  Moments
//
//  Created by wjw on 2024/4/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        // 忽略安全区域，填充整个屏幕
        view.insetsLayoutMarginsFromSafeArea = true
        additionalSafeAreaInsets = UIEdgeInsets(top: -view.safeAreaInsets.top, left: 0, bottom: -view.safeAreaInsets.bottom, right: 0)
        print("视图尺寸:", view.frame.size)

        configUI()
    }
    
    private func configUI() {
        [label].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
//            view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

       ])
    
    }
    
    private let label: UILabel = {
       let label = UILabel()
        let hello = L10n.Commom.hello
       label.text = hello
       return  label
   }()

        
}

