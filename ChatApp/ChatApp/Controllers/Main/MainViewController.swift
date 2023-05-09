//
//  MainViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 27/03/2023.
//

import MTSDK
import FirebaseAuth

//MARK: Init and Variables
class MainViewController: UIViewController {

    //Variables
    let tabbarView = TabbarView()
    let containerView = UIView()
    
    var selectedIndex: Int = -1
    var viewControllers: [UIViewController] = []
    let chatVC = ConversationsViewController()
    let profileVC = ProfileViewController()
}

//MARK: Lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [chatVC, profileVC]
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.validateAuth()
    }


//    override var preferredStatusBarStyle: UIStatusBarStyle {return .darkContent}
}

//MARK: SetupView
extension MainViewController {
    private func setupView() {
        tabbarView >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(botSafe)
                $0.height.equalTo(90 - botSafeHeight)
            }
            $0.delegate = self
        }
        
//        let bottomView = UIView()
//        bottomView >>> view >>> {
//            $0.snp.makeConstraints {
//                $0.bottom.leading.trailing.equalToSuperview()
//                $0.top.equalTo(tabbarView.snp.bottom)
//            }
//            $0.backgroundColor = Colors.tabbarColor
//        }
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView >>> view >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.top.equalTo(tabbarView.snp.bottom)
            }
        }
        
        containerView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(tabbarView.snp.top)
            }
        }
        
        setupTabbar()
        setupTabSelected(index: 0)
    }
}


//MARK: Functions
extension MainViewController {
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
    
    func setupTabbar() {
        let chatTab = TabbarItemView(tabName: "Chats", iconName: "bubble.right.fill", iconColor: .lightGray, iconSelectedColor: .systemPink)
        self.tabbarView.addTab(tab: chatTab)
        
        let profileTab = TabbarItemView(tabName: "Profile", iconName: "person.circle.fill", iconColor: .lightGray, iconSelectedColor: .systemPink)
        self.tabbarView.addTab(tab: profileTab)
    }
    
    func setupTabSelected(index: Int) {
        if self.selectedIndex >= 0 {
            viewControllers[self.selectedIndex].remove()
        }
        self.selectedIndex = index
        let viewcontroller = self.viewControllers[index]
        self.add(viewcontroller)
        
        viewcontroller.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.containerView)
        }
    }
}

//MARK: Delegate
extension MainViewController: TabbarViewDelegate {
    func didTapAt(index: Int) {
        if self.selectedIndex == index {return}
        self.setupTabSelected(index: index)
    }
    
    
}

