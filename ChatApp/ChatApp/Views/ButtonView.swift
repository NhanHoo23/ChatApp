//
//  ButtonView.swift
//  ChatApp
//
//  Created by NhanHoo23 on 29/03/2023.
//

import MTSDK

enum ButtonType: String {
    case login
    case createNewAccount
    case signUp
    
    var title: String {
        switch self {
        case .login: return "Log in"
        case .createNewAccount: return "Create New Account"
        case .signUp: return "Sign up"
        }
    }
}

class ButtonView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //Variables
    let buttonTitle = UILabel()
}


//MARK: SetupView
extension ButtonView {
    private func setupView() {
        isUserInteractionEnabled = true
        buttonTitle >>> self >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }

}


//MARK: Functions
extension ButtonView {
    func configButton(type: ButtonType, backgroundColor: UIColor = Colors.textFieldColor, cornerRadius: CGFloat = 15, title: String, font: UIFont = UIFont(name: FNames.medium, size: 18)!, titleColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        buttonTitle.text = title
        buttonTitle.textColor = titleColor
        buttonTitle.font = font
        
        if type == .login {
            disable(alpha: 1)
        } else {
            enable()
        }
    }
    
    func updateButtonState(_ bool: Bool, disableButtonColor: UIColor = Colors.textFieldColor, enableButtonColor: UIColor = .from("0088FE"), disableTitleColor: UIColor = .from("C3C4CA"), enableTitleColor: UIColor = .white) {
        if bool {
            UIView.animate(withDuration: 0.3, animations: {[unowned self] in
                enable()
                backgroundColor = enableButtonColor
                buttonTitle.textColor = enableTitleColor
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {[unowned self] in
                disable(alpha: 1)
                backgroundColor = disableButtonColor
                buttonTitle.textColor = disableTitleColor
            })
        }
    }
    
    
}
