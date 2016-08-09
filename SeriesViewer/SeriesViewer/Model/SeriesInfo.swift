//
//  SeriesInfo.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/9/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import Foundation
import RealmSwift

class SeriesInfo: Object {
    
    // MARK: - Properties
    dynamic var id = 0
    dynamic var seriesName: String? = nil
    
    // MARK: - Initialization
    convenience init(id: Int, seriesName: String){
        self.init()
        
        self.id = id
        self.seriesName = seriesName
    }
    
    // MARK: - Methods
    override static func primaryKey() -> String {
        return "id"
    }
}
