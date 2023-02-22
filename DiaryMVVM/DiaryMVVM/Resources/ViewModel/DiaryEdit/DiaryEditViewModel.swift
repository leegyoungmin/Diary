//
//  DiaryEditViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class DiaryEditViewModel {
    private var id: UUID
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var date: Date = Date()
    
    private let coreDataRepository: DiaryCoreDataRepository
    
    init(diary: Diary? = nil, coreDataRepository: DiaryCoreDataRepository) {
        if let diary = diary {
            self.id = diary.id
            self.title = diary.title
            self.body = diary.body
            self.date = Date(timeIntervalSince1970: TimeInterval(diary.createDate))
        }
        
        self.id = UUID()
        self.coreDataRepository = coreDataRepository
    }
    
    func saveData() {
        let diary = Diary(id: id, title: title, body: body, createDate: Int(date.timeIntervalSince1970))
        coreDataRepository.writeData(with: diary)
    }
}