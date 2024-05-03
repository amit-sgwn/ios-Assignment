//
//  PostViewModel.swift
//  iOS-Assignment
//
//  Created by Amit Kumar on 02/05/24.
//

import Foundation

class PostsViewModel {
    private let networkService: NetworkServiceProtocol
    private var currentPage = 1
    private var pageLimit = 10
    private var isLoading = false
    private var posts: [Post] = []
    private var processedPosts: [Int: ProcessedPost] = [:]

    var errorOccurred: ((Error) -> Void)?
    var postsUpdated: (() -> Void)?
       
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPosts() {
        guard !isLoading else { return }
        isLoading = true
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&limit=\(pageLimit)")!
        networkService.fetchData(from: url, completion: { [weak self] (result: Result<[Post], Error>) in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let fetchedPosts):
                self.posts.append(contentsOf: fetchedPosts)
                self.postsUpdated?()
                self.currentPage += 1
            case .failure(let error):
                self.errorOccurred?(error)
            }
        })
    }
    
    func numberOfPosts() -> Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post? {
        guard index < posts.count else { return nil }
        return posts[index]
    }
    
    func updateProcessingStatus(for postId: Int, isProcessing: Bool) {
           guard let index = posts.firstIndex(where: { $0.id == postId }) else {
               return // Post with given postId not found
           }
           posts[index].isProcessing = isProcessing
       }
    
    // Function to update processed post for a specific post
    func updateProcessedPost(for postId: Int, with processedPost: ProcessedPost) {
        processedPosts[postId] = processedPost
    }
    
    // Function to get processed post for a specific post
    func processedPost(for postId: Int) -> ProcessedPost? {
        return processedPosts[postId]
    }
    
    func indexOfPost(withID postID: Int) -> Int? {
        return posts.firstIndex { $0.id == postID }
    }
    
}



struct ProcessedPost {
    let id: Int
    let title: String
}
