//
//  PickupController.swift
//  Uber
//
//  Created by Ammar Elshamy on 5/23/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol PickupControllerDelegate {
    func didAcceptTrip(trip: Trip)
}

class PickupController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: PickupControllerDelegate?
    private var trip: Trip
    
    // UI Views
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var circularProgressView: CircularProgressView = {
        let frame = CGRect(x: 0, y: 0, width: 290, height: 290)
        let cp = CircularProgressView(frame: frame)
        return cp
    }()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 270 / 2
        return view
    }()
    
    private let pickupLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let acceptTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("ACCEPT TRIP", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()

    // MARK: - Lifecycle

    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(animateProgress), with: nil, afterDelay: 1)
        
        configureUI()
        configureMapView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16)
        
        view.addSubview(circularProgressView)
        circularProgressView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 80, centerX: view.centerXAnchor, width: 290, height: 290)
        
        circularProgressView.addSubview(mapView)
        mapView.anchor(centerX: circularProgressView.centerXAnchor, centerY: circularProgressView.centerYAnchor, width: 270, height: 270)
        
        view.addSubview(pickupLabel)
        pickupLabel.anchor(top: circularProgressView.bottomAnchor, paddingTop: 60, centerX: view.centerXAnchor)
        
        view.addSubview(acceptTripButton)
        acceptTripButton.anchor(top: pickupLabel.bottomAnchor, paddingTop: 15, left: view.leftAnchor, paddingLeft: 32, right: view.rightAnchor, paddingRight: 32, height: 50)
    }
    
    func configureMapView() {
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        mapView.addAndSelectAnnotation(forPlacemark: MKPlacemark(coordinate: trip.pickupCoordinates))
    }
        
    // MARK: - Selectors
    
    @objc func animateProgress() {
        circularProgressView.animateProgress(duration: 5, completion: {
            DriversService.shared.updateTripState(trip: self.trip, state: .denied) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAcceptTrip() {
        DriversService.shared.updateTripState(trip: self.trip, state: .accepted) {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.trip.driverUid = uid
            self.trip.state = TripState.accepted
            self.delegate?.didAcceptTrip(trip: self.trip)
        }
    }
    
}
