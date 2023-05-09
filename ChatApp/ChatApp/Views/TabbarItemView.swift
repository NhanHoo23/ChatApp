//
//  TabbarItemView.swift
//  ChatApp
//
//  Created by NhanHoo23 on 27/03/2023.
//

import MTSDK

class TabbarItemView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init(tabName: String, iconName: String, selectedIconName: String? = nil, iconColor: UIColor = .white, iconSelectedColor: UIColor = .red) {
        super.init(frame: .zero)
        setupView()
        
        self.tabName = tabName
        self.iconName = iconName
        if let selectedIconName = selectedIconName {
            self.selectedIconName = selectedIconName
        }
        self.iconColor = iconColor
        self.iconSelectedColor = iconSelectedColor
        
        iconView.image = UIImage(systemName:  iconName)
        
    }
    
    //Variables
    let iconView = UIImageView()
    let tabNameLb = UILabel()
    let button = UIButton()
    
    var tabName: String!
    var iconName: String!
    var selectedIconName: String!
    var iconColor: UIColor!
    var iconSelectedColor: UIColor!
    
    var action: (() -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            self.updateState()
        }
    }
}


//MARK: SetupView
extension TabbarItemView {
    private func setupView() {
        tabNameLb >>> self >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        }
        
        iconView >>> self >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(tabNameLb.snp.top).offset(-Spacing.small)
                $0.top.equalToSuperview().offset(Spacing.small)
                $0.leading.trailing.equalToSuperview()
            }
            $0.contentMode = .scaleAspectFit
        }
        
        button >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.handle { [weak self] in
                if let action = self?.action {
                    action()
                }
            }
        }
    }

}


//MARK: Functions
extension TabbarItemView {
    func updateState() {
        let iconColor = isSelected ? iconSelectedColor : iconColor
        iconView.tintColor = iconColor
        tabNameLb.text = tabName
        tabNameLb.textColor = iconColor
    }
}
