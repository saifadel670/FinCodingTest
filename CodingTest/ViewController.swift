//
//  ViewController.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var colectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: screenWidth * cellWidthRation, height: 300)
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    private var images: [String] = []
    private var rows: [String] = []
    private let cellWidthRation: CGFloat = 0.8
    private let screenWidth = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(colectionView)
        NSLayoutConstraint.activate([
            self.colectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.colectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.colectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.colectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        self.populateData(with: ["Image_1","Image_2", "Image_3"])
    }
}

extension ViewController {
    private func populateData(with items: [String]) {
        
        let itemWidth = (screenWidth - self.cellWidthRation)
        let maximumVisibleCellNo = (screenWidth / itemWidth).rounded(.up)
        if items.count < Int(maximumVisibleCellNo * 5) {
            self.images = items + items + items + items + images
            self.colectionView.reloadData()
            self.colectionView.scrollToItem(at: IndexPath(item: items.count, section: 0), at: .left, animated: false)
        } else {
            
        }
        
    }
    
    private func navigateToModal() {
        let modalVC = DynamicHeightModalVC()
        modalVC.modalPresentationStyle = .formSheet
        self.navigationController?.present(modalVC, animated: true)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = UIImage(named: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigateToModal()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == images.count - 1 {
            self.colectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}
