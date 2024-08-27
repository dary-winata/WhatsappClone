//
//  HomeTabbarViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 24/08/24.
//

import Foundation

protocol HomeTabbarViewModelDelegate: AnyObject {
    func setupView()
}

protocol HomeTabbarViewModelProtocol: AnyObject {
    var delegate: HomeTabbarViewModelDelegate? { get set }
    func onViewWillAppeare()
}

class HomeTabbarViewModel: HomeTabbarViewModelProtocol {
    weak var delegate: HomeTabbarViewModelDelegate?
    
    func onViewWillAppeare() {
        delegate?.setupView()
    }
}
