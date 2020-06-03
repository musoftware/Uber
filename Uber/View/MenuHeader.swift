//
//  MenuHeader.swift
//  Uber
//
//  Created by Ammar Elshamy on 6/1/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class MenuHeader: UIView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            self.fullNameLabel.text = user?.fullName
            self.emailLabel.text = user?.email
            guard let firstChar = user?.fullName.first else {return}
            self.profileImageLabel.text = String(firstChar)
        }
    }
    
    private let profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 32
        return view
    }()
    
    private let profileImageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 42)
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.fullNameLabel, self.emailLabel])
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helper Functions
    
    func configureUI() {
        backgroundColor = .backgroundColor
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, paddingTop: 4, left: leftAnchor, paddingLeft: 12, width: 64, height: 64)
        
        profileImageView.addSubview(profileImageLabel)
        profileImageLabel.anchor(centerX: profileImageView.centerXAnchor, centerY: profileImageView.centerYAnchor)
        
        addSubview(userInfoStackView)
        userInfoStackView.anchor(left: profileImageView.rightAnchor, paddingLeft: 12, centerY: profileImageView.centerYAnchor)
    }
}
