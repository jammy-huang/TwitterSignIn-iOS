Pod::Spec.new do |spec|

  spec.name         = "TwitterSignIn"
  spec.version      = "1.1.0"
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

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  spec.source       = {
      http: "https://github.com/jammy-huang/TwitterSignIn-iOS/releases/download/#{spec.version}/Frameworks.zip",
      sha1: '4549a040d06efbae718ab5c6701d96a9631f15a3'
  }

  spec.default_subspecs = 'V2'

  # OAuth 2.0
  spec.subspec 'V2' do |ss|

    ss.vendored_frameworks = 'Frameworks/TwitterSignInV2.framework'

  end

  # OAuth 1.1a
  spec.subspec 'V1' do |ss|

    ss.vendored_frameworks = 'Frameworks/TwitterSignInV1.framework'

  end

end
