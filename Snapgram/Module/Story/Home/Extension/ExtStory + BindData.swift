//
//  ExtStory + BindData.swift
//  Snapgram
//
//  Created by Phincon on 27/12/23.
//

import Foundation
import UIKit

extension StoryViewController {
    internal func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let validData = data else {return}
            if !validData.isEmpty {
                self.listStory.append(contentsOf: validData)
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.storyTable.reloadData()
                    }
                }
            } else {
                self.isLoadMoreData = true
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                guard self.isLoadMoreData else {
                    self.storyTable.showAnimatedGradientSkeleton()
                    return
                }
                self.storyTable.showLoadingFooter()
            case .finished:
                DispatchQueue.main.async {
                    self.storyTable.hideSkeleton()
                    self.storyTable.hideLoadingFooter()
                }
            case .failed:
                DispatchQueue.main.async {
                    self.storyTable.hideLoadingFooter()
                    self.storyTable.hideSkeleton()
                    self.storyTable.backgroundView = self.errorView
                }
            }
        }).disposed(by: bag)
    }
}
