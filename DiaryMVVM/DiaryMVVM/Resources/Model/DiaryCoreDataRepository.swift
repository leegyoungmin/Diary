//
//  CoreDataRepository.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import CoreData

protocol CoreDataService {
    associatedtype Model: Hashable
    associatedtype Entity: NSManagedObject
    
    func createObject(model: Model)
    func updateObject(model: Model, to object: Entity)
    func readData() -> AnyPublisher<[Model], Never>
    func deleteData(model: Model, completion: @escaping (Bool) -> Void)
}

class DiaryCoreDataRepository: CoreDataService {
    typealias Model = Diary
    typealias Entity = DiaryEntity
    
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
        let request = DiaryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", diary.id.uuidString)
        
        guard let result = try? context.fetch(request),
              let object = result.first else {
            createObject(model: diary)
            return
        }
        
        updateObject(model: diary, to: object)
    }
    
    func createObject(model: Diary) {
        let object = DiaryEntity(context: context)
        
        object.id = model.id
        object.title = model.title
        object.body = model.body
        object.createdDate = Date(timeIntervalSince1970: TimeInterval(model.createDate))
        
        save()
    }
    
    func updateObject(model: Diary, to object: Entity) {
        object.id = model.id
        object.title = model.title
        object.body = model.body
        object.createdDate = Date(timeIntervalSince1970: TimeInterval(model.createDate))
        
        save()
    }
    
    func readData() -> AnyPublisher<[Model], Never> {
        let request = Entity.fetchRequest()
        
        guard let objects = try? context.fetch(request) else {
            return Just([]).eraseToAnyPublisher()
        }
        
        return objects
            .publisher
            .compactMap { $0.diary }
            .collect()
            .eraseToAnyPublisher()
    }
    
    func deleteData(model: Diary, completion: @escaping (Bool) -> Void) {
        let request = DiaryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", model.id.uuidString)
        
        guard let objects = try? context.fetch(request) else {
            completion(false)
            return
        }
        objects.forEach(context.delete)
        save()
        
        completion(true)
    }
    
    private func save() {
        if context.hasChanges {
            guard let _ = try? context.save() else { return }
        }
    }
}

private extension DiaryEntity {
    var diary: Diary? {
        guard let id = self.id,
              let title = self.title,
              let body = self.body,
              let createdDate = self.createdDate else {
            return nil
        }
        return Diary(id: id, title: title, body: body, createDate: Int(createdDate.timeIntervalSince1970))
    }
}
