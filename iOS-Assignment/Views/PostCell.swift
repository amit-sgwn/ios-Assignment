//
//  PostCell.swift
//  iOS-Assignment
//
//  Created by Amit Kumar on 02/05/24.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    

    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.backgroundColor = UIColor.lightGreen // Set background color
        stackView.layer.cornerRadius = 8 // Set corner radius
        stackView.layer.borderWidth = 1 // Set border width
        stackView.layer.borderColor = UIColor.darkGreen.cgColor // Set border color
        return stackView
    }()

    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)

        label.textAlignment = .center
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightLabel)
        
        // Set constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20) // Adjust the constant as needed
        ])
        
        // Set constraints for subtitleLabel
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // Adjust the constant as needed
        ])
        
        // Set constraints for stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // Adjust the constant as needed
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Set width constraint for leftLabel to extend out of screen
        leftLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - 40).isActive = true
        
        // Set width constraint for rightLabel to extend out of screen
        rightLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - 40).isActive = true
        
        // Set vertical padding between stackView's arranged subviews
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func configurePlaceholder() {
          // Hide stackView and clear label texts
          titleLabel.text = "Loading..."
          subtitleLabel.text = ""
          leftLabel.text = "Calculating ..."
          rightLabel.text = ""
      }
      

    func configure(with processedPost: ProcessedPost, title: String, subtitle: String ) {
      
        titleLabel.text = title
        subtitleLabel.text = subtitle
        leftLabel.text = processedPost.title
        rightLabel.text = "ID: \(processedPost.id)"
    }
    
    func calculateCellHeight(for post: Post, processing: Bool) -> CGFloat {
           // Calculate height based on the content and processing status
           var height: CGFloat = 0
           
           // Calculate height for titleLabel and subtitleLabel based on content
           let titleLabelWidth = UIScreen.main.bounds.width - 40 // Width of titleLabel
           let titleLabelHeight = getHeight(for: post.title, width: titleLabelWidth, font: UIFont.systemFont(ofSize: 16))
           
           let subtitleLabelWidth = UIScreen.main.bounds.width - 40 // Width of subtitleLabel
           let subtitleLabelHeight = getHeight(for: post.body, width: subtitleLabelWidth, font: UIFont.systemFont(ofSize: 14))
           
           height += 20 // Top padding
           
           height += titleLabelHeight // Height of titleLabel
           
           height += 20 // Padding between titleLabel and subtitleLabel
           
           height += subtitleLabelHeight // Height of subtitleLabel
           
           height += 20 // Padding between subtitleLabel and stackView
           
           // Calculate height for stackView based on its content
           if !processing {
               // StackView is visible, calculate its height
               let leftLabelHeight: CGFloat = 20 // Initial guess for the left label height
             
               let stackViewHeight = leftLabelHeight  + 20 // Total height of stackView including spacing
               height += stackViewHeight
           }
           
 
           // Return the total height
           return height
       }
       
       func getHeight(for text: String, width: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
           let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
           return ceil(boundingBox.height)
       }
    
   

}


// Custom color definitions
extension UIColor {
    static let lightGreen = UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1.0)
    static let darkGreen = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1.0)
}
