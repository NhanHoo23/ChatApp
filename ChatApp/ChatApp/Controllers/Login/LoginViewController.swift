//
//  LoginViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn

//MARK: Init and Variables
class LoginViewController: UIViewController {

    //Variables
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let emailField = TextFieldView()
    let passwordField = TextFieldView()
//    let loginBt = UIButton()
//    let registerBt = UIButton()
    let loginBt = ButtonView()
    let registerBt = ButtonView()
    let fbLoginBt = SocialButtonView(type: .facebook)
    let ggLoginBt = SocialButtonView(type: .google)
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
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                self.emailField.hideKeyboard()
                self.passwordField.hideKeyboard()
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
        
        emailField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "Email", returnKeyType: .continue)
            $0.textField.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChanged), type: .editingChanged)
        }
        
        passwordField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "Password", returnKeyType: .done, isSecurity: true)
            $0.textField.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChanged), type: .editingChanged)
        }
        
        loginBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(fieldView.snp.bottom).offset(Spacing.xl)
                $0.height.equalTo(50)
            }
            $0.configButton(type: .login, title: ButtonType.login.title, titleColor: .from("C3C4CA"))
            $0.tapHandle {
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
            $0.configButton(type: .createNewAccount, title: ButtonType.createNewAccount.title, titleColor: Colors.textColor)
            $0.tapHandle {
                self.didTapRegister()
            }
        }
        
        let orLb = UILabel()
        orLb >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(registerBt.snp.bottom).offset(Spacing.xxl)
                $0.centerX.equalToSuperview()
            }
            $0.text = "OR"
            $0.font = UIFont(name: FNames.bold, size: 14)
            $0.textColor = Colors.textColor
        }
        
        let leftLineView = UIView()
        let rightLineView = UIView()
        leftLineView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(orLb.snp.leading).offset(-Spacing.large)
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.centerY.equalTo(orLb)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .lightGray
        }
        
        rightLineView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(orLb.snp.trailing).offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
                $0.centerY.equalTo(orLb)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .lightGray
        }
        
        ggLoginBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(orLb.snp.bottom).offset(Spacing.xxl)
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.height.equalTo(50)
            }
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 15
            $0.tapHandle {
                self.signInWithGoogle()
            }
        }
        
        fbLoginBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(ggLoginBt.snp.bottom).offset(Spacing.large)
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview().offset(-Spacing.xl)
            }
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 15
            $0.tapHandle {
                self.signInWithFacebook()
            }
        }
    }
}


