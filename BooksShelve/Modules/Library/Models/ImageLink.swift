//
//  ImageLink.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 18/04/24.
//

import SwiftUI

struct ImageLink: Decodable, Hashable {
    var smallThumbnail: String?
    var thumbnail: String?
    
    enum CodingKeys: CodingKey {
        case smallThumbnail
        case thumbnail
    }
    
    init(smallThumbnail: String? = nil, thumbnail: String? = nil) {
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
    }
    
    init?(thumbnail: String?) {
        guard let thumbnail else {
            return nil
        }
        self.thumbnail = thumbnail
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.smallThumbnail = try container.decodeIfPresent(String.self, forKey: .smallThumbnail)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)?.replacingOccurrences(of: "zoom=1", with: "zoom=10")
    }
}
