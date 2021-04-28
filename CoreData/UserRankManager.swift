//
//  UserRankManager.swift
//  Game1to50
//
//  Created by Steven Lin on 2020/5/21.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import Foundation
import CoreData

class UserRankManager {
    static let shared = UserRankManager()
    
    //新增資料
    func add(name: String, time: Int, date: String, level: String) {
        if let entity = NSEntityDescription.entity(forEntityName: "Rank", in: CoreDataManager.shared.persistentContainer.viewContext) {
            let rank = Rank(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
            rank.time = Int64(time)
            rank.name = name
            rank.date = date
            rank.level = level
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    //查詢資料
    func fetchAll() -> [Rank]? {
        let request: NSFetchRequest<Rank> = Rank.fetchRequest()
        do {
            let rank = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
            return rank
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //刪除特定資料
    func delete(rank: Rank) {
        CoreDataManager.shared.persistentContainer.viewContext.delete(rank)
        CoreDataManager.shared.saveContext()
    }
    
    //編輯資料
    func edit(rank: Rank, name: String, time: Int, date: String, level: String) {
        rank.name = name
        rank.time = Int64(time)
        rank.date = date
        rank.level = level
        CoreDataManager.shared.saveContext()
    }
}
