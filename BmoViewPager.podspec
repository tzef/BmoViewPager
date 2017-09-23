#
# Be sure to run `pod lib lint BmoViewPager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BmoViewPager'
  s.version          = '3.2.0'
  s.summary          = 'A ViewPager with NavigationBar component based on UIPageViewController and UICollectionView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    BmoViewPager is a ViewPager with NavigationBar component based on UIPageViewController and UICollectionView, which is a convenience way to supply and manager each viewController.
    I want to make UIPageViewController more intuitive for using it, like UITableView, and supply a navigationBar quickly and simply.
    More importantly, when UIPageViewController scroll continuously, pageControl sometimes will get wrong index, this viewPager can help you solve it.
    There are some standard dataSource and delegate implemented for generating each page and navigationBar, each of these classes  have simple sample code showing in the Pod Example for BmoViewPager.
                       DESC

  s.homepage         = 'https://github.com/tzef/BmoViewPager'
  # s.screenshots     = 'https://user-images.githubusercontent.com/3096210/28247883-87625632-6a6c-11e7-8179-5c5ae6769a8a.PNG', 'https://user-images.githubusercontent.com/3096210/28247886-8e348296-6a6c-11e7-8b45-037a5fa4a4df.PNG', 'https://user-images.githubusercontent.com/3096210/28247887-90d1edea-6a6c-11e7-8fb8-0e2b549cbb01.PNG', 'https://user-images.githubusercontent.com/3096210/28247888-924777a8-6a6c-11e7-93ae-4d2b0039b111.PNG'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LEE ZHE YU' => 'tzef8220@gmail.com' }
  s.source           = { :git => 'https://github.com/tzef/BmoViewPager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BmoViewPager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BmoViewPager' => ['BmoViewPager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
