//
//  DiaryEditViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class DiaryEditViewModel {
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var date: Date = Date()
    
    private let coreDataRepository: CoreDataService
    
    init(diary: Diary? = nil) {
        if let diary = diary {
            self.title = diary.title
            self.body = diary.body
            self.date = Date(timeIntervalSince1970: TimeInterval(diary.createDate))
        }
        
        self.coreDataRepository = CoreDataRepository()
    }
    
    func saveData() {
        let diary = Diary(title: title, body: body, createDate: Int(date.timeIntervalSince1970))
        coreDataRepository.writeData(with: diary)
    }
}
