//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    let searchButton = UIButton()
    
    let tapSearchButton = PublishRelay<Void>()
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge(
                rx.searchButtonClicked.asObservable(), //키보드의 엔터버튼
                searchButton.rx.tap.asObservable() // 상단의 검색버튼
            )
            .bind(to: tapSearchButton)
            .disposed(by: disposeBag)
        
        tapSearchButton
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = tapSearchButton
            .withLatestFrom(self.rx.text) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
        
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemYellow, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
