//
//  PhotoViewerViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK

//MARK: Init and Variables
class PhotoViewerViewController: UIViewController {

    //Variables
}

//MARK: Lifecycle
extension PhotoViewerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension PhotoViewerViewController {
    private func setupView() {
        
    }
}


//MARK: Functions
extension PhotoViewerViewController {

}
