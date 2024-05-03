//
//  DetailViewController.swift
//  iOS-Assignment
//
//  Created by Amit Kumar on 03/05/24.
//

import UIKit

class DetailedViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias Callback = (Post, ProcessedPost) -> Void
    
    var post: Post?
    var processedPost: ProcessedPost?
    var callback: Callback?
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var processedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var processedBodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(processedTitleLabel)
        view.addSubview(processedBodyLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        processedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        processedBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            processedTitleLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20),
            processedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            processedTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            processedBodyLabel.topAnchor.constraint(equalTo: processedTitleLabel.bottomAnchor, constant: 20),
            processedBodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            processedBodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
      
    }
    
    // MARK: - UI Update
    
    private func updateUI() {
        if let post = post {
            titleLabel.text = post.title
            bodyLabel.text = post.body
        }
        
        if let processedPost = processedPost {
            processedTitleLabel.text = processedPost.title
            processedBodyLabel.text = "\(processedPost.id)"
        }
    }
    
    // MARK: - Callback
    
    func updatePostsAndInvokeCallback(with updatedPost: Post, updatedProcessedPost: ProcessedPost) {
        post = updatedPost
        processedPost = updatedProcessedPost
        callback?(updatedPost, updatedProcessedPost)
    }
}
