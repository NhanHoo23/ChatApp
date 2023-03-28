//
//  TabbarView.swift
//  ChatApp
//
//  Created by NhanHoo23 on 27/03/2023.
//

import MTSDK

protocol TabbarViewDelegate {
    func didTapAt(index: Int)
}

class TabbarView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    private var selectedIndex = 0
    private let stackView = UIStackView()
    
    var delegate: TabbarViewDelegate?
}


//MARK: SetupView
extension TabbarView {
    private func setupView() {
        stackView >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
    }

}


//MARK: Functions
extension TabbarView {
    func addTab(tab: TabbarItemView) {
        tab.tag = self.stackView.arrangedSubviews.count
        tab.isSelected = tab.tag == self.selectedIndex
        
        tab.action = {
            if self.selectedIndex == tab.tag {return}
            self.selectedIndex = tab.tag
            self.updateSelected()
            self.delegate?.didTapAt(index: tab.tag)
        }
        
        self.stackView.addArrangedSubview(tab)
    }
    
    func updateSelected() {
        for tab in stackView.arrangedSubviews {
            if let tab = tab as? TabbarItemView {
                tab.isSelected = tab.tag == self.selectedIndex
            }
        }
    }
}
