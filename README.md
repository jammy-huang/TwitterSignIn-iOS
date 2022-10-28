# Twitter Sign-In for iOS

Let Twitter users into your apps quickly and easily by using inner browser or twitter app.

It is interface to the [Twitter API](https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens), the sign-in process is lightly and clearly.

No dependencies, framework file is tiny.

Supports iOS 12+.

## Getting Started

- Generate your Twitter API keys through the [Twitter developer apps dashboard](https://apps.twitter.com/).
- Prepare 3 required parameters: ConsumerKey , ConsumerSecret , CallbackURL
- Install library using instructions below.

### Install using Cocoapods

To add TwitterSignIn to your app, add `TwitterSignIn` to your Podfile.

```ruby
pod 'TwitterSignIn'
```

### Usage Examples

**Import**

```swift
import TwitterSignIn
```

**Config your parameters before call SignIn**

```swift
TwitterSignIn.sharedInstance.consumerKey = "Your ConsumerKey Value"
TwitterSignIn.sharedInstance.consumerSecret = "Your ConsumerSecret Value "
TwitterSignIn.sharedInstance.callbackUrl = "Your CallbackURL Value"
```

> **Note**
> Take Care Your ConsumerSecret, you shouldn't be exposed to the public.

**Sign-In with Twitter App**

>**Warning**
>App authorization is not recommended!
>It is implemented by UIApplication.open(url:), and it is easy to expose the consumerSecret and consumerKey.
>This may create unknown and dangers risks.
>Sign-In with twitter app is off by default.

If you really need to use Sign-In with twitter app, follow this step

**1.set the `appAuthEnable` to ture**

```swift
TwitterSignIn.sharedInstance.appAuthEnable = true
```

**2.add `twitterauth` to LSApplicationQueriesSchemes in Plist file**

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>twitterauth</string>
</array>
```

**3.config you CallbackURL**

For use Sign-In with Twitter App, you need to set your CallbackURL to the specified value from Twitter Dashboard. It is start with `twitterkit-` and append you ConsumerKey.

Like:`twitterkit-YouConsumerKey://`

**4.add the specified CallbackURL to CFBundleURLTypes in Plist file**

the URLSchemes value is with out `://`

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>twitterkit-YouConsumerKey</string>
		</array>
	</dict>
</array>
```

**5.add `handleUrl` to openUrl in App Delegate**

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
	TwitterSignIn.sharedInstance.handleUrl(url)
	return true
}
```

# Sign-In

If set `appAuthEnable` to true, this library will try to call Twitter App first. If Twitter App not installed, will call inner browser.

```swift
TwitterSignIn.sharedInstance.signIn { user, error in
	if let error = error {
		//handle failed with TwitterSignInError
		//the library collect all error code into TwitterSignInError
		//Like: if (error.code == TwitterSignInError.CancelFromApp) { ... }
		return
	}
	
	//handle success from user
	//user.token: for server verification
	//user.secret: for server verification
	//user.userId: this value return from Web auth 
	//user.userName: this value return from App auth 
}
```

