//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK

//MARK: Init and Variables
class RegisterViewController: UIViewController {

    //Variables
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.badge.plus")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .gray
        return imageView
    }()
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let signUpBt = UIButton()
}

//MARK: Lifecycle
extension RegisterViewController {
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
extension RegisterViewController {
    private func setupView() {
        title = "Sign Up"
        view.backgroundColor = Colors.mainBackgroundColor
        
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
            $0.tapHandle {
                printDebug("change avatar")
            }
        }
        
        let fieldView = UIView()
        fieldView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(Spacing.large)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(maxWidth * 0.9)
                $0.height.equalTo(50 * 4 + Spacing.small * 3)
            }
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
        let firstNameView = UIView()
        firstNameView >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.backgroundColor = Colors.textFieldColor
        }
        
        firstNameField >>> firstNameView >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
            }
            $0.delegate = self
            $0.backgroundColor = Colors.textFieldColor
            $0.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeHolderColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 16)!])
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .continue
            $0.clearButtonMode = .whileEditing
        }
        
        let lastNameView = UIView()
        lastNameView >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(firstNameView.snp.bottom).offset(Spacing.small)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.backgroundColor = Colors.textFieldColor
        }
        
        lastNameField >>> lastNameView >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
            }
            $0.delegate = self
            $0.backgroundColor = Colors.textFieldColor
            $0.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeHolderColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 16)!])
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .continue
            $0.clearButtonMode = .whileEditing
        }
        
        let emailFieldView = UIView()
        emailFieldView >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(lastNameView.snp.bottom).offset(Spacing.small)
                $0.leading.trailing.equalToSuperview()
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
        }
        
        signUpBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(fieldView.snp.bottom).offset(Spacing.xl)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview()
            }
            $0.backgroundColor = .from("0088FE")
            $0.layer.cornerRadius = 15
            $0.setTitle("Sign up", for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.medium, size: 18)
            $0.setTitleColor(.white, for: .normal)
            $0.handle {
                self.didTapSignUp()
            }
        }
    }
}


//MARK: Functions
extension RegisterViewController {
    @objc func didTapSignUp() {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        guard
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty, !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty else {
                alertUserLoginError(true)
                return
            }
        
        guard
            let password = passwordField.text,
            password.count >= 6 else {
                alertUserLoginError(false)
                return
            }
    }
    
    func alertUserLoginError(_ isSignUp: Bool) {
        self.firstNameField.resignFirstResponder()
        self.lastNameField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        showLoading(color: .gray, style: .medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.hideLoading()
            let message = isSignUp ? "Please enter all information to sign up" : "Nhap pass nhieu hon 6 ki tu"
            self.showAlert(title: "Error", message: message, actionTile: "OK", completion: {_ in})
        })
    }
}

//MARK: Delegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            self.didTapSignUp()
        }
        return false
    }
    
}
