//
//  StoryParam.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation

struct StoryParam {
    var page, size, location: Int
    
    init(page: Int = 0, size: Int = 5, location: Int = 0) {
        self.page = page
        self.size = size
        self.location = location
    }
}
