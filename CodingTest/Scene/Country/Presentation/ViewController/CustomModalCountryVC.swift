//
//  CustomModalCountryVC.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class CustomModalCountryVC: CustomDynamicHeightModalVC {
    
    // MARK: Local Veriable -
    
    private var modalView: CustomModalCountryView {
        return self.contentView as! CustomModalCountryView
    }
    private let viewModel: CustomModalCountryViewModel
    
    // MARK: Life Cycyle -
    
    init(viewModel: CustomModalCountryViewModel) {
        self.viewModel = viewModel
        super.init(view: CustomModalCountryView())
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
        self.modalView.tableView.dataSource = self
        self.modalView.tableView.delegate = self
        self.modalView.headerView.searchField.delegate = self
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.modalView.tableView.reloadData()
            }
        }
    }
    
    private func setupActions() {
        self.modalView.headerView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.modalView.doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        if let clearButton = self.modalView.headerView.searchField.rightView as? UIButton {
            clearButton.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        }
        self.modalView.headerView.searchField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
    }
}


extension CustomModalCountryVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @objc private func closeTapped() {
        self.modalView.dismissWith?(.Ok(true, view: self.modalView))
    }
    
    @objc private func doneTapped() {
        self.modalView.dismissWith?(.Ok(true, view: self.modalView))
    }
    
    @objc private func clearSearch() {
        self.modalView.headerView.searchField.text = ""
        self.viewModel.clearSearch()
    }
    
    @objc private func searchChanged() {
        viewModel.search(self.modalView.headerView.searchField.text)
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
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
