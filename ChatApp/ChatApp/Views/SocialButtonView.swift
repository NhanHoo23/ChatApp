//
//  SocialButtonView.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK

enum SocialType {
    case google
    case facebook
}

class SocialButtonView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init(type: SocialType) {
        super.init(frame: .zero)
        self.setupView()
        
        if type == .facebook {
            updateUI(type: .facebook)
        } else {
            updateUI(type: .google)
        }
    }
    
    //Variables
    let iconView = UIImageView()
    let titleLb = UILabel()
    let containerView = UIView()
}


//MARK: SetupView
extension SocialButtonView {
    private func setupView() {
        self.isUserInteractionEnabled = true
        
        self.titleLb.text = "Continue with Facebook"
        self.titleLb.font = UIFont(name: FNames.regular, size: 16)
        self.titleLb.sizeToFit()
        let titleLbIntrinsicContentSize = titleLb.intrinsicContentSize.width
        let widthForContentView = 35 + Spacing.medium + titleLbIntrinsicContentSize
        containerView >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalTo(widthForContentView)
            }
        }
        
        iconView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(35)
            }
            $0.contentMode = .scaleAspectFit
        }
        
        titleLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(iconView.snp.trailing).offset(Spacing.medium)
                $0.centerY.equalToSuperview()
            }
            $0.font = UIFont(name: FNames.regular, size: 16)
        }
    }

}


//MARK: Functions
extension SocialButtonView {
    func updateUI(type: SocialType) {
        if type == .facebook {
            self.backgroundColor = .link
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 1
            iconView.image = UIImage(named: "icon_facebook")
            self.titleLb.textColor = .white
            self.titleLb.text = "Continue with Facebook"
            self.titleLb.sizeToFit()
            let titleLbIntrinsicContentSize = titleLb.intrinsicContentSize.width
            let widthForContentView = 35 + Spacing.medium + titleLbIntrinsicContentSize
            containerView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalTo(widthForContentView)
            }
        } else {
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.link.cgColor
            self.layer.borderWidth = 1
            iconView.image = UIImage(named: "icon_google")
            self.titleLb.textColor = .link
            self.titleLb.text = "Continue with Google"
            self.titleLb.sizeToFit()
            let titleLbIntrinsicContentSize = titleLb.intrinsicContentSize.width
            let widthForContentView = 35 + Spacing.medium + titleLbIntrinsicContentSize
            containerView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalTo(widthForContentView)
            }
        }
    }
}
