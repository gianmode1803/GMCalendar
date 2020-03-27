# GMCalendar

If you like this pod, please give me a ★ at the top right of the page!


![Swift](https://github.com/gianmode1803/GMDCalendar/workflows/Swift/badge.svg?branch=master)
[![License](https://img.shields.io/cocoapods/l/GMCalendar.svg?style=flat)](https://cocoapods.org/pods/GMCalendar)

## Overview

GMCalendar is a customizable Calendar Pod written in swift that can help if you need to use a simple and easy Calendar on Swift. This is the first version and it will have some new features very soon!.

- You can implement it in a storyboard or coding few lines.
- It have 7 different animations for now.
- It supports different sizes
- It will have few new features and animations very soon!

Check out the example if you whant to see it in action

### Preview Samples

| Rotation and zoom | Zoom | Rotation | Other |
| --- | --- | --- | --- |
| ![](https://media.giphy.com/media/cMPDjexkyPYmLLbnBO/giphy.gif) | ![](https://media.giphy.com/media/cMceTYWmeSoAtfbKUs/giphy.gif) | ![](https://media.giphy.com/media/lOmUn4SwToI788FlDu/giphy.gif) | ![](https://media.giphy.com/media/hsDV1x9SqPXuQTsFdU/giphy.gif) |


Please, Let me know if you find any problem with it.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.
- iOS 13 or higher.

## Installation

To integrate GMCalendar into your Xcode project using CocoaPods, you have to specify it in your  `Podfile` :

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

pod 'GMCalendar'
```

Then, run the following command: 

```bash
$ pod install
```

## Usage

### Code-less Implementation

1. Create a View in the View Controller you want the calendar, and then change the class to GMCalendar

![](https://user-images.githubusercontent.com/22319734/75457716-179a6580-597d-11ea-9fb3-5363784517f8.png)

2. Run de App xP

![](https://user-images.githubusercontent.com/22319734/75457990-719b2b00-597d-11ea-8583-d50cc08ce8eb.png)

*NOTE: You only can modify the animation you want in code*

### Code implementation

1. Import GMCalendar

```swift
import GMCalendar
```
2. Create a View of class GMCalendar and then add it as subview

```swift

override func viewDidLoad() {
    super.viewDidLoad()
    
    let calendarView: GMCalendar = GMCalendar(frame: CGRect(x: 20, y: 100, width: 360, height: 360))
    self.view.addSubview(calendarView)   
}

```

3. Run de App xP

![](https://user-images.githubusercontent.com/22319734/75457990-719b2b00-597d-11ea-8583-d50cc08ce8eb.png)


## Customization

GMCalendar supports the following modification in code:

```swift

@IBInspectable var monthNameVisible: Bool = true
@IBInspectable var borderColor: UIColor = .clear
@IBInspectable var borderWidth: CGFloat = 0
@IBInspectable var cornerRadius: CGFloat = 0
@IBInspectable var task1Color: UIColor = .blue
@IBInspectable var task2Color: UIColor = .red

@IBInspectable var arrowsAvailable: Bool = true
@IBInspectable var rightArrowImage: UIImage? = UIImage(named: "right_arrow")
@IBInspectable var leftArrowImage: UIImage? = UIImage(named: "left_arrow")

@IBInspectable var verticalSwipe: Bool = true
@IBInspectable var horizontalSwipe: Bool = true

@IBInspectable var animation: Bool = true
@IBInspectable var animationDuration: TimeInterval = 0.5

@IBInspectable var colorForDaySelected: UIColor = .red

@IBInspectable var widthForView: CGFloat = 360//260
@IBInspectable var heightForView: CGFloat = 360//300

@IBInspectable public var showWeekends: Bool = false

@IBInspectable public var showCurrentDaySelected: Bool = true

```
or in the storyBoard:

![](https://user-images.githubusercontent.com/22319734/75459414-9c867e80-597f-11ea-9941-0e2423b44e66.png)

You can disable days and create days with tasks, you just have to use those properties 

```swift

var notAvailableDays: [DayModel]

var daysWithTasks: [DayModel]

```
with DayModel

```swift

struct DayModel{
    var day: Int
    var month: Int
    var year: Int
    var task1: Bool
    var task1Description: String
    var task2: Bool
    var task2Description: String
}

```
```swift

var notAvailableDays: [DayModel] = [
    DayModel(day: 1, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 2, month: 3, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 3, month: 3, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2")]

var daysWithTasks: [DayModel] = [
    DayModel(day: 1, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 5, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 7, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 12, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 13, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 20, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: true, task2Description: "Prueba 2"),
    DayModel(day: 23, month: 2, year: 2020, task1: true, task1Description: "Prueba", task2: false, task2Description: "Prueba 2")]

```
![](https://user-images.githubusercontent.com/22319734/75530073-f3d62e80-5a13-11ea-9aa8-0ec1cfc2ddc2.png)

*NOTE: In the current version (2.0) you can hide weekends if you want*

## Author

Gianpiero Mode
Tw: @GianMode
Linkedln: www.linkedin.com/in/gianpiero-mode-a001b6a7

## License

GMCalendar is available under the MIT license. See the LICENSE file for more info.
