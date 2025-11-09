//
//  DynamicHeightTableView.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

final class DynamicHeightTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
       
       //  reloadData()
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

