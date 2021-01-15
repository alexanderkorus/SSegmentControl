//
//  ViewController.swift
//  SSegmentControl
//
//  Created by alexanderkorus on 11/01/2019.
//  Copyright (c) 2019 alexanderkorus. All rights reserved.
//

import UIKit
import SSegmentControl

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentControl.segmentDidChanged = { index, view in
            self.contentLabel.text = "Selected segment: \(index)"
			for (idx, view) in self.segmentControl.viewStackView.arrangedSubviews.enumerated() {
				guard let label = view as? UILabel else { return }
				if (index == idx) {
					label.textColor = .black
				} else {
					label.textColor = .lightGray
				}
			}
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.segmentControl.move(to: 0)
    }

    override func loadView() {
        self.view = View()
    }

}

// MARK: - Views
private extension ViewController {
    unowned var rootView: View { return self.view as! View }
    unowned var segmentControl: SSegmentControl { return self.rootView.segmentControl }
    unowned var contentLabel: UILabel { return self.rootView.contentLabel }
}


