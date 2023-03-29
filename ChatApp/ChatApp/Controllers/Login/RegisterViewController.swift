//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import FirebaseAuth

//MARK: Init and Variables
class RegisterViewController: UIViewController {

    //Variables
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    let firstNameField = TextFieldView()
    let lastNameField = TextFieldView()
    let emailField = TextFieldView()
    let passwordField = TextFieldView()
    let signUpBt = ButtonView()
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
        
        let avatarView = UIView()
        avatarView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Spacing.xl)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(maxWidth / 3)
            }
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                self.didTapChangeProifilePic()
            }
        }
        
        imageView >>> avatarView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.layer.cornerRadius = (maxWidth / 3) / 2
            $0.clipsToBounds = true
        }
        
        let cameraIconView = UIView()
        cameraIconView >>> avatarView >>> {
            $0.snp.makeConstraints {
                $0.trailing.bottom.equalToSuperview()
                $0.width.height.equalTo(35)
            }
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 35 / 2
            $0.backgroundColor = .lightGray
        }
        
        let cameraIcon = UIImageView()
        cameraIcon >>> cameraIconView >>> {
            $0.snp.makeConstraints {
                $0.trailing.bottom.equalToSuperview().offset(-Spacing.medium)
                $0.leading.top.equalToSuperview().offset(Spacing.medium)
            }
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(systemName: "camera.fill")
        }
        
        let fieldView = UIView()
        fieldView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(avatarView.snp.bottom).offset(Spacing.large)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(maxWidth * 0.9)
                $0.height.equalTo(50 * 4 + Spacing.small * 3)
            }
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
        
        firstNameField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "First Name", returnKeyType: .continue)
            $0.textField.delegate = self
        }

        lastNameField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(firstNameField.snp.bottom).offset(Spacing.small)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "Last Name", returnKeyType: .continue)
            $0.textField.delegate = self
        }

        emailField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(lastNameField.snp.bottom).offset(Spacing.small)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "Email", returnKeyType: .continue)
            $0.textField.delegate = self
        }
        
        passwordField >>> fieldView >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            $0.configTextField(placeholder: "Password", returnKeyType: .continue, isSecurity: true)
            $0.textField.delegate = self
        }
        
        signUpBt >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(fieldView.snp.leading)
                $0.trailing.equalTo(fieldView.snp.trailing)
                $0.top.equalTo(fieldView.snp.bottom).offset(Spacing.xl)
                $0.height.equalTo(50)
                $0.bottom.equalToSuperview()
            }
            $0.configButton(type: .signUp, backgroundColor: .from("0088FE"), title: ButtonType.signUp.title, titleColor: .white)
            $0.tapHandle {
                self.didTapSignUp()
            }
        }
    }
}


//MARK: Functions
extension RegisterViewController {
    @objc func didTapSignUp() {
        self.firstNameField.hideKeyboard()
        self.lastNameField.hideKeyboard()
        self.emailField.hideKeyboard()
        self.passwordField.hideKeyboard()
        
        let firstName = firstNameField.getText()
        let lastName = lastNameField.getText()
        let email = emailField.getText()
        let password = passwordField.getText()
        
        if email.isEmpty,
           password.isEmpty,
           firstName.isEmpty,
           lastName.isEmpty {
            alertUserLoginError(with: "Please enter all infomation to sign up.")
            return
        }

        if password.count < 6 {
            alertUserLoginError(with: "Nhap pass nhieu hon 6 ki tu")
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: {[weak self] exits in
            guard let strongSelf = self else {return}
            guard !exits else {
                strongSelf.alertUserLoginError(with: "Look like a user account for that email address already exists.")
                return
            }
            
            strongSelf.showLoading(color: .gray, style: .medium, containerColor: .lightText, containerRadius: 5)
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                DispatchQueue.main.async {
                    strongSelf.hideLoading()
                }
                guard authResult != nil, error == nil else {
                    print("Error creating user")
                    return
                }
                
                let chatUser = ChatAppUser(firstName: firstName,
                                           lastName: lastName,
                                           emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                    if success {
                        //upload image
                        guard let image = strongSelf.imageView.image, let data = image.pngData() else {
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
                    }
                })
                strongSelf.navigationController?.dismiss(animated: true)
            })
        })
        
       
    }
    
    func didTapChangeProifilePic() {
        self.presentPhotoActionSheet()
    }
    
    func alertUserLoginError(with message: String) {
        showLoading(color: .gray, style: .medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.hideLoading()
            self.showAlert(title: "Error", message: message, actionTile: "OK", completion: {_ in})
        })
    }
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        self.present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
}

//MARK: Delegate
extension RegisterViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField.textField {
            lastNameField.showKeyboard()
        } else if textField == lastNameField.textField {
            emailField.showKeyboard()
        } else if textField == emailField.textField {
            passwordField.showKeyboard()
        } else {
            self.didTapSignUp()
        }
        return false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
