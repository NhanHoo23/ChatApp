//
//  LocationPickerViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/04/2023.
//

import MTSDK
import CoreLocation
import MapKit

//MARK: Init and Variables
class LocationPickerViewController: UIViewController {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(coordinates: CLLocationCoordinate2D?) {
        super.init(nibName: nil, bundle: nil)
        self.coordinates = coordinates
        self.isPickable = false
    }

    //Variables
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    private let sendButton = UIButton()
    
    private var isPickable: Bool = true
    private var coordinates: CLLocationCoordinate2D?
    public var completion: ((CLLocationCoordinate2D) -> Void)?
}

//MARK: Lifecycle
extension LocationPickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        map = view.bounds
    }

}

//MARK: SetupView
extension LocationPickerViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        if isPickable {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))
            
            map.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_ :)))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            map.addGestureRecognizer(gesture)
        } else{
            guard let coordinates = self.coordinates else { return }

            
            // drop a pin on that location
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
        
        map >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        
    }
}


//MARK: Functions
extension LocationPickerViewController {
    @objc func sendButtonTapped() {
        guard let coordinates = self.coordinates else {return}
        self.navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }
    
    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
        
        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
}
