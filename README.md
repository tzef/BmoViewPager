![BMO ViewPager](https://user-images.githubusercontent.com/3096210/29925792-1515c356-8e94-11e7-8a10-a166029ca9ad.png)

[![CI Status](http://img.shields.io/travis/LEE%20ZHE%20YU/BmoViewPager.svg?style=flat)](https://travis-ci.org/LEE%20ZHE%20YU/BmoViewPager)
[![Version](https://img.shields.io/cocoapods/v/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)
[![License](https://img.shields.io/cocoapods/l/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)
[![Platform](https://img.shields.io/cocoapods/p/BmoViewPager.svg?style=flat)](http://cocoapods.org/pods/BmoViewPager)

#### ⚠️ **The latest version for Swift 3.2 is 3.2.0** ⚠️  (Not Maintained)
#### ⚠️ **The latest version for Swift 4.0 is 4.1.3** ⚠️ 
#### ⚠️ **The latest version for Swift 4.2 is 4.2.2** ⚠️ 

## 4.1.0 Migrating to 4.2.0
Syntax renaming : `NSAttributedStringKey` to `NSAttributedString.Key`

## 3.2.0 to 4.1.0 Migration
Fix error spelling : `interporation` to `interpolation`, if you have access this variable, please change the naming

## About
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
func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
    return [
        NSAttributedString.Key.foregroundColor : UIColor.lightGray,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)
    ]
}
```
```swift
func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
    return [
        NSAttributedString.Key.foregroundColor : UIColor.red,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)
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
#### Support Right-to-Left (RTL) User Interface
#### Support Vertical and Horizontal direction scroll
#### BmoNavigationBar Auto Focus (Default is true)
#### BmoNavigationBar Title can set normal and highlighted attributed style
#### BmoViewPager infinitScroll (Default is false)
#### BmoViewPager presentedPageIndex can programmatically assign the present page
#### Custom NavigationBar animation, you can get scroll progress from BmoViewPagerDelegate
#### Navigation bar interpolation animation when change viewPager page by tap navigationItem

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

## Popular Issue

### How to animate changing pages on BmoViewPager ?
There is a property `isInterpolationAnimated` in `BmoViewPager` and `BmoViewPagerNavigationBar`, default value both true.
Most importantly, If you want to have scroll animation every time, the pageViewController need be initialed before BmoViewPagerDataSource ask it. and told `BmoViewPager` the reference by `public func setReferencePageViewController(_ vc: UIViewController, at page: Int)`

For example, I always keep the UIViewController of previous page, current page and next page in a dictionary `cachedPageViewControllers`
```swift
var cachedPageViewControllers = [Int: UIViewController]()
func bmoViewPagerDelegate(_ viewPager: BmoViewPager, didAppear viewController: UIViewController, page: Int) {
    switch page {
    case 0:
        self.prepareCachedPageViewControllers(pages: [pageCount - 1, page, page + 1])
    case 1..<(pageCount - 1):
        self.prepareCachedPageViewControllers(pages: [page - 1, page, page + 1])
    case pageCount - 1:
        self.prepareCachedPageViewControllers(pages: [page - 1, page, 0])
    default:
        break
    }
}
func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
    if let cacheVC = cachedPageViewControllers[page] {
        return cacheVC
    } else {
        let vc = createPageViewController(page)
        viewPager.setReferencePageViewController(vc, at: page)
        cachedPageViewControllers[page] = vc
        return vc
    }
}
private func prepareCachedPageViewControllers(pages: [Int]) {
    cachedPageViewControllers.forEach({ (key, vc) in
        if !pages.contains(key) {
            cachedPageViewControllers[key] = nil
        }
    })
    pages.forEach { (page) in
        if cachedPageViewController[page] == nil {
            let vc = createPageViewController(page)
            viewPager.setReferencePageViewController(vc, at: page)
            cachedPageViewControllers[page] = vc
        }
    }
}
private func createPageViewController(_ page: Int) -> UIViewController {
    //TODO: return your own UIViewController
}
```


### Be sure to return different UIViewController for every page
Because `BmoViewPager` is based on `UIPageViewController`, and when the scroll view scroll to edge, it will ask `UIPageViewControllerDataSource` to get the next and the previous page. 
At the same time, `BmoViewPager` save the view controller and page number in the view controller's view, it will let the this page view controller has wrong property.

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
