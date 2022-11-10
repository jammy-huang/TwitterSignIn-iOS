# Twitter Sign-In for iOS

Let Twitter users into your apps quickly and easily by using inner browser or twitter app.

It is interface to the [Twitter API](https://developer.twitter.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens), the sign-in process is lightly and clearly.

No dependencies, framework file is tiny.

Support both OAuth 2.0 and OAuth 1.1a.

Supports iOS 12+.

## Getting Started

If you want to use **OAuth 1.1a** or **Twitter App Sign-in**, please check this document: [TwitterSignInV1](doc/TwitterSignInV1.md)

TwitterSignInV2 not support for Twitter App Sign-in.

The document below is for TwitterSignInV2 with **Oauth 2.0**.

- Generate your Twitter API keys through the [Twitter developer apps dashboard](https://apps.twitter.com/).
- Prepare 2 required parameters: **Client ID** , **CallbackURL**
- Install library using instructions below.

### Install using Cocoapods

To add TwitterSignIn to your app, add `TwitterSignIn` to your Podfile.

```ruby
pod 'TwitterSignIn'
```

or


```ruby
pod 'TwitterSignIn/V2'
```

### Usage Examples

**Import**

```swift
import TwitterSignInV2
```

**Config your parameters before call SignIn**

```swift
TwitterSignIn.sharedInstance.clientId = "Your Client ID Value"
TwitterSignIn.sharedInstance.callbackUrl = "Your CallbackURL Value"
```

> **Note**
> you can set CallbackURL to any value you want


# Sign-In

When sign-in failed, error is not null. The error.code is collected in TwitterSignInError.

When sign-in success, user is not null. The user.token is Bearer Token.


```swift
TwitterSignIn.sharedInstance.signIn { user, error in
	if let error = error {
		//handle failed with TwitterSignInError
		//the library collect all error code into TwitterSignInError
		//Like: if (error.code == TwitterSignInError.CancelFromApp) { ... }
		return
	}
	
	//handle success from user
	//user.token: Bearer Token
}
```

