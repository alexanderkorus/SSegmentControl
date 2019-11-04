# SSegmentControl

[![CI Status](https://img.shields.io/travis/alexanderkorus/SSegmentControl.svg?style=flat)](https://travis-ci.org/alexanderkorus/SSegmentControl)
[![Version](https://img.shields.io/cocoapods/v/SSegmentControl.svg?style=flat)](https://cocoapods.org/pods/SSegmentControl)
[![License](https://img.shields.io/cocoapods/l/SSegmentControl.svg?style=flat)](https://cocoapods.org/pods/SSegmentControl)
[![Platform](https://img.shields.io/cocoapods/p/SSegmentControl.svg?style=flat)](https://cocoapods.org/pods/SSegmentControl)

Simple SegmentControl for custom UIView Segments. Segments can be passed as UIViews, so theres
no UI limitations for the single segments.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Preview](https://raw.githubusercontent.com/alexanderkorus/SSegmentControl/master/ssegmentcontrol.gif)

## Requirements

* Swift 5.0
* SnapKit 5.0

## Installation

SSegmentControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SSegmentControl'
```

## Basic usage 

```swift
// Define views to pass it as segments to segmentControl
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

// Create segmentControl and pass the created views to it.
lazy var segmentControl: SSegmentControl = {
    let view: SSegmentControl = SSegmentControl(segments: [
        self.label,
        self.followerCount,
        self.followingCount
    ])
    // Configure appearance of segmentControl
    view.selectorColor = .red
    view.isShadowHidden = true
    return view
}()


// Add change listener closure anywhere in your ViewController
self.segmentControl.segmentDidChanged = { index, view in
    // React on changes 
    self.contentLabel.text = "Selected segment: \(index)"
}
```
### Other Options

Actions 
```swift
segmentControl.move(to: 0)  // Move segment control to passed index
````

Listener
```swift
segmentDidChange: (Int, UIView) -> Void // Called when segment did changed
````

Getter
```swift
segmentControl.selectedViewIndex  // Returns index of selected view
````

You can customize these properties of the segment control:
- `selectorColor` : Color of the selctor view. Default value is `UIColor.red`
- `segmentsBackgroundColor` : Background color of the segments container view. Default value is `.white`
- `isShadowHidden` : Indicates if SegmentControl should throw a shadow. Default value is `true`



## Author

alexanderkorus, alexander.korus@svote.io

## License

SSegmentControl is available under the MIT license. See the LICENSE file for more info.
