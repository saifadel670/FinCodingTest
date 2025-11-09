//
//  CountryActionView.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import UIKit

final class CountryActionView: UIView {
    
    // MARK: - UI Elements
    
    private let nativeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Native", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let customButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Custom", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var radioStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nativeButton, customButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public var actionType: OptionType = .native
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = App.Color.cardBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        addSubview(radioStackView)
        addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            radioStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            radioStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            radioStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            loadButton.topAnchor.constraint(equalTo: radioStackView.bottomAnchor, constant: 24),
            loadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            loadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Radio Button Logic
    
    private func setupActions() {
        nativeButton.addTarget(self, action: #selector(selectNative), for: .touchUpInside)
        customButton.addTarget(self, action: #selector(selectCustom), for: .touchUpInside)
        selectNative()
    }
    
    @objc private func selectNative() {
        actionType = .native
        nativeButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        customButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc private func selectCustom() {
        actionType = .custom
        nativeButton.setImage(UIImage(systemName: "circle"), for: .normal)
        customButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
    }
}
