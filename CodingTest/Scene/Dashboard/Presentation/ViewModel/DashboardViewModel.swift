//
//  DashboardViewModel.swift
//  CodingTest
//
//  Created by Saif Adel on 9/11/25.
//

import Foundation

final class DashboardViewModel {
    private let fetchUseCase: DashboardItemsUseCase
    public var displayItems: [DashboardItemEntity]
    public var itemCount: Int
    public var coordinator: DashboardCoordinator?
    public var chunkLength = 13
    
    init(useCase: DashboardItemsUseCase) {
        self.displayItems = []
        self.itemCount = 0
        self.fetchUseCase = useCase
    }
    
    func loadItems(completion: @escaping () -> Void) {
        fetchUseCase.execute(completion: { [weak self] items in
            self?.prepareDisplayItems(with: items)
            completion()
        })
    }
}

private extension DashboardViewModel {
    func prepareDisplayItems(with items: [DashboardItemEntity]) {
        defer { self.itemCount = items.count }
        guard !items.isEmpty else { return }
        
        let maximumVisibleItemLength = Int(Carousal.UIConstant.maximumVisibleItemLength.rawValue) // 52
        
        // Decide chunk length for prefix/suffix (at least 1)
        
        
        // Case 1: Few items → repeat until reaching max length
        if items.count < maximumVisibleItemLength {
            chunkLength = max(1, maximumVisibleItemLength / 4)
            var repeatedItems: [DashboardItemEntity] = []
            while repeatedItems.count < maximumVisibleItemLength {
                repeatedItems.append(contentsOf: items)
            }
            displayItems = repeatedItems
            return
        }
        
        // Case 2: Enough items → wrap with suffix + items + prefix
        chunkLength = max(1, maximumVisibleItemLength / 2)
        let prefixItems = Array(items.prefix(chunkLength))
        let suffixItems = Array(items.suffix(chunkLength))
        displayItems = suffixItems + items + prefixItems
        
        // Trim if needed
        if displayItems.count > maximumVisibleItemLength {
            displayItems = Array(displayItems.prefix(maximumVisibleItemLength))
        }
    }
}

