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
    
    init(diary: Diary? = nil) {
        if let diary = diary {
            self.title = diary.title
            self.body = diary.body
            self.date = Date(timeIntervalSince1970: TimeInterval(diary.createDate))
        }
    }
}
