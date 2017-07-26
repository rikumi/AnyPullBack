# AnyPullBack
[![](https://img.shields.io/cocoapods/v/AnyPullBack.svg)](#)
[![](https://img.shields.io/cocoapods/p/AnyPullBack.svg)](#)
[![](https://img.shields.io/cocoapods/l/AnyPullBack.svg)](#)
[![](https://img.shields.io/github/stars/vhyme/AnyPullBack.svg?style=social&label=Star)](#)

A simple navigation controller with pixel-perfect push animation and pop gesture in any direction you like!

> Note: Experimental support for `UIScrollView`s (and all other views based on `UIScrollView`, e.g. `UITableView` and `UIWebView`) is provided, which means all the `UIScrollView`s you are touching should be scrolled left-/top-/bottom-most to trigger swiping right/down/up gestures. All the touched `UIScrollView`s (except those in the `rootViewController`) will be set `bounces = false` to achieve this.

Written in Swift 3.

## Preview

Run `pod try AnyPullBack`, change the bundle identifier and development team, build the project and run on your phone!

[View video](https://raw.githubusercontent.com/vhyme/AnyPullBack/master/preview.mp4)

## Installation

Add `pod 'AnyPullBack'` to your `Podfile`.

## Usage

Use `AnyPullBackNavigationController` any way you like.

## APIs

- All APIs from UINavigationController are available.

- `defaultPushAnimator`

Set the default animator used by `pushViewController(_:animated:)`. Initialize a `ScaleInAnimator` with a source rect or source view, or a `SwipeInAnimator` with any direction you like.

- `defaultPopAnimator`

Set the default animator used by `popViewController(animated:)`. Initialize a `SwipeOutAnimator` with a direction you like.

- `pullableWidthFromLeft`: CGFloat

Default is `0`. Set the width of the region where swiping right is valid for popping the current `ViewController`. To enable swiping-right gesture all over the screen, set it to `0`.

- `canPullFromLeft` | `canPullFromTop` | `canPullFromBottom`

The main control for the swiping gestures. Default is all `true`.

- `pushViewController(_:fromView:)`

Push a `ViewController` with a temporary `ScaleInAnimator` to provide scale-in animation from a specific view. 

> Note: Compared with `pushViewController(_:fromRect:)`, this method provides smoother transition where the source view fades out rather than being suddenly covered by a white rectangle. 

- `pushViewController(_:fromRect:)`

Push a `ViewController` with a temporary `ScaleInAnimator` to provide scale-in animation from a specific rect.

- `pushViewController(_:inDirection:)`

Push a `ViewController` in a specific direction. Available directions are `.leftFromRight`, `.rightFromLeft`, `.upFromBottom`, `.downFromTop`.

- `popViewController(inDirection:)`

Pop a `ViewController` in a specific direction. Available directions are `.rightFromLeft`, `.leftFromRight`, `.downFromTop`, `.upFromBottom`.

- protocol `AnyPullBackCustomizable`

Extend your UIViewController with `AnyPullBackCustomizable` and specify the method `UIViewController::apb_shouldPull(inDirection:) -> Bool` to customize whether you allow the current view controller to be pulled from a specific direction. The method is called when the user tries to pull from a direction. 

> Note: This method can be called multiple times during a single swipe gesture, until it returns `true` to allow the swiping. Please be careful with this detail.

Example: 

```swift
class ExampleViewController: UIViewController, AnyPullBackCustomizable {
    
    func apb_shouldPull(inDirection direction: SwipeOutDirection) -> Bool {

        // To only enable pulling from left for this view controller
        return direction == .rightFromLeft

        // To disable pull-to-back completely for this view controller
        return false
    }
}
```