//
//  SSegmentControl.swift
//
//
//  Created by Alexander Korus on 25.08.19.
//  Copyright © 2019 Alexander Korus. All rights reserved.
//

import UIKit
import SnapKit

public class SSegmentControl: UIView {

    // MARK: Subviews

    /**
        This stackView contains and order the passed Segments
     */
    let viewStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = UIStackView.Alignment.center
        view.distribution = UIStackView.Distribution.fillEqually
        view.spacing = 0.0
        view.backgroundColor = .white
        return view
    }()

    /**
        This view serves as underlined indicator view for the selected segment
     */
    lazy var selectedSegmentView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = self.selectorColor
        return view
    }()

    let borderView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0 , height:0.0)
        view.isHidden = true
        return view
    }()

    let underlayingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: Stored properties

    /**
        This array contains the segments as UIView which should show ordered in the SegmentControl
     */
    public var segments: [UIView] = [] {
        didSet {
            for (index, segment) in segments.enumerated() {
                self.viewStackView.addArrangedSubview(segment)
                segment.snp.remakeConstraints {
                    $0.height.equalToSuperview()
                }
                segment.tag = index
                segment.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
                segment.addGestureRecognizer(tap)
            }
        }
    }

    /**
        Color of the selector
     */
    public var selectorColor: UIColor = UIColor.red {
        didSet {
            self.selectedSegmentView.backgroundColor = selectorColor
        }
    }

    /**
        Background color of the segments container view
     */
    public var segmentsBackgroundColor: UIColor = UIColor.white {
        didSet {
            self.viewStackView.backgroundColor = segmentsBackgroundColor
            self.underlayingView.backgroundColor = segmentsBackgroundColor
        }
    }

    /**
        Indicates if segmentControl should throw a shadow. Default is true.
     */
    public var isShadowHidden: Bool = true {
        didSet {
            self.underlayingView.isHidden = isShadowHidden
        }
    }

    /**
        Represents the current position  and the selected segment of the selector view
     */
    private var currentIndex: Int = 0 {
        didSet {
            updateSelectorPosition()
            guard self.segments.indices.contains(currentIndex) else { return }
            segmentDidChanged?(currentIndex, self.segments[currentIndex])
        }
    }

    public var segmentDidChanged: ((Int, UIView) -> Void)?
    private var initialSelectedSegmentViewFrame: CGRect?
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pgr = UIPanGestureRecognizer(target: self, action: #selector(SSegmentControl.panned(_:)))
        pgr.delegate = self
        return pgr
    }()

    // MARK: Computed property
    public var selectedViewIndex: Int {
        get {
            return currentIndex
        }
    }

    // MARK: Initializers
    public convenience init(segments: [UIView]) {
        self.init()
        // defer statement is used for executing code just before transferring
        // program control outside of the scope that the statement appears in.
        defer { self.segments = segments }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panGestureRecognizer)
        self.backgroundColor = .white

        [self.borderView, self.underlayingView, self.viewStackView, self.selectedSegmentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }

        self.viewStackView.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(self.selectedSegmentView.snp.top)
        }

        self.underlayingView.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        self.borderView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(4.0)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIView Lifecycle methods
    public override func layoutSubviews() {
        super.layoutSubviews()

        let width: CGFloat = self.frame.size.width / CGFloat(self.segments.count)
        let currentPosition: CGFloat = CGFloat(self.selectedViewIndex) * width

        self.selectedSegmentView.snp.remakeConstraints {
            $0.height.equalTo(4.0)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(width)
            $0.leading.equalTo(currentPosition)
        }

    }


    // MARK: Instance methods
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            self.move(to: view.tag)
        }
    }

    /// Moves the selector to the passed index
    ///
    /// - Parameter index: index of the selected view
    public func move(to index: Int) {
        guard self.segments.indices.contains(index) else { return }
        self.currentIndex = index
    }

    /// Updates the position of the selector corresponding to the selected segment
    private func updateSelectorPosition() {

        let width: CGFloat = self.frame.size.width / CGFloat(self.segments.count)
        let currentPosition: CGFloat = CGFloat(self.selectedViewIndex) * width

        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedSegmentView.snp.updateConstraints {
                $0.leading.equalTo(currentPosition)
            }
            self.layoutIfNeeded()
        })

    }

    // MARK: - Pan Gesture Handler methods

    /// Handles the pan gesture events
    /// - Parameter gestureRecognizer: UIPanGestureRecognizer
    @objc private func panned(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began:
                self.initialSelectedSegmentViewFrame = selectedSegmentView.frame
            case .changed:
                guard let initialFrame = self.initialSelectedSegmentViewFrame
                else { return }
                var frame = initialFrame
                frame.origin.x += gestureRecognizer.translation(in: self).x
                self.selectedSegmentView.frame = frame
            case .ended, .failed, .cancelled:
                if nearestIndex(to: selectedSegmentView.center) != self.currentIndex {
                    move(to: nearestIndex(to: selectedSegmentView.center))
                } else {
                    guard let frame = self.initialSelectedSegmentViewFrame else { return }
                    self.selectedSegmentView.frame = frame
                }
            default: break
        }
    }

    /// Determine the nearest index in the segments of the passed point
    /// - Parameter point: CGPoint
    private func nearestIndex(to point: CGPoint) -> Int {
        let distances = self.segments.map { abs(point.x - $0.center.x) }
        return Int(distances.firstIndex(of: distances.min()!)!)
    }

}

// MARK: - UIGestureRecognizerDelegate Methods
extension SSegmentControl: UIGestureRecognizerDelegate {

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            return self.segments[self.currentIndex].frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
