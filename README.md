# HeckelDiff
[![Swift](https://img.shields.io/badge/swift-3-orange.svg?style=flat)](#)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TemplateKit.svg)](https://img.shields.io/cocoapods/v/TemplateKit)
[![Platform](https://img.shields.io/cocoapods/p/TemplateKit.svg?style=flat)](http://cocoadocs.org/docsets/Alamofire)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

Pure Swift implementation of Paul Heckel's *A Technique for Isolating Differences Between Files*

## Features

This is a simple diff algorithm that provides the minimum set of steps to transform one collection into another. Transformations are listed as discrete operations:
* **Insertion** - what items should be inserted into the array, and at what index.
* **Deletion** - what items should be removed from the array, and at what index.
* **Move** - what items should be moved, and their origin and destination indices.
* **Update** - what items should be updated/replaced with new context, and at what index.

These operations are calculated in **linear** time, using the algorithm described in [this paper](http://dl.acm.org/citation.cfm?id=359467).

Knowing this set of operations is especially handy for efficiently updating **UITableViews** and **UICollectionViews**.

## Example

Consider a simple example that compares lists of integers:
```swift
let o = [1, 2, 3, 3, 4]
let n = [2, 3, 1, 3, 4]
let result = diff(o, n)
// [.move(1, 0), .move(2, 1), .move(0, 2)]

let o = [0, 1, 2, 3, 4, 5, 6, 7, 8]
let n = [0, 2, 3, 4, 7, 6, 9, 5, 10]
let result = diff(o, n)
// [.delete(1), .delete(8), .move(7, 4), .insert(6), .move(5, 7), .insert(8)]
```

`orderedDiff` is also available, which provides a set of operations that are friendly for batched updates in UIKit contexts (note how `move` is replaced by pairs of `insert` and `delete` operations):
```swift
let o = [1, 2, 3, 3, 4]
let n = [2, 3, 1, 3, 4]
let result = orderedDiff(o, n)
// [.delete(2), .delete(1), .delete(0), .insert(0), .insert(1), .insert(2)]
```

## Installation

#### Carthage

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```ogdl
github "mcudich/HeckelDiff"
```

Run `carthage update`, then make sure to add `HeckelDiff.framework` to "Linked Frameworks and Libraries" and "copy-frameworks" Build Phases.

#### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate TemplateKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'HeckelDiff', '~> 0.1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

- iOS 9.3+
- Xcode 8.0+
- Swift 3.0+
