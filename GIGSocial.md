# GIGSocial
Framework to perform common social features like:

* Facebook login
* Twitter Login - (not implemented yet)
* Share content (images, urls, text...) - (not implemented yet)

With a dynamic framework, it also embed the Facebook & Twitter frameworks nedded.


## Facebook Login

Facebook Login is a toolkit that encapsulate all the Facebook code needed to perform a login in a easy way.

GIGSocial not only provides you the Facebook access token, it also fetch the user information like name, email, gender and all the extra information you need.

#### _Basic usage_

Normally you only need GIGSocialLogin class to perform the login method, and GIGSocialLoginResult to managed the returned information. 

Example:

``` objc
GIGSocialLogin *socialLogin = [[GIGSocialLogin alloc] init];
[socialLogin loginFacebook:^(GIGSocialLoginResult *result)
{
	/// Use result to check success, errors, and retrive access token and user information
}];

```


### 1. Installation
In order to use Facebook, is necessary the general Facebook application setup as described in [Getting started](https://developers.facebook.com/docs/ios/getting-started "Facebook Getting Started"). As the sdk's are embbeded in GIGSocial Framework, there is no need to download and import the Facebook SDK.

Following is detailed what you need and what you don't from the Facebook installation docs:

1. Don't download the (facebook) SDK. As mentioned before, is embedded in GIGSocial
2. Create Facebook App
3. Configure Facebook App Settings for iOS
4. Don't add the SDK to your Xcode Project. There is no need
5. Configure Xcode Project
	* URL Schemes, app id and display name
	* Don't whitelist facebook server, is no needed anymore
6. Don't connect Application Delegate and don't add app events. Instead, use the GIGSocialCore methods.


### 2. GIGSocialCore

GIGSocialCore is conceived to be a wrapper for connect Facebook with de Application Delegate and App Events through a unique class. With this, the framework encapsulate and protect your code from future Facebook changes, and also you don't need to invoke any Facebook method directly.

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
GIGSocialLogin is where all the magic happens. To perform a Facebook Login, call this method:

``` objective-c
- (void)loginFacebook:(GIGSocialLoginFacebookCompletion)completionHandler;
```


#### _Extra permissions_
If you need to log with extra permissions, like "email", you must to add it to the extraPermissions array, befofore call to login:

``` objective-c
@property (strong, nonatomic) NSArray *extraPermissions;
```

_NOTE_:  By default, the **public_profile** permission is added.

Exmple of use: 

```objective-c
self.socialLogin.extraPermissions = @[@"email", @"user_birthday"];
[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
{
	// USER TRY TO LOG ASKING FOR PUBLIC PROFILE, EMAIL AND BIRTHDAY
	...
}
```


#### _Extra Fields_
As same as extra permissions, you need to specify wich fields you want to fetch from user information:

`@property (strong, nonatomic) NSArray *extraFields;`

_NOTE_: By default, the basic user information gathered is **first_name**, **middle_name**, **last_name** and **gender**

Example of user: 

``` objective-c
self.socialLogin.extraPermissions = @[@"email", @"user_birthday"];
self.socialLogin.extraFields = @[@"birthday", @"email"];
[self.socialLogin loginFacebook:^(GIGSocialLoginResult *result)
{
	// USER INFORMATION TO BE RETURNED WILL BE: first_name, middle_name, last_name, gender, birthday & email
	...
}
```

**IMPORTANT**: In order to gather birthday and email you also need to specify them as extra permissions as facebook needs.


#### _Result_

Here is the mother of the corder. The result for login is returned from a callback in a unique class GIGSocialLoginResult.

The info is in their properties as follows:

| Type | Property | Description |
|------|----------|-------------|
| Bool | Success | Indicates if login was successful |
| String | userID | User's Facebook ID |
| String | accessToken | User's Facebook access token |
| Dictionary | user | User's info. Is the result of perform a Facebook `/me` request. The fields key, are the same as Facebook provides us. |
| GIGSocialLoginError | loginError | Enumerate with all kind of errors that could be returned |
| NSError | error | Any kind of NSError returned by Facebook. When loginError is a Facebook error, you should check this NSError for more information. |


**Example of user Dictionary** 

```
{
    birthday = "01/24/1985";
    email = "a.j.agudo@gmail.com";
    "first_name" = Alejandro;
    gender = male;
    id = 10153683711944131;
    "last_name" = Agudo;
    "middle_name" = "Jim\U00e9nez";
}
```

**Error types**

The enumerate loginError could value the following cases:

| Error | Description |
|-------|-------------|
| GIGSocialLoginErrorNone | There is no error. Success should be "YES"
| GIGSocialLoginErrorFacebookCancelled | User did cancel the login |
| GIGSocialLoginErrorUser | There was an error trying to gather user's data. See `NSError *error` for more info.
| GIGSocialLoginErrorFacebook | There was an error trying to log in with Facebook. See `NSError *error` for more info | 

