//
//  BlogListView.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class BlogListView: UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    
    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //cellForRowAt
    private func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(rx.items) { tableView, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        separatorStyle = .singleLine
        rowHeight = 100
        tableHeaderView = headerView
    }
}
