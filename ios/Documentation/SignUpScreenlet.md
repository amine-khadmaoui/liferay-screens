# SignUpScreenlet for iOS

## Requirements

- XCode 6.3 or above
- iOS 8 SDK
- Liferay Portal 6.2 CE or EE

## Compatibility

- iOS 7 and above

## Features

The main function of the `SignUpScreenlet` is to create a new user in your Liferay instance. For example, by using the `SignUpScreenlet` a new user of your app can become a new user in your portal. You can also use this screenlet to save the credentials of the new user in their keychain. This enables auto login for future sessions. The screenlet also supports navigation of form fields from the keyboard of the user's device.

## Module

- Auth

## Themes

- Default
- Flat7

![The `SignUpScreenlet` with the Default and Flat7 themes.](Images/signup.png)

## Portal Configuration

The configuration related to the `SignUpScreenlet` can be set in the Control Panel by clicking *Portal Settings* and then *Authentication*. These settings are shown in the following screenshot:

![The portal settings related to the `SignUpScreenlet`.](Images/portal-signup.png)

For more details, please refer to the [Configuring Portal Settings](https://dev.liferay.com/discover/portal/-/knowledge_base/6-2/configuring-portal-settings) section of the User Guide.

## Anonymous Request

An anonymous request can be done without the user being logged in. However, authentication is needed to call the API. To allow this operation, it's recommended that the portal administrator create a specific user with minimal permissions.

## Attributes

| Attribute | Data type | Explanation |
|-----------|-----------|-------------| 
| `anonymousApiUserName` | `string` | The user name, email address, or user ID (depending on the portal's authentication method) to use for authenticating the request. |
| `anoymousApiPassword` | `string` | The password for use in authenticating the request. |
| `companyId` | `number` | When set, authentication is done for a user in the specified company. If the value is `0`, the company specified in `LiferayServerContext` is used. |
| `autoLogin` | `boolean` | Whether the user is logged in automatically after a successful sign up. |
| `saveCredentials` | `boolean` | Sets whether or not the user's credentials and attributes are stored in the keychain after a successful log in. This attribute is ignored if `autologin` is disabled. |

## Delegate

The `SignUpScreenlet` delegates some events to an object that conforms to the `SignUpScreenletDelegate` protocol. If the `autologin` attribute is enabled, login events are delegated to an object conforming to the `LoginScreenletDelegate` protocol. Refer to the [`LoginScreenlet` documentation](LoginScreenlet.md) for more details.

The `SignUpScreenletDelegate` protocol lets you implement the following methods:

- `- screenlet:onSignUpResponseUserAttributes:`: Called when sign up successfully completes. The user attributes are passed as a dictionary of keys (`String` or `NSStrings`) and values (`AnyObject` or `NSObject`). The supported keys are the same as [Liferay Portal's User entity](https://github.com/liferay/liferay-portal/blob/6.2.x/portal-impl/src/com/liferay/portal/service.xml#L2227).
- `- screenlet:onSignUpError:`: Called when an error occurs in the process. The `NSError` object describes the error.

