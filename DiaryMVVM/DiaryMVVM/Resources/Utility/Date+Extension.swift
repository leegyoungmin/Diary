//
//  Date+Extension.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func formatted() -> String {
        Self.formatter.locale = .current
        Self.formatter.dateStyle = .medium
        Self.formatter.timeStyle = .none
        
        return Self.formatter.string(from: self)
    }
}
