//
//  ViewController.swift
//  iOS-Assignment
//
//  Created by Amit Kumar on 02/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PostsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = PostsViewModel(networkService: NetworkService())
        viewModel.postsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.errorOccurred = { error in
            print("Error: \(error)")
        }
        viewModel.fetchPosts()
        
        }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func didSelectItem(_ post: Post, processedPost: ProcessedPost) {
           // Instantiate the detailed view controller
           let detailedVC = DetailedViewController()
           
           // Pass necessary data to the detailed view controller
           detailedVC.post = post
           detailedVC.processedPost = processedPost
           
           // Set the callback function
           detailedVC.callback = { [weak self] updatedPost, updatedProcessedPost in
               // Only update if the item has actually changed
               if updatedPost != post {
                   // Update the data in the list or perform any other actions
                   // For example:
                    self?.updateItem(post: post, processedPost: processedPost)
               }
           }
           
           // Present the detailed view controller
           navigationController?.pushViewController(detailedVC, animated: true)
       }
    
    func updateItem( post: Post, processedPost: ProcessedPost) {
        
        viewModel.updateProcessedPost(for: post.id, with: processedPost)
        if let postIndex = viewModel.indexOfPost(withID: post.id), postIndex >= 0{
            let indexPath = IndexPath(row: postIndex, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
     }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = viewModel.post(at: indexPath.row)
        
        guard let post = post else {
            return UITableViewCell()
        }
        
        if let cachedProcessedPost = viewModel.processedPost(for: post.id) {
                // Use cached processed data
                cell.configure(with: cachedProcessedPost, title: post.title, subtitle: post.body)
        } else {
            
            cell.configurePlaceholder()
            viewModel.updateProcessingStatus(for: post.id, isProcessing: true)
            performHeavyComputation(for: post) { [weak self] processedPost in
                DispatchQueue.main.async {
                    guard let self = self, let visibleCell = tableView.cellForRow(at: indexPath) as? PostCell else {
                        return
                    }
                    
                    self.viewModel.updateProcessingStatus(for: post.id, isProcessing: false)
                    visibleCell.configure(with: processedPost, title: post.title, subtitle: post.body)
                    self.viewModel.updateProcessedPost(for: post.id, with: processedPost)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfPosts() - 1 {
            viewModel.fetchPosts()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Get the selected post from the viewModel
           guard let post = viewModel.post(at: indexPath.row) else {
               return
           }

        if let processedPost = viewModel.processedPost(for: post.id) {
            
            didSelectItem(post, processedPost: processedPost)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let post = viewModel.post(at: indexPath.row) else {
            return 0.0
        }
        let processing = post.isProcessing
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PostCell else {
            // If cell is not found, return a default height
            return UITableView.automaticDimension
        }
        return cell.calculateCellHeight(for: post, processing: processing)
    }
    
    
}


//Heavy computation task
extension ViewController {
    
    func performHeavyComputation(for post: Post, completion: @escaping (ProcessedPost) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = Date()
            
            // Simulating a heavy computation by manipulating the title
            Thread.sleep(forTimeInterval: 2)
            let endTime = Date()
            let computationTime = endTime.timeIntervalSince(startTime)
            let modifiedTitle = "Time taken at \(computationTime)"
            let processedPost = ProcessedPost(id: post.id, title: modifiedTitle)
            
            DispatchQueue.main.async {
                completion(processedPost)
            }
        }
    }
}
