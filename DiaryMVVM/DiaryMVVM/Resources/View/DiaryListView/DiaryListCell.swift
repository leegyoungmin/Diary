//
//  DiaryListCell.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class DiaryListCellContentView: UIView, UIContentView {
    private var appliedConfiguration: DiaryContentConfiguration?
    var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration ?? DiaryContentConfiguration(diary: nil)
        }
        
        set {
            guard let newConfiguration = newValue as? DiaryContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private var viewModel: DiaryListCellViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(configuration: DiaryContentConfiguration) {
        self.viewModel = DiaryListCellViewModel(diary: configuration.diary)
        super.init(frame: .zero)
        apply(configuration: configuration)
        
        configureUI()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(configuration: DiaryContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        
        appliedConfiguration = configuration
        self.viewModel = DiaryListCellViewModel(diary: appliedConfiguration?.diary)
    }
    
    private func bind() {
        viewModel.$title
            .sink { self.headerLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$body
            .sink { self.bodyLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$createdDate
            .sink { self.dateLabel.text = $0 }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        let innerStackView = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
        innerStackView.alignment = .leading
        innerStackView.distribution = .fillProportionally
        innerStackView.spacing = 8
        
        let totalStackView = UIStackView(arrangedSubviews: [headerLabel, innerStackView])
        totalStackView.axis = .vertical
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(totalStackView)
        
        let margin = layoutMarginsGuide.snp
        
        totalStackView.snp.makeConstraints {
            $0.leading.equalTo(margin.leading)
            $0.top.equalTo(margin.top)
            $0.trailing.equalTo(margin.trailing)
            $0.bottom.equalTo(margin.bottom)
        }
    }
}

struct DiaryContentConfiguration: UIContentConfiguration, Hashable {
    var diary: Diary?
    
    func makeContentView() -> UIView & UIContentView {
        return DiaryListCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> DiaryContentConfiguration {
        return self
    }
}

final class DiaryListCell: UITableViewCell {
    static let identifier = String(describing: DiaryListCell.self)
    private var diary: Diary? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = DiaryContentConfiguration().updated(for: state)
        content.diary = diary
        
        contentConfiguration = content
    }
    
    func setDiary(with diary: Diary) {
        self.diary = diary
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        diary = nil
        contentConfiguration = nil
    }
}
