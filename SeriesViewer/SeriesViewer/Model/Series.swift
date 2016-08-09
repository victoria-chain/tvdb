//
//  Series.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/8/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import Foundation
import RealmSwift

class Series: Object {
    
    // MARK: - Properties
    dynamic var id = 0
    dynamic var lastUpdated = 0
    dynamic var isFavorite = false
    
    // MARK: - Initialization
    convenience init(id: Int, lastUpdated: Int){
        self.init()
        
        self.id = id
        self.lastUpdated = lastUpdated
    }
    
    // MARK: - Methods
    override static func primaryKey() -> String {
        return "id"
    }
    
}
