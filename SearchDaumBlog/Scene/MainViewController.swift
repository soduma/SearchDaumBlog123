//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreMedia

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    let searchBar = SearchBar()
    let listView = BlogListView()
    
    let tapAlertAction = PublishRelay<AlertAction>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        let alertSheetForSorting = listView.headerView.tapSortButton
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .dateTime, .cancel], style: .actionSheet)
            }
        
        alertSheetForSorting
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: tapAlertAction)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        navigationItem.title = "다음 블로그 검색"
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        [searchBar, listView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MainViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, dateTime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .dateTime:
                return "DateTime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .dateTime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlertController<Action: AlertActionConvertible>(_ alertContoller: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable
            .create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertContoller.addAction(
                        UIAlertAction(
                            title: action.title,
                            style: action.style,
                            handler: { _ in
                                observer.onNext(action)
                                observer.onCompleted()
                            })
                    )
                }
                self.present(alertContoller, animated: true, completion: nil)
                
                return Disposables.create {
                    alertContoller.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
