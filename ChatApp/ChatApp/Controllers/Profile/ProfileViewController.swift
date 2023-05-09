//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage


enum ProfileViewModelType {
    case info, logOut
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

//MARK: Init and Variables
class ProfileViewController: UIViewController {

    //Variables
    let tableView = UITableView()
    
    var data = [ProfileViewModel]()
}

//MARK: Lifecycle
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No Name")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No Email")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .logOut, title: "Log Out", handler: {[unowned self] in
                        
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "name")
                
                //log out fb
                FBSDKLoginKit.LoginManager().logOut()
                
                //log out gg
                GIDSignIn.sharedInstance.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
                catch {
                    print("sign out error")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
            present(alert, animated: true)
        }))
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

//MARK: SetupView
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = Colors.mainBackgroundColor
        
        title = "Profile"
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.top.equalTo(topSafe)
            }
            $0.backgroundColor = .clear
            $0.registerReusedCell(ProfileTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.tableHeaderView = createTableHeaderView()
        }
    }
}


//MARK: Functions
extension ProfileViewController {
    func createTableHeaderView() -> UIView? {
       
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: 300))
        headerView.backgroundColor = .link
        
        let imageView = UIImageView()
        imageView >>> headerView >>> {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(75)
                $0.width.height.equalTo(150)
            }
            $0.contentMode = .scaleAspectFit
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 3
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 150 / 2
        }

        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url)
            case .failure(let error):
                print("⭐️ Failed to get download url: \(error)")
            }
        })
        
        return headerView
    }
}

//MARK: Delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusable(cellClass: ProfileTableViewCell.self, indexPath: indexPath)
        cell.setup(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}
