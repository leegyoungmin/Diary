//
//  DiaryListCellViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class DiaryListCellViewModel {
    @Published var title: String?
    @Published var body: String?
    @Published var createdDate: String?
    
    init(diary: Diary?) {
        self.title = diary?.title
        self.body = diary?.body
        self.createdDate = Date(timeIntervalSince1970: TimeInterval(diary?.createDate ?? .zero)).formatted()
    }
}
