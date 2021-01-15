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
	let label1: UILabel = {
		let label: UILabel = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 15.0)
		label.textColor = .lightGray
		label.textAlignment = .center
		label.text = "Posts"
		return label
	}()

	let label0: UILabel = {
		let label: UILabel = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 15.0)
		label.textColor = .black
		label.textAlignment = .center
		label.text = "Posts"
		return label
	}()

    let label3: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = .lightGray
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
            self.label0,
            self.label1,
            self.label3
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
