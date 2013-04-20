# Shakedown

Simple, in-app bug reporting for human beings.

![](http://f.cl.ly/items/1V173r391F0I3b2n3M0Y/Screen%20Shot%202013-04-18%20at%2011.28.48%20PM.png)

## Setup

To get going, just clone drag the contents of your repository into your project, and call `[SHDShakedown sharedShakedown]` at launch. Shakedown will begin listening for shake events automatically.

### WARNING

Shakedown uses the private API `UIGetScreenImage()`. This allows us to capture whatever's on the screen (including some fancier OpenGL stuff), but is not permitted by Apple in the App Store. **Make sure that you do not ship to the app store with this included, or your app risks being rejected by Apple.**

### Reporting Method

It is highly recommended to configure a reporter to suit your specific needs. Shakedown ships with two reporters: email and YouTrack. 

#### Configuring the Reporter

For example, you can configure the email reporter like so:

    SHDShakedownEmailReporter *reporter = [[SHDShakedownEmailReporter alloc] init];
    reporter.recipient = @"bugs@test.com";
    [SHDShakedown sharedShakedown].reporter = reporter;

Various reporters will have different things to configure. For example, one that posts to on online service may need an API key or login credentials, as well as what project too pust bugs to.

### Supported iOS Versions

Shakdown works on iOS 5.0 and up.

### A note on ARC

Shakedown uses ARC. To get things working in a non-ARC project, set the `-fobjc-arc` compiler flag on all the files prefixed with `SHD`.
