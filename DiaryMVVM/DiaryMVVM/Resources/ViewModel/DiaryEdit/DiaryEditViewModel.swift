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
    @Published var date: String = ""
    var isShowMenuButton: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($title, $body)
            .map { return ($0.0.isEmpty == false) || ($0.1.isEmpty == false) }
            .eraseToAnyPublisher()
    }
    
    private let coreDataRepository: DiaryCoreDataRepository
    
    init(diary: Diary? = nil, coreDataRepository: DiaryCoreDataRepository) {
        self.coreDataRepository = coreDataRepository
        
        guard let diary = diary else {
            self.id = UUID()
            self.date = Date().formatted()
            return
        }
        
        self.id = diary.id
        self.title = diary.title
        self.body = diary.body
        self.date = Date(timeIntervalSince1970: TimeInterval(diary.createDate)).formatted()
    }
    
    func saveData() {
        let diary = Diary(
            id: id,
            title: title,
            body: body,
            createDate: Int(date.formatted().timeIntervalSince1970)
        )
        coreDataRepository.writeData(with: diary)
    }
}
