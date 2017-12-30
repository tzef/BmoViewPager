![BMO ViewPager](https://user-images.githubusercontent.com/3096210/29925792-1515c356-8e94-11e7-8a10-a166029ca9ad.png)

[![CI Status](http://img.shields.io/travis/LEE%20ZHE%20YU/BmoViewPager.svg?style=flat)](https://travis-ci.org/LEE%20ZHE%20YU/BmoViewPager)
[![Version](https://img.shields.io/cocoapods/v/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)
[![License](https://img.shields.io/cocoapods/l/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)
[![Platform](https://img.shields.io/cocoapods/p/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)

#### ⚠️ **The latest version for Swift 3.2 is 3.2.0** ⚠️ 
#### ⚠️ **The latest version for Swift 4.0 is 4.0.4** ⚠️ 

A ViewPager with NavigationBar component based on UIPageViewController and UICollectionView, which is a convenience way to supply and manager each viewController.

I want to make UIPageViewController more intuitive for using it, like UITableView, and supply a navigationBar quickly and simply.

More importantly, when UIPageViewController scroll continuously, pageControl sometimes will get wrong index, this viewPager can help you solve it.

There are some standard dataSource and delegate implemented for generating each page and navigationBar, each of these classes  have simple sample code showing in the Pod Example for BmoViewPager.

<table>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/3096210/28247883-87625632-6a6c-11e7-8179-5c5ae6769a8a.PNG"></td>
    <td><img src="https://user-images.githubusercontent.com/3096210/28247886-8e348296-6a6c-11e7-8b45-037a5fa4a4df.PNG"></td> 
  </tr>
</table>

## Simple Usage
#### Create a UIView extend BmoViewPager
#### Implement BmoViewPagerDataSource
give page count and each page controller, just like using tableView
```swift
func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
    return YourPageCount
}
func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
    return YourPageViewController
}
```

## With a NavigationBar
#### Create a UIView extend BmoViewPagerNavigationBar
#### Assign a BmoViewPager to the BmoViewPagerNavigationBar
using default style, only need to give the each page title
```swift
func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
    return YourPageTitleString
}
```

navigation item title can custom attributed
```swift
func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
    return [
        NSAttributedStringKey.foregroundColor : UIColor.lightGray,
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14.0)
    ]
}
```
```swift
func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedStringKey : Any]? {
    return [
        NSAttributedStringKey.foregroundColor : UIColor.red,
        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14.0)
    ]
}
```

if you don't want use default style, you can custom your own background view and highlighted background view

<table>
  <tr>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248786-fe5020a2-6a7c-11e7-9688-d43a6a0a77f2.gif" width="300">
    </td>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248788-06deb0c6-6a7d-11e7-8d7f-27840040aaf3.gif" width="300">
    </td> 
  </tr>
</table>

## Advanced Usage
#### Support Vertical and Horizontal direction scroll
#### BmoNavigationBar Auto Focus (Default is true)
#### BmoNavigationBar Title can set normal and highlighted attributed style
#### BmoViewPager infinitScroll (Default is false)
#### BmoViewPager presentedPageIndex can programmatically assign the present page
#### Custom NavigationBar animation, you can get scroll progress from BmoViewPagerDelegate
#### Navigation bar interporation animation when change viewPager page by tap navigationItem

<table>
  <tr>
    <th>InfiniteScroll</th>
    <th>Custom NavigationBar animation</th>
  </tr>
  <tr>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248792-0c8caf64-6a7d-11e7-9e99-9558967efe4b.gif" width="300">
    </td>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248795-12809df4-6a7d-11e7-98f9-4c7d9f397ef1.gif" width="300">
    </td>
  </tr>
</table>

## PageControl Optimized
native pageController have a default pageControl if you implement the 
`func presentationCount(for pageViewController: UIPageViewController) -> Int` and 
`func presentationIndex(for pageViewController: UIPageViewController) -> Int`
but sometimes the index have a little bug, if you feel the way too, hope it help you

<table>
  <tr>
    <th>Native PageController continuously scroll</th>
    <th>continuously scroll using bmoViewPager</th>
  </tr>
  <tr>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248798-16b09960-6a7d-11e7-971c-e2dc8f670735.gif" width="300">
    </td>
    <td>
<img src="https://user-images.githubusercontent.com/3096210/28248799-1b0b9050-6a7d-11e7-9dfd-160c09477c82.gif" width="300">
    </td>
  </tr>
</table>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+ 
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 1.1.0+ is required to build BmoViewPager 4.0.0+.

To integrate BmoViewPager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target '<Your Target Name>' do
    pod 'BmoViewPager', '~> 4.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use the dependency managers, you can integrate BmoViewPager into your project manually, just copy the BmoViewPager folder into your project.

## Author

LEE ZHE YU, tzef8220@gmail.com

## License

BmoViewPager is available under the MIT license. See the LICENSE file for more info.
