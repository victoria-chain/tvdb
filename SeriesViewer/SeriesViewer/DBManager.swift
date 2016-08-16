//
//  DBManager.swift
//  
//
//  Created by Victoria Denisyuk on 8/8/16.
//
//

import UIKit
import RealmSwift

class DBManager {
    
    // MARK: - Properties
    private let realm = try? Realm()
    
    func favorites() -> Results<Series>? {
        guard let favorites = realm?.objects(Series) else {
            return nil
        }
        return favorites
    }
    
    static let sharedInstance = DBManager()
    
    // MARK: - Public Methods
    func addToFavorites(repository: Series) {
        do {
            try realm?.commitWrite()
        } catch _ {
        }
    }
    
    func removeFromFavorites(repository: Series) {
        do {
            realm?.beginWrite()
            try realm?.commitWrite()
        } catch _ {
        }
    }
    
    func isFavorited(series: Series) -> Bool {
        guard let item = realm?.objectForPrimaryKey(Series.self, key: series.id) else {
            return false
        }
        
        return item.isFavorite
    }
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(username).realm")
        
        Realm.Configuration.defaultConfiguration = config
    }

}
