//
//  LoginViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import FirebaseAuth
import FBSDKLoginKit

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
    let fbLoginBt = FBLoginButton()
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
            $0.handle {
                self.logIn()
            }
        }
        
        registerBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(loginBt.snp.bottom).offset(Spacing.large)
                $0.height.equalTo(50)
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
        
        fbLoginBt.removeConstraints(fbLoginBt.constraints)
        fbLoginBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(registerBt.snp.bottom).offset(Spacing.large)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview()
            }
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 15
            $0.delegate = self
            $0.permissions = ["public_profile", "email"]
        }
    }
}


//MARK: Functions
extension LoginViewController {
    func didTapRegister() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        emailField.text = ""
        passwordField.text = ""
        
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logIn() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                strongSelf.alertUserLoginError(with: "The password you entered is incorrect. Please try again.")
                return
            }
            
            let user = result.user
            print("User Log In: \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        })
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        emailField.text = ""
        passwordField.text = ""
        updateLoginBt(false)
    }
    
    func alertUserLoginError(with message: String) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        showLoading(color: .gray, style: .medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.hideLoading()
            self.showAlert(title: "Error", message: message, actionTile: "OK", completion: {_ in})
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
extension LoginViewController: UITextFieldDelegate, LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            debugPrint("user failed login to fb")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start(completion: {_, result, error in
            guard let result = result as? [String: Any], error == nil else {
                debugPrint("Failed to make facebook graph request")
                return
            }
            
            debugPrint("\(result)")
            
            guard
                let userName = result["name"] as? String,
                let email = result["email"] as? String else {
                debugPrint("Failed to get email and name from fb result")
                return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {return}
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self] authResult, error in
                guard let strongSelf = self else {return}
                guard authResult != nil, error == nil else {
                    debugPrint("Facebook creadential login failed, MFA may be needed - \(error)")
                    return
                }
                
                debugPrint("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true)
            })
        })
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        //no operation
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = emailField.text, !text.isEmpty {
            if textField == emailField {
                passwordField.becomeFirstResponder()
            } else {
                self.logIn()
            }
        } else {
            alertUserLoginError(with: "The parameter email is required")
        }
        return false
    }
    
    
}
