Pod::Spec.new do |spec|

  spec.name         = "TwitterSignIn"
  spec.version      = "1.0.0"
  spec.summary      = "Let Twitter users into your apps quickly and easily by using inner browser or twitter app."

  spec.description  = <<-DESC
                      It is interface to the Twitter API, the sign-in process is lightly and clearly.
                      No dependencies, framework file is tiny.
                      Supports iOS 12+.
                      DESC

  spec.homepage     = "https://github.com/jammy-huang/TwitterSignIn-iOS"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = "jammy.huang"

  spec.platform     = :ios, "12.0"

  spec.source       = {
    http: "https://github.com/jammy-huang/TwitterSignIn-iOS/releases/download/#{spec.version}/TwitterSignIn.framework.zip",
    sha1: 'f54485422073ae7bf9e31c55711b4476062ee257'
  }

  spec.vendored_frameworks = 'TwitterSignIn.framework'

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
