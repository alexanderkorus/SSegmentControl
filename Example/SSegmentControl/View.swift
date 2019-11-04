//
//  View.swift
//  SSegmentControl_Example
//
//  Created by Alexander Korus on 01.11.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import SnapKit
import SSegmentControl

class View: UIView {

    // MARK: - Subviews
    let followerCount: CounterSegment = {
        let view = CounterSegment()
        view.count = 1000
        view.title = "Follower"
        return view
    }()

    let followingCount: CounterSegment = {
        let view = CounterSegment()
        view.count = 500
        view.title = "Following"
        return view
    }()

    let label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Posts"
        return label
    }()

    let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Nothing"
        return label
    }()

    lazy var segmentControl: SSegmentControl = {
        let view: SSegmentControl = SSegmentControl(segments: [
            self.label,
            self.followerCount,
            self.followingCount
        ])
        view.selectorColor = .red
        return view
    }()


    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        // Set Subviews
        for view in [self.segmentControl, self.contentLabel] {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = true
        }

        self.segmentControl.snp.remakeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60.0)
        }

        self.contentLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
