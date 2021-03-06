Pod::Spec.new do |spec|

  spec.name         = "Allegory"
  spec.version      = "0.0.2"
  spec.summary      = "SwiftUI with UIKit"
  spec.description  = <<-DESC
  Brief reimplementation of SwiftUI using UIKit under the hood to bring
  declarative UI to iOS 10+. Aids in the transition to SwiftUI by
  encouraging writing declarative code vs. imperative.
                   DESC

  spec.homepage     = "https://github.com/mgray88/Allegory"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Mike Gray" => "mgray88@gmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/mgray88/Allegory.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/Allegory/**/*.swift"
  spec.swift_versions = "5.4"

  spec.dependency "AllegoryIdentifiable"
  spec.dependency "RxSwift", "~> 6.0"
  spec.dependency "Runtime"

end
