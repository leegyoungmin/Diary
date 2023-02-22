//
//  DiaryListViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class DiaryListViewModel {
    @Published var diaries: [Diary] = []
    private var cancellables = Set<AnyCancellable>()
    let coreDataRepository = DiaryCoreDataRepository()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        coreDataRepository.readData()
            .sink { objects in
                self.diaries = objects
            }
            .store(in: &cancellables)
    }
}
