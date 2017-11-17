Pod::Spec.new do |s|
  s.name             = "HeckelDiff"
  s.version          = "0.2.2"
  s.summary          = "Pure Swift implementation of Paul Heckel's \"A Technique for Isolating Differences Between Files\""
  s.description      = "Given two collections, provides a very efficient set of steps to transform one into the other. Adds support for UITableView and UICollectionView batched updates."

  s.homepage         = "https://github.com/mcudich/HeckelDiff"
  s.license          = "MIT"
  s.author           = { "Matias Cudich" => "mcudich@gmail.com" }
  s.source           = { :git => "https://github.com/mcudich/HeckelDiff.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/mcudich"

  s.ios.deployment_target = "8.0"

  s.source_files = "Source/**/*"
end
