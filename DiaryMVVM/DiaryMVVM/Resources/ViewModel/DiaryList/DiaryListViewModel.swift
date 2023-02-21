//
//  DiaryListViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class DiaryListViewModel {
    @Published var diaries: [Diary] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        diaries = Diary.mock
    }
}
