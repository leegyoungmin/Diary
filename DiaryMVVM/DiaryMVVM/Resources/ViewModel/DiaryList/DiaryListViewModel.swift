//
//  DiaryListViewModel.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class DiaryListViewModel {
    @Published var diaries: [Diary] = []
    @Published private var reloadData: Bool = false
    private var cancellables = Set<AnyCancellable>()
    let coreDataRepository: DiaryCoreDataRepository
    
    init(coreDataRepository: DiaryCoreDataRepository) {
        self.coreDataRepository = coreDataRepository
        
        $reloadData
            .filter { $0 }
            .sink { [weak self] _ in
                self?.fetchData()
                self?.reloadData = false
            }
            .store(in: &cancellables)
    }
     
    func fetchData() {
        coreDataRepository.readData()
            .sink { self.diaries = $0 }
            .store(in: &cancellables)
    }
    
    func deleteDiary(index: Int) {
        let diary = diaries[index]
        
        coreDataRepository.deleteData(model: diary) { [weak self] isSuccess in
            self?.reloadData = isSuccess
        }
    }
    
    func reloadingData() {
        reloadData = true
    }
}
