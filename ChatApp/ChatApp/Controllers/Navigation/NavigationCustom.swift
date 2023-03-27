//
//  NavigationCustom.swift
//  ChatApp
//
//  Created by NhanHoo23 on 27/03/2023.
//

import MTSDK

class Navigation: UINavigationController {
    init(_ rootVC: UIViewController) {
        super.init(rootViewController: rootVC)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    //variables
}

extension Navigation {
    override var preferredStatusBarStyle: UIStatusBarStyle {return .darkContent}
    override var childForStatusBarStyle: UIViewController? {return topViewController }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.textColor, NSAttributedString.Key.font: UIFont(name: FNames.medium, size: 18)!]
        let largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.textColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 34)!]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Colors.mainBackgroundColor
        appearance.titleTextAttributes = titleTextAttributes
        appearance.largeTitleTextAttributes = largeTitleTextAttributes
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

extension Navigation: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        updateNavibar(viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    func updateNavibar(_ viewController: UIViewController) {
        
        if #available(iOS 14.0, *) {
            viewController.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        viewController.navigationController?.navigationBar.tintColor = Colors.textColor
        viewController.navigationController?.navigationBar.isTranslucent = true
    }
    
    
}
