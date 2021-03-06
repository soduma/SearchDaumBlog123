//
//  FilterView.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterView: UITableViewHeaderFooterView {
    let disposeBag = DisposeBag()
    
    let sortButton = UIButton()
    let bottomLine = UIView()
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewModel) {
        sortButton.rx.tap
            .bind(to: viewModel.tapSortButton)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bottomLine.backgroundColor = .separator
    }
    
    private func layout() {
        [sortButton, bottomLine].forEach { addSubview($0) }
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(30)
        }
        
        bottomLine.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
