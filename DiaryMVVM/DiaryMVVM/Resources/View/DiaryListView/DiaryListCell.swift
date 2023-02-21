//
//  DiaryListCell.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class DiaryListCellContentView: UIView, UIContentView {
    private var appliedConfiguration: DiaryContentConfiguration?
    var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration ?? DiaryContentConfiguration()
        }
        
        set {
            guard let newConfiguration = newValue as? DiaryContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: DiaryContentConfiguration) {
        super.init(frame: .zero)
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(configuration: DiaryContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        
        appliedConfiguration = configuration
    }
}

struct DiaryContentConfiguration: UIContentConfiguration, Hashable {
    func makeContentView() -> UIView & UIContentView {
        return DiaryListCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> DiaryContentConfiguration {
        return self
    }
}

final class DiaryListCell: UITableViewCell {
    static let identifier = String(describing: DiaryListCell.self)
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = DiaryContentConfiguration().updated(for: state)
        
        contentConfiguration = content
    }
}
