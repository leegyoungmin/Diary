//
//  DiaryAlertDirector.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class DiaryAlertDirector {
    func makeDeleteAlert(builder: AlertBuilder, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        builder
            .setTitle(with: "삭제")
            .setMessage(with: "정말 삭제 하시겠습니까?")
            .setButton(title: "확인", style: .destructive, handler: handler)
            .setButton(title: "취소", style: .cancel, handler: nil)
            .build()
    }
}
