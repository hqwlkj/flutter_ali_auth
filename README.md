# flutter_ali_auth

Language: 中文

基于阿里云一键登录的 **Flutter集成的SDK插件**

阿里云一键登录安卓接入文档: [Android_v2.14.19](https://help.aliyun.com/document_detail/144231.html)

阿里云一键登录IOS接入文档: [iOS_v2.14.19](https://help.aliyun.com/document_detail/144186.html)

## 更新历史 🌄

- 现已更新到与官方同步的SDK [v2.14.19](https://help.aliyun.com/document_detail/121113.html) 版本;
- 授权页适配夜间/暗色模式(仅全屏，弹窗模式需自定以);

## 目录
* [效果图](#效果图-)
    * [IOS](#IOS)
    * [Android](#Android)
* [准备工作](#准备工作-)
* [原生SDK代码调用顺序](##先了解原生sdk代码调用顺序-)
* [插件使用](#插件使用-%EF%B8%8F)
    * [添加监听](#1-添加监听)
    * [初始化SDK配置密钥与UI](#2初始化sdk-initsdk)
    * [检查环境](#3一键登录获取token-login)
    * [预取号](#4检查认证环境-checkverifyenable)
    * [调起授权页面，获取Token](#5一键登录预取号-accelerateloginpage)
* [注意事项](#注意事项-%EF%B8%8F)





## 效果图 📷

### IOS

| 全屏 | 底部弹窗 | 中间弹窗 |
| --- | --- | --- |
| ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/full_screen_with_custom_view_ios.PNG "full_screen_image_ios") | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/bottomsheet_ios.PNG) | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/alert_ios.PNG) |

### Android

| 全屏 | 底部弹窗 | 中间弹窗 |
| --- | --- | --- |
| ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/full_screen_with_custom_view_android.jpg "full_screen_image_android") | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/bottomsheet_android.jpg) | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/alert_android.jpg) |

## 插件须知 ⚠️
### 关于权限
1. 安卓权限，本插件已经添加必要的权限支持：
```xml
<uses-permission android:name="android.permission.INTERNET" /> <!-- 网络访问 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> <!-- 检查wifi网络状态 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> <!-- 检查网络状态 -->
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" /> <!-- 切换网络通道 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/> <!-- 本地信息缓存 -->
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> <!-- 开关Wi-Fi状态，解决中国内地机型移动网络权限问题需要 -->
```
需要加上自行根据实际情况，设置HTTP白名单
```xml
 <network-security-config>
  <domain-config cleartextTrafficPermitted="true" >
    <domain includeSubdomains="true">enrichgw.10010.com</domain> <!-- 联通内部5G请求域名，开发者需要添加 -->
    <domain includeSubdomains="true">onekey.cmpassport.com</domain>  <!-- 移动内部请求域名，开发者需要添加 -->
  </domain-config>
</network-security-config>
```
>目前中国移动提供的个别接口为HTTP请求，对于全局禁用HTTP的项目，需要设置HTTP白名单。以下为运营商HTTP接口域名：onekey.cmpassport.com，enrichgw.10010.com，
详情可参见[官方文档](https://help.aliyun.com/document_detail/144231.html#section-no4-043-b31)

2.苹果开发

- 插件已经集成主库`ATAuthSDK.framework`，不需要添加`-ObjC`。

- 开发工具建议使用Xcode 11及以上。

- 支持iOS 10及以上系统。

- 如果集成本插件之后遇到`File not found: /Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphoneos.a` 的问题，问题可能是 本插件依赖MBProgressHUD，而MBProgressHUD的deployment target过低，你只需要将其改到12以上即可。

## 最后，有用请🌟~

## 准备工作 🔧

请登录阿里云控制台[号码认证服务](https://dypns.console.aliyun.com/?spm=5176.13329450.favorite.ddypns.2fdd4df5w4jELK#/overview)
分别添IOS和Android的认证方案，从而获取到SDK的秘钥。
注意：Ios只需要输入绑定`Bundle name`即可，Android则需要包名和和签名。[如何获取App的签名](https://help.aliyun.com/document_detail/87870.html)

## 先了解原生SDK代码调用顺序 🔗
```java
/*
* 1.初始化获取Token实例
*/
TokenResultListener mTokenListener = new TokenResultListener();

/*
* 2.初始化SDK实例
*/
mAlicomAuthHelper = PhoneNumberAuthHelper.getInstance(context, mTokenListener);

/*
* 3.设置SDK密钥
*/
mAlicomAuthHelper.setAuthSDKInfo();

/*
* 4.检测终端⽹络环境是否⽀持⼀键登录或者号码认证，根据回调结果确定是否可以使⽤⼀键登录功能
*/
mAlicomAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper#SERVICE_TYPE_LOGIN);

/*
* 5.若步骤4返回true，则根据业务情况，调⽤预取号或者⼀键登录接⼝
*   详⻅Demo接⼊⼯程
*/
mAlicomAuthHelper.getLoginToken(context, 5000);
```

## 插件使用 ☄️


### 1. 添加监听
```dart
/// 传入回调函数 onEvent
AliAuthClient.handleEvent(onEvent: _onEvent);
/// 移除回调事件
AliAuthClient.removeHandler();
```
在`onEvent`中监听回调并且自行进行判断
```dart
void _onEvent(AuthResponseModel event) async {
  //print(event);
}

``` 
回调实例`AuthResponseModel`
在原生中已经对事件响应码进行了包装，消息成员如下

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| resultCode | String | SDK返回码，600000表示操作成功（初始化/检查环境/预取号/登录成功）,详情参考官网的[SDK返回码](https://help.aliyun.com/document_detail/144186.html#section-24w-vwk-205) |
| requestId | String | SDK请求ID，如出现无法解决问题时候可以根据Id创建工单咨询|
| msg | String | SDK返回码描述，详情参考官网的[SDK返回码](https://help.aliyun.com/document_detail/144186.html#section-24w-vwk-205) |
| token | String | 在 **授权页面点击登录按钮成功** 认证后resultCode为60000时，会返回认证的Token,此时SDK提供的服务到此结束，可以拿Token到服务端进行自行判断登录认证|
| innerCode | String | 如果初始化认证SDK出现问题，回调信息一般会携带运行商的错误代码和错误信息，详情参考[运营商SDK错误码](https://help.aliyun.com/document_detail/85351.htm?spm=a2c4g.11186623.0.0.ab636cf0vQSEZO#topic2087)|
| innerMsg | String | 运行商认证时候出现的错误信息|


### 2.初始化SDK **(initSdk)**

```dart
/// 初始化前需要须对插件进行监听
await AliAuthClient.initSdk(
authConfig: const AuthConfig(),
);
```
需要通过 `AuthConfig` 来配置安卓和IOS端的秘钥，以及UI的配置 `AuthUIConfig`,成员如下

| 参数名 | 类型           | 描述                                                                                                                                      |
| --- |--------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| iosSdk | String       | IOS秘钥                                                                                                                                   |
| androidSdk | String       | Android秘钥                                                                                                                               |
| enableLog | bool         | 是否打印日志                                                                                                                                  |
| authUIStyle | Enum         | fullScreen(全屏) bottomSheet(底部弹窗) alert(中间弹窗) 目前暂时配置了三种常用竖屏的形式,更多形式参考[官方文档](https://help.aliyun.com/document_detail/144232.html) 后续将陆续支持 |
| authUIConfig | AuthUIConfig | UI配置类                                                                                                                                   |

`AuthUIConfig`为UI的配置类型,分为全屏UI配置 `FullScreenUIConfig` 和弹窗UI配置 `AlertUIConfig`

`FullScreenUIConfig` 成员如下

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| navConfig | NavConfig | 导航栏UI配置 |
| backgroundColor | String | 十六进制背景颜色,eg: "#ffffff" |
| backgroundImage | String | 本地的背景图片,eg: "/assets/image/background.png" |
| prefersStatusBarHidden | Boolean | 状态栏是否隐藏，默认显示 |
| logoConfig | LogoConfig | LogoUI配置类 |
| sloganConfig | SloganConfig | SloganConfig配置类 |
| phoneNumberConfig | PhoneNumberConfig | PhoneNumberConfig配置类 |
| loginButtonConfig | LoginButtonConfig | LoginButtonConfig配置类 |
| changeButtonConfig | ChangeButtonConfig | ChangeButtonConfig配置类 |
| checkBoxConfig | CheckBoxConfig | CheckBoxConfig配置类 |
| privacyConfig | PrivacyConfig | PrivacyConfig配置，自定义协议（目前只支持三个） |

`AlertUIConfig` 成员如下

| 参数名 | 类型                  | 描述 |
| --- |---------------------| --- |
| alertTitleBarConfig | AlertTitleBarConfig | 弹窗ActionBar的UI配置 |
| alertContentViewColor | String              | 十六进制背景颜色,eg: "#ffffff" |
| alertBlurViewColor | String              | 弹窗蒙层的颜色 |
| alertBlurViewAlpha | double              | 弹窗蒙层的透明度 |
| alertBorderRadius | double              | 弹窗圆角 |
| alertBorderWidth | double              | 边框宽度,仅Android生效 |
| alertBorderColor | String              | 边框颜色,仅Android生效 |
| alertWindowWidth | double              | 弹窗宽度 |
| alertWindowHeight | double              | 弹窗高度 |
| logoConfig | LogoConfig          | LogoUI配置类 |
| sloganConfig | SloganConfig        | SloganConfig配置类 |
| phoneNumberConfig | PhoneNumberConfig   | PhoneNumberConfig配置类 |
| loginButtonConfig | LoginButtonConfig   | LoginButtonConfig配置类 |
| changeButtonConfig | ChangeButtonConfig  | ChangeButtonConfig配置类 |
| checkBoxConfig | CheckBoxConfig      | CheckBoxConfig配置类，弹窗默认隐藏checkbox |
| privacyConfig | PrivacyConfig       | PrivacyConfig配置，自定义协议（目前只支持三个） |


### 3.一键登录获取Token **(login)**

调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token,可选参数为Timeout,默认5s

调用此接口后会通过之前注册的监听中回调信息
```dart
/// 一键登陆 需要用try-catch[PlatformException]捕获插件返回的异常
/// 无返回内容,调用之后，会在[handleEvent]的[onEvent]返回回调
await AliAuthClient.login({double timeout = 5.0})
```


### 4.其他方法

下面的方法与官网接入文档一致，可以根据个人开发情况进行使用

```dart
/// 关闭授权页loading
await AliAuthClient.hideLoginLoading();

/// 退出授权认证页
await AliAuthClient.quitLoginPage();
```

### 5.如有帮助到你，请我喝咖啡

我相信本项目的代码一定能在商业项目上帮助到您，如果您从本项目中获益，不妨请作者我喝杯咖啡,
您的捐助使我更有动力创作～





| 微信 | 支付宝 | 
| ---------------- | ------ | 
| ![wechat donate](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/IMG_2046.JPG) | ![alipay donate](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/IMG_2047.jpg) | 










