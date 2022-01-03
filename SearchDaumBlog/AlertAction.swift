//
//  AlertAction.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/03.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
