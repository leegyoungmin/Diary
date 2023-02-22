//
//  CoreDataRepository.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import CoreData

protocol CoreDataService {
    func writeData(with diary: Diary)
}

class CoreDataRepository: CoreDataService {
    lazy var persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Un resolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    
    func writeData(with diary: Diary) {
        let object = DiaryEntity(context: context)
        
        object.id = diary.id
        object.title = diary.title
        object.body = diary.body
        object.createdDate = Date(timeIntervalSince1970: TimeInterval(diary.createDate))
        
        guard let _ = try? context.save() else { return }
        readData { _ in }
    }
    
    func readData(completion: @escaping (Diary) -> Void) {
        let request = DiaryEntity.fetchRequest()
        guard let objects = try? context.fetch(request) else {
            return
        }
        
        print(objects.map { $0.title } )
    }
}
