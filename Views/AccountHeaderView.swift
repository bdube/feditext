// Copyright © 2020 Metabolist. All rights reserved.

import Kingfisher
import UIKit
import ViewModels

class AccountHeaderView: UIView {
    let headerImageView = UIImageView()
    let noteTextView = TouchFallthroughTextView()
    let segmentedControl = UISegmentedControl()

    var viewModel: AccountStatusesViewModel? {
        didSet {
            if let accountViewModel = viewModel?.accountViewModel {
                headerImageView.kf.setImage(with: accountViewModel.headerURL)

                let noteFont = UIFont.preferredFont(forTextStyle: .callout)
                let mutableNote = NSMutableAttributedString(attributedString: accountViewModel.note)
                let noteRange = NSRange(location: 0, length: mutableNote.length)
                mutableNote.removeAttribute(.font, range: noteRange)
                mutableNote.addAttributes(
                    [.font: noteFont as Any,
                     .foregroundColor: UIColor.label],
                    range: noteRange)
                mutableNote.insert(emoji: accountViewModel.emoji, view: noteTextView)
                mutableNote.resizeAttachments(toLineHeight: noteFont.lineHeight)
                noteTextView.attributedText = mutableNote
                noteTextView.isHidden = false
            } else {
                noteTextView.isHidden = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializationActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AccountHeaderView {
    func initializationActions() {
        let baseStackView = UIStackView()

        addSubview(headerImageView)
        addSubview(baseStackView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical

        noteTextView.isScrollEnabled = false
        baseStackView.addArrangedSubview(noteTextView)

        for (index, collection) in AccountStatusCollection.allCases.enumerated() {
            segmentedControl.insertSegment(
                action: UIAction(title: collection.title) { [weak self] _ in
                    self?.viewModel?.collection = collection
                    self?.viewModel?.request()
                },
                at: index,
                animated: false)
        }

        segmentedControl.selectedSegmentIndex = 0

        baseStackView.addArrangedSubview(segmentedControl)

        let headerImageAspectRatioConstraint = headerImageView.heightAnchor.constraint(
            equalTo: headerImageView.widthAnchor,
            multiplier: 9 / 16)

        headerImageAspectRatioConstraint.priority = .init(999)

        NSLayoutConstraint.activate([
            headerImageAspectRatioConstraint,
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseStackView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
