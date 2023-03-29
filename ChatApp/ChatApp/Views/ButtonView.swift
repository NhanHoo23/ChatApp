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
        self.setupView()
    }
    
    //Variables
    let buttonTitle = UILabel()
}


//MARK: SetupView
extension ButtonView {
    private func setupView() {
        self.isUserInteractionEnabled = true
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
        self.layer.cornerRadius = cornerRadius
        self.buttonTitle.text = title
        self.buttonTitle.textColor = titleColor
        self.buttonTitle.font = font
        
        if type == .login {
            self.disable(alpha: 1)
        } else {
            self.enable()
        }
    }
    
    func updateButtonState(_ bool: Bool, disableButtonColor: UIColor = Colors.textFieldColor, enableButtonColor: UIColor = .from("0088FE"), disableTitleColor: UIColor = .from("C3C4CA"), enableTitleColor: UIColor = .white) {
        if bool {
            UIView.animate(withDuration: 0.3, animations: {
                self.enable()
                self.backgroundColor = enableButtonColor
                self.buttonTitle.textColor = enableTitleColor
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.disable(alpha: 1)
                self.backgroundColor = disableButtonColor
                self.buttonTitle.textColor = disableTitleColor
            })
        }
    }
    
    
}
