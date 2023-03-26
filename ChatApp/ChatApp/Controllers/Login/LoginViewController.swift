//
//  LoginViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK

//MARK: Init and Variables
class LoginViewController: UIViewController {

    //Variables
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let emailField = UITextField()
    let passwordField = UITextField()
    let loginBt = UIButton()
    let registerBt = UIButton()
}

//MARK: Lifecycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension LoginViewController {
    private func setupView() {
        title = "Log In"
        view.backgroundColor = Colors.mainBackgroundColor
        self.hideKeyboardEvent()
        
        let scrollView = UIScrollView()
        scrollView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
        
        let contentView = UIView()
        contentView >>> scrollView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
        }
        
        imageView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Spacing.xl)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(maxWidth / 3)
            }
        }
        
        let fieldView = UIView()
        fieldView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(Spacing.large)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(maxWidth * 0.9)
                $0.height.equalTo(50 * 2 + Spacing.small)
            }
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
        let emailFieldView = UIView()
        emailFieldView >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.backgroundColor = Colors.textFieldColor
        }
        
        emailField >>> emailFieldView >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
            }
            $0.delegate = self
            $0.backgroundColor = Colors.textFieldColor
            $0.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeHolderColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 16)!])
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .continue
            $0.clearButtonMode = .whileEditing
            $0.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        }
        
        let passwordFieldView = UIView()
        passwordFieldView >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.backgroundColor = Colors.textFieldColor
        }
        
        passwordField >>> passwordFieldView >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
            }
            $0.delegate = self
            $0.backgroundColor = Colors.textFieldColor
            $0.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeHolderColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 16)!])
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .done
            $0.clearButtonMode = .whileEditing
            $0.isSecureTextEntry = true
            $0.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        }
        
        loginBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(fieldView.snp.bottom).offset(Spacing.xl)
                $0.height.equalTo(50)
            }
            $0.backgroundColor = Colors.textFieldColor
            $0.layer.cornerRadius = 15
            $0.setTitle("Log in", for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.medium, size: 18)
            $0.setTitleColor(.from("C3C4CA"), for: .normal)
            $0.disable(alpha: 1)
        }
        
        registerBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(loginBt.snp.bottom).offset(Spacing.large)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview()
            }
            $0.backgroundColor = Colors.textFieldColor//.from("0088FE")
            $0.layer.cornerRadius = 15
            $0.setTitle("Create new account", for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.medium, size: 18)
            $0.setTitleColor(Colors.textColor, for: .normal)
            $0.handle {
                self.didTapRegister()
            }
        }
    }
}


//MARK: Functions
extension LoginViewController {
    func didTapRegister() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logIn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        alertUserLoginError(true)
        
        //firebase login
    }
    
    func alertUserLoginError(_ isLogin: Bool) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        showLoading(color: .gray, style: .medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.hideLoading()
            let title = isLogin ? "Incorrect Password" : "Error"
            let message = isLogin ? "The Password you entered is incorrect. Please try again." : "The parameter email is required"
            self.showAlert(title: title,message: message, actionTile: "OK", completion: {_ in})
        })
    }
    
    @objc func textFieldDidChanged() {
        guard let email = emailField.text, let password = passwordField.text else {return}
        
        if !email.isEmpty && !password.isEmpty {
            updateLoginBt(true)
        } else {
            updateLoginBt(false)
        }
    }
    
    func updateLoginBt(_ bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.3, animations: {
                self.loginBt.enable()
                self.loginBt.backgroundColor = .from("0088FE")
                self.loginBt.setTitleColor(.white, for: .normal)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.loginBt.disable(alpha: 1)
                self.loginBt.backgroundColor = Colors.textFieldColor
                self.loginBt.setTitleColor(.from("C3C4CA"), for: .normal)
            })
        }
    }
}

//MARK: Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = emailField.text, !text.isEmpty {
            if textField == emailField {
                passwordField.becomeFirstResponder()
            } else {
                self.logIn()
            }
        } else {
            alertUserLoginError(false)
        }
        return false
    }
    
    
}
