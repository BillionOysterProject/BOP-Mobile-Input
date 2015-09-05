//App.setPreference('AutoHideSplashScreen', 'true');

//ref: http://docs.meteor.com/#/full/mobileconfigjs
// This section sets up some basic app metadata,
// the entire section is optional.
App.info({
  id: 'ca.visualscience.bopinput',
  version: '0.1.8',
  name: 'BOP Input',
  description: 'Data collection app for BOP',
  author: 'ABCD',
  email: 'andrew@abcd.ca',
  website: 'http://input.bop.nyc'
});

App.accessRule("http://maps.googleapis.com");
App.accessRule("https://bop-upload-test.s3.amazonaws.com/*");
App.accessRule("https://bop-images.s3.amazonaws.com/*");
App.accessRule("http://bop-upload-test.s3.amazonaws.com/*");
App.accessRule("http://bop-images.s3.amazonaws.com/*");
App.accessRule("http://meteor.local/*");


/*
	icons I have generated:
	Not sure if I can use all these from meteor, might have to go directly to cordova config.xml.
	Need to research best/safest way to do this.

	ios --------------------- start

	icon-40.png
	icon-40@2x.png
	icon-50.png
	icon-50@2x.png
	icon-60.png
	icon-60@2x.png
	icon-60@3x.png
	icon-72.png
	icon-72@2x.png
	icon-76.png
	icon-76@2x.png
	icon-small.png
	icon-small@2x.png
	icon-small@3x.png
	icon.png
	icon@2x.png

	Splash screens i have generated:

	Default-667h.png
	Default-736h.png
	Default-Landscape-736h.png
	Default-Landscape@2x~ipad.png
	Default-Landscape~ipad.png
	Default-Portrait@2x~ipad.png
	Default-Portrait~ipad.png
	Default@2x~iphone.png
	Default~iphone.png

	Default@2x~iphone5.png





	android --------------------- start

	icons:

	drawable-hdpi-icon.png
	drawable-ldpi-icon.png
	drawable-mdpi-icon.png
	drawable-xhdpi-icon.png
	drawable-xxhdpi-icon.png
	drawable-xxxhdpi-icon.png


	splash:

	drawable-land-hdpi-screen.png
	drawable-land-ldpi-screen.png
	drawable-land-mdpi-screen.png
	drawable-land-xhdpi-screen.png
	drawable-land-xxhdpi-screen.png
	drawable-land-xxxhdpi-screen.png
	drawable-port-hdpi-screen.png
	drawable-port-ldpi-screen.png
	drawable-port-mdpi-screen.png
	drawable-port-xhdpi-screen.png
 */

//// Set up resources such as icons and launch screens.
App.icons({
  // iOS
  'iphone': 'resources/icons/icon-60.png',
  'iphone_2x': 'resources/icons/icon-60@2x.png',
  'ipad': 'resources/icons/icon-72.png',
  'ipad_2x': 'resources/icons/icon-72@2x.png',

  // Android
  'android_ldpi': 'resources/icons/drawable-ldpi-icon.png',
  'android_mdpi': 'resources/icons/drawable-mdpi-icon.png',
  'android_hdpi': 'resources/icons/drawable-hdpi-icon.png',
  'android_xhdpi': 'resources/icons/drawable-xhdpi-icon.png'
});

App.launchScreens({
  // iOS
  'iphone': 'resources/splash/Default~iphone.png',
  'iphone_2x': 'resources/splash/Default@2x~iphone.png',
  'iphone5': 'resources/splash/Default@2x~iphone5.png',
  'ipad_portrait': 'resources/splash/Default-Portrait~ipad.png',
  'ipad_portrait_2x': 'resources/splash/Default-Portrait@2x~ipad.png',
  'ipad_landscape': 'resources/splash/Default-Landscape~ipad.png',
  'ipad_landscape_2x': 'resources/splash/Default-Landscape@2x~ipad.png',

  // Android
  'android_ldpi_portrait': 'resources/splash/drawable-port-ldpi-screen.png',
  'android_ldpi_landscape': 'resources/splash/drawable-land-ldpi-screen.png',
  'android_mdpi_portrait': 'resources/splash/drawable-port-mdpi-screen.png',
  'android_mdpi_landscape': 'resources/splash/drawable-land-mdpi-screen.png',
  'android_hdpi_portrait': 'resources/splash/drawable-port-hdpi-screen.png',
  'android_hdpi_landscape': 'resources/splash/drawable-land-hdpi-screen.png',
  'android_xhdpi_portrait': 'resources/splash/drawable-port-xhdpi-screen.png',
  'android_xhdpi_landscape': 'resources/splash/drawable-land-xhdpi-screen.png'
});


//
//// Set PhoneGap/Cordova preferences
App.setPreference('BackgroundColor', '0x11223b');
App.setPreference('SplashScreenDelay', '1500');
App.setPreference('orientation', 'portrait');
App.setPreference('BackupWebStorage', 'local');
//App.setPreference('HideKeyboardFormAccessoryBar', true);
//
//// Pass preferences for a particular PhoneGap/Cordova plugin
//App.configurePlugin('com.phonegap.plugins.facebookconnect', {
//	APP_ID: '1234567890',
//	API_KEY: 'supersecretapikey'
//});

// ---
// generated by js2coffee 2.0.4