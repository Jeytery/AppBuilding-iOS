//
//  RootViewController.swift
//  Composite
//
//  Created by Jeytery on 17.10.2022.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .tertiarySystemBackground
        
        let button1 = UIButton()
        let button2 = UIButton()
        
        let st = UIStackView()
        view.addSubview(st)
        st.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        st.spacing = 10
        st.distribution = .fillEqually
        
        st.addArrangedSubview(button1)
        st.addArrangedSubview(button2)
        
        button1.setTitle("button1", for: .normal)
        button2.setTitle("button2", for: .normal)
        
        button1.accept(theme: DefaultButtonTheme())
        button2.accept(theme: NightButtonTheme())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