//MARK: Functions
extension LoginViewController {
    func didTapRegister() {
        emailField.hideKeyboard()
        passwordField.hideKeyboard()
        emailField.resetText()
        passwordField.resetText()
        
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logIn() {
        let email = emailField.getText()
        let password = passwordField.getText()

        self.showLoading(color: .gray, style: .medium, containerColor: .lightText, containerRadius: 5)
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.hideLoading()
            }
            guard let result = authResult, error == nil else {
                print("⭐️ Failed to log in user with email: \(email)")
                strongSelf.alertUserLoginError(with: "The password you entered is incorrect. Please try again.")
                return
            }
            let user = result.user
            
            UserDefaults.standard.set(email, forKey: "email")
            
            print("⭐️ User Log In: \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        })

        emailField.hideKeyboard()
        passwordField.hideKeyboard()
        self.loginBt.updateButtonState(false)
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {result, error in
            guard error == nil else {
                if let error = error {
                    print("⭐️ Failed to sign in with google: \(error)")
                }
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            print("⭐️ Did sign in with Google: \(user)")
            
            guard
                let email = user.profile?.email,
                let firstName = user.profile?.familyName,
                let lastName = user.profile?.givenName
            else {
                return
            }
            
            print("⭐️ email: \(email), firstName: \(firstName), lastName: \(lastName)")
            UserDefaults.standard.set(email, forKey: "email")
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                        if success {
                            //upload image
                            if let hasImage = user.profile?.hasImage, hasImage {
                                guard let url = user.profile?.imageURL(withDimension: 200) else {
                                    return
                                }
                                
                                URLSession.shared.dataTask(with: url, completionHandler: {data, _, _ in
                                    guard let data = data else {
                                        return
                                    }
                                    
                                    let fileName = chatUser.prfilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print("⭐️ DownloadUrl: \(downloadUrl)")
                                        case .failure(let error):
                                            print("⭐️ Error: \(error)")
                                        }
                                    })
                                }).resume()
                            }
                        }
                    })
                }
            })
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            self.showLoading(color: .gray, style: .medium, containerColor: .lightText, containerRadius: 5)
            Firebase.Auth.auth().signIn(with: credential, completion: {[weak self] authResult, error in
                guard let strongSelf = self else {return}
                DispatchQueue.main.async {
                    strongSelf.hideLoading()
                }
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("⭐️ Google creadential login failed, MFA may be needed - \(error)")
                    }
                    return
                }
                
                print("⭐️ Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true)
            })
        }
    }
    
    func signInWithFacebook() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: {result, error in
            guard let token = result?.token?.tokenString else {
                print("⭐️ User failed login to fb")
                return
            }
            
            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                             parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                             tokenString: token,
                                                             version: nil,
                                                             httpMethod: .get)
            facebookRequest.start(completion: {_, result, error in
                guard let result = result as? [String: Any], error == nil else {
                    print("⭐️ Failed to make facebook graph request")
                    return
                }
                
                print("⭐️ Result: \(result)")
                
                guard
                    let firstName = result["first_name"] as? String,
                    let lastName = result["last_name"] as? String,
                    let email = result["email"] as? String,
                    let picture = result["picture"] as? [String: Any],
                    let data = picture["data"] as? [String: Any],
                    let pictureUrl = data["url"] as? String else {
                        print("⭐️ Failed to get email and name from fb result")
                        return
                }
                
                UserDefaults.standard.set(email, forKey: "email")
                
                DatabaseManager.shared.userExists(with: email, completion: { exists in
                    if !exists {
                        let chatUser = ChatAppUser(firstName: firstName,
                                                   lastName: lastName,
                                                   emailAddress: email)
                        DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                            if success {
                                guard let url = URL(string: pictureUrl) else {return}
                                URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                                    guard let data = data else {
                                        print("⭐️ Failed to get data from facebook")
                                        return
                                    }
                                    
                                    print("⭐️ Got data from FB, uploading...")
                                    
                                    //upload image
                                    let fileName = chatUser.prfilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print("⭐️ DownloadUrl: \(downloadUrl)")
                                        case .failure(let error):
                                            print("⭐️ Error: \(error)")
                                        }
                                    })
                                }).resume()
                            }
                        })
                    }
                })
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                self.showLoading(color: .gray, style: .medium, containerColor: .lightText, containerRadius: 5)
                FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self] authResult, error in
                    guard let strongSelf = self else {return}
                    DispatchQueue.main.async {
                        strongSelf.hideLoading()
                    }
                    guard authResult != nil, error == nil else {
                        if let error = error {
                            print("⭐️ Facebook creadential login failed, MFA may be needed - \(error)")
                        }
                        return
                    }
                    
                    print("⭐️ Successfully logged user in")
                    strongSelf.navigationController?.dismiss(animated: true)
                })
            })
        })
    }
    
    func alertUserLoginError(with message: String) {
        emailField.hideKeyboard()
        passwordField.hideKeyboard()
        
        self.showAlert(title: "Error", message: message, actionTile: "OK", completion: {_ in})
    }
    
    @objc func textFieldDidChanged() {
        let email = emailField.getText()
        let password = passwordField.getText()

        if !email.isEmpty && !password.isEmpty {
            self.loginBt.updateButtonState(true)
        } else {
            self.loginBt.updateButtonState(false)
        }
    }
}

//MARK: Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = emailField.getText()
        if !text.isEmpty {
            if textField == emailField.textField {
                passwordField.showKeyboard()
            } else {
                self.logIn()
            }
        } else {
            alertUserLoginError(with: "The parameter email is required")
        }
        return false
    }


}
