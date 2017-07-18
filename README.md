# AnyPullBack

A simple Navigation Controller, with transitions to push a View Controller with animation, and to enable swipe right/down/up gestures to pop the current View Controller.

Note: Experimental support for `UIScrollView`s (and all other views based on `UIScrollView`, e.g. `UITableView` and `UIWebView`) is provided, which means all the `UIScrollView`s you are touching should be scrolled left-/top-/bottom-most to trigger swiping right/down/up gestures. All the touched `UIScrollView`s (except those in the `rootViewController`) will be set `bounces = false` to achieve this.

Written in Swift 3.

## Preview

[View video](https://raw.githubusercontent.com/vhyme/AnyPullBack/master/preview.mp4)

## Installation

add `pod 'AnyPullBack'` to your `Podfile`.

## Usage

Use `AnyPullBackNavigationController` any way you like.

## APIs

### All APIs from UINavigationController

... are available.

### `sourceRect`: CGRect

Change this property to determine the rectangle, which the newly pushed `ViewController`s will scale in from.

See also: `pushViewController:fromView:animated:`

### `pullableWidthFromLeft`: CGFloat

Default is `0`. Set the width of the region where swiping right is valid for popping the current `ViewController`. To enable swiping-right gesture all over the screen, set it to `0`.

### `canPullFromLeft` | `canPullFromTop` | `canPullFromBottom`

The main control for the swiping gestures. Default is all `true`.

### `pushViewController:fromView:animated:`

Push a `ViewController` with a custom `UIView` from which the `ViewController` will scale in from.
