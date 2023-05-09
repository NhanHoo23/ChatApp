//
//  VideoPlayerViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK

//MARK: Init and Variables
class VideoPlayerViewController: UIViewController {

    //Variables
}

//MARK: Lifecycle
extension VideoPlayerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension VideoPlayerViewController {
    private func setupView() {
        
    }
}


//MARK: Functions
extension VideoPlayerViewController {

}
