//
//  NativeModalCountryVC.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class NativeModalCountryVC: UIViewController{
    
    lazy var contentView: NativeCountryModalContentView = {
        let view = NativeCountryModalContentView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewModel: CustomModalCountryViewModel
    
    // MARK: Life Cycyle -
    
    init(viewModel: CustomModalCountryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        viewModel.loadCountries()
    }
    
    private func setupViews() {
        view.addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        self.contentView.tableView.dataSource = self
        self.contentView.tableView.delegate = self
        self.contentView.headerView.searchField.delegate = self
        self.viewModel.onUpdate = { [weak self] in
            self?.contentView.tableView.reloadData()
            DispatchQueue.main.async {
                self?.adjustModalHeight()
            }
        }
    }
    
    private func setupActions() {
        self.contentView.headerView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.contentView.doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        if let clearButton = self.contentView.headerView.searchField.rightView as? UIButton {
            clearButton.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        }
        self.contentView.headerView.searchField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
    }
    
    private func adjustModalHeight() {
        view.layoutIfNeeded()
        
        let maxHeight = view.bounds.height * 0.8
        let tableHeight = contentView.tableView.contentSize.height + 200
        let finalHeight = min(tableHeight, maxHeight)
        
        preferredContentSize = CGSize(width: view.bounds.width, height: finalHeight)
        
        if let sheet = self.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return finalHeight
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 16
        }
    }
}


extension NativeModalCountryVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @objc private func closeTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func clearSearch() {
        self.contentView.headerView.searchField.text = ""
        self.viewModel.clearSearch()
    }
    
    @objc private func searchChanged() {
        viewModel.search(self.contentView.headerView.searchField.text)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTVCell.identifier, for: indexPath) as? CountryTVCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.country(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
