Pod::Spec.new do |spec|

  spec.name         = "AllegoryIdentifiable"
  spec.version      = "0.0.1"
  spec.summary      = "Identifiable"
  spec.description  = <<-DESC
        Identifiable used for Allegory
  DESC

  spec.homepage     = "https://github.com/mgray88/Allegory"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Mike Gray" => "mgray88@gmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/mgray88/Allegory.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/Identifiable/*.swift"
  spec.swift_versions = "5.4"

end
