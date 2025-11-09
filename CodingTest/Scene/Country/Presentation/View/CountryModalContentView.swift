//
//  CountryModalContentView.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class CountryModalContentView: UIView {
    
    let headerView: CountryModalHeaderView = {
        let view = CountryModalHeaderView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: DynamicHeightTableView = {
        let tv = DynamicHeightTableView()
        tv.register(CountryTVCell.self, forCellReuseIdentifier: CountryTVCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tv
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9) // subtle dim
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        self.addSubview(headerView)
        self.addSubview(tableView)
        self.addSubview(dimmedView)
        dimmedView.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            dimmedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            doneButton.topAnchor.constraint(equalTo: dimmedView.topAnchor, constant: 8),
            doneButton.leadingAnchor.constraint(equalTo: dimmedView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: dimmedView.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
