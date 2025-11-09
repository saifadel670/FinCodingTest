//
//  DashboardVC.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import UIKit

final class DashboardVC: UIViewController {
    
    // MARK: UI Componet -
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        let width = view.bounds.width * Carousal.UIConstant.itemWidthRatio.rawValue
        layout.itemSize = CGSize(width: width, height: Carousal.UIConstant.itemHeight.rawValue)
        layout.minimumLineSpacing = Carousal.UIConstant.itemSpacing.rawValue
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.decelerationRate = .fast
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var countryActionView: CountryActionView = {
        let view = CountryActionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Local Veriable -
    
    private let viewModel: DashboardViewModel
    
    // MARK: Life Cycyle -
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = App.Color.background
        setupNavigationBar()
        setupCountryActionView()
        setupCollectionView()
        setupActivityIndicator()
        self.activityIndicator.startAnimating()
        viewModel.loadItems {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if self.viewModel.itemCount > 0 {
                    self.collectionView.reloadData()
                    self.scrollToMiddle()
                }
            }
            
        }
    }
}

// MARK: - Setup
private extension DashboardVC {
    
    func setupNavigationBar() {
        self.title = App.Constant.AppName
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = App.Color.appbar
            appearance.titleTextAttributes = [.foregroundColor: App.Color.title]
            appearance.largeTitleTextAttributes = [.foregroundColor: App.Color.title]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: self.countryActionView.bottomAnchor, constant: App.Constant.Main.padding),
            collectionView.heightAnchor.constraint(equalToConstant: Carousal.UIConstant.itemHeight.rawValue),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupCountryActionView() {
        countryActionView.loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        view.addSubview(countryActionView)
        NSLayoutConstraint.activate([
            countryActionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: App.Constant.Main.padding),
            countryActionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: App.Constant.Main.padding)
        ])
    }
    
    func scrollToMiddle(animated: Bool = false) {
        DispatchQueue.main.async {
            let middleIndex = self.viewModel.itemCount
            let indexPath = IndexPath(item: middleIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }
    
    @objc private func loadButtonTapped() {
        self.viewModel.coordinator?.presentCountryModal(self.countryActionView.actionType)
    }
    
}

// MARK: - UICollectionViewDataSource
extension DashboardVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.displayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let model = self.viewModel.displayItems[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DashboardVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        recenterIfNeeded(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            recenterIfNeeded(scrollView)
        }
    }
    
    private func recenterIfNeeded(_ scrollView: UIScrollView) {
        let visibleCenterX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: visibleCenterX, y: scrollView.bounds.midY)) else { return }
        let chunkLength = Int(self.viewModel.chunkLength)
        // When near beginning
        if indexPath.item < chunkLength {
            let newIndex = indexPath.item + self.viewModel.itemCount
            collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
        }
        // When near end
        else if indexPath.item >= self.viewModel.displayItems.count - chunkLength {
            let newIndex = indexPath.item - self.viewModel.itemCount
            collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
        }
    }
}

// MARK: - Snapping Layout
final class SnappingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        guard let layoutAttributes = super.layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        for attributes in layoutAttributes {
            let itemCenter = attributes.center.x
            if abs(itemCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemCenter - horizontalCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
