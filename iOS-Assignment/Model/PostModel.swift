//
//  PostModel.swift
//  iOS-Assignment
//
//  Created by Amit Kumar on 02/05/24.
//

import Foundation

struct Post: Codable, Equatable {
    let id: Int
    let title: String
    let body: String
    var isProcessing: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case isProcessing // Add the isProcessing key
    }
    
    // Implement custom initializer to handle decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        // Use conditional decoding to handle the case when isProcessing key is missing
        isProcessing = (try? container.decode(Bool.self, forKey: .isProcessing)) ?? false
    }
    
    // Implement Equatable protocol
    static func == (lhs: Post, rhs: Post) -> Bool {
        // Implement comparison logic here
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.body == rhs.body
    }
}
