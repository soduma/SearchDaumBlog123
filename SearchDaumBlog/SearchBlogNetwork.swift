//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by 장기화 on 2022/01/04.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invaildURL
    case invaildJSON
    case networkError
}

class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DaumKakaoBlog, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invaildURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK c6ab091431a8742e5d4cbc27adb73499", forHTTPHeaderField: "StringAuthorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DaumKakaoBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invaildJSON)
                }
            }
            .catch { _ in
            .just(.failure(.networkError))
            }
            .asSingle()
    }
}
