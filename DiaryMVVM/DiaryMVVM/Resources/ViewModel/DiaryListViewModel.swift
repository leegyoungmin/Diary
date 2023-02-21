//
//  DiaryListViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class DiaryListViewModel {
    @Published var diaries: [Int] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        diaries.append(contentsOf: 0...10)
    }
}
