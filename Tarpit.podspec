Pod::Spec.new do |s|
  s.name         = "Tarpit"
  s.version      = "4.0.0"
  s.summary      = "TAR-file unpacker in swift."
  s.description  = <<-DESC
                   TAR-file unpacker in swift.
                   
                   Unpacks GNU "star" files from stream, file or NSData representations
                   DESC

  s.homepage     = "https://github.com/anfema/Tarpit"
  s.license      = { :type => "BSD", :file => "LICENSE.txt" }
  s.author             = { "Johannes Schriewer" => "j.schriewer@anfe.ma" }
  s.social_media_url   = "http://twitter.com/dunkelstern"

  s.ios.deployment_target = "13.0"
  s.osx.deployment_target = "11.0"
  s.swift_version = '5.5'
  
  s.source       = { :git => "https://github.com/anfema/Tarpit.git", :tag => "4.0.0" }
  s.source_files  = "src/*.swift"  

end
