//
//  String+Extension.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension String {
    func formatted() -> Date {
        let formatter = Date.formatter
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.date(from: self) ?? Date()
    }
}
