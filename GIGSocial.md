# GIGSocial
Framework to perform common social features like:

* Facebook login
* Twitter Login
* Share content (images, urls, text...)

With a dynamic framework, it also embed the Facebook & Twitter frameworks nedded.


## Facebook Login

Facebook Login is a toolkit that encapsulate all the Facebook code needed to perform a login in a easy to use method.

GIGSocial not only provides you with the Facebook access token, it also fetch the user information like name, email, gender and all the extra information you need.

#### _Basic usage_

You normally only need to use GIGSocialLogin class, to perform the login method, and GIGSocialLoginResult to managed the returned information. 

Example:

``` objective-c
GIGSocialLogin *socialLogin = [[GIGSocialLogin alloc] init];
[socialLogin loginFacebook:^(GIGSocialLoginResult *result)
{
	/// Use result to check success, errors, and retrive access token and user information
}];

```


### 1. Installation
In order to use Facebook, is necessary the general Facebook application setup as described in [Getting started](https://developers.facebook.com/docs/ios/getting-started "Facebook Getting Started"). As the sdk's are embbeded in GIGSocial Framwork, there is no need to download and import the Facebook SDK.

Followng is detailed what you need and what you don't from the Facebook installation docs:

1. Don't download the (facebook) SDK. As mentioned before, there is no need
2. Create Facebook App
3. Configure Facebook App Settings for iOS
4. Don't add the SDK to your Xcode Project. There is no need
5. Configure Xcode Project
	* URL Schemes, app id and display name
	* Whitelist facebook server
6. Don't connect Application Delegate and don't add app events. Instead, use the GIGSocialCore methods.


### 2. GIGSocialCore

GIGSocialCore is conceived to be a wrapper for connect Facebook with de Application Delegate and App Events through a unique class. With this, the framework encapsulate and protect your code from future Facebook changes, and also you don't need invoke any Facebook method directly.

**IMPORTANT**: Is mandatory to call this methods for a correct Facebook usage

#### _Class Methods_

You have to call the following methods in their counterparts in AppDelegate

``` objective-c
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (void)applicationDidBecomeActive:(UIApplication *)application;
```

#### _Example of use_

AppDelegate.m

``` objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [GIGSocialCore application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [GIGSocialCore applicationDidBecomeActive:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GIGSocialCore application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


```


### 3. Login Facebook Method
TBD

#### _Extra permissions_
TBD

#### _Extra Fields_
TBD

#### _Result_
TBD

