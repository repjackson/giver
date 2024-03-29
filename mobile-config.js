// This section sets up some basic app metadata,
// the entire section is optional.
App.info({
  id: 'com.joyful_giver.jg',
  name: 'Joyful Giver',
  description: 'Mobile Tithes & Donations for Churches & Congregations.',
  author: 'Brandon M. Spencer',
  email: 'info@joyful-giver.com',
  website: 'https://joyful-giver.com',
  version: '1.61.2'
});


// Set up resources such as icons and launch screens.
App.icons({
  "iphone_2x": "resources/icons/iphone_2x.png", // 120x120
  "iphone_3x": "resources/icons/iphone_3x.png", // 180x180
  "ipad": "resources/icons/ipad.png", // 76x76
  "ipad_2x": "resources/icons/ipad_2x.png", // 152x152
  "ipad_pro": "resources/icons/ipad_pro.png", // 167x167
  "ios_settings": "resources/icons/ios_settings.png", // 29x29
  "ios_settings_2x": "resources/icons/ios_settings_2x.png", // 58x58
  "ios_settings_3x": "resources/icons/ios_settings_3x.png", // 87x87
  "ios_spotlight": "resources/icons/ios_spotlight.png", // 40x40
  "ios_spotlight_2x": "resources/icons/ios_spotlight_2x.png", // 80x80
  "android_mdpi": "resources/icons/android_mdpi.png", // 48x48
  "android_hdpi": "resources/icons/android_hdpi.png", // 72x72
  "android_xhdpi": "resources/icons/android_xhdpi.png", // 96x96
  "android_xxhdpi": "resources/icons/android_xxhdpi.png", // 144x144
  "android_xxxhdpi": "resources/icons/android_xxxhdpi.png" // 192x192
});

App.launchScreens({
  "iphone_2x": "resources/splashes/iphone_2x.png", // 640x490
  "iphone5": "resources/splashes/iphone5.png", // 640x1136
  "iphone6": "resources/splashes/iphone6.png", // 750x1334
  "iphone6p_portrait": "resources/splashes/iphone6p_portrait.png", // 2208x1242
  "iphone6p_landscape": "resources/splashes/iphone6p_landscape.png", // 2208x1242
  "ipad_portrait": "resources/splashes/ipad_portrait.png", // 768x1024
  "ipad_portrait_2x": "resources/splashes/ipad_portrait_2x.png", // 1536x2048
  "ipad_landscape": "resources/splashes/ipad_landscape.png", // 1024x768
  "ipad_landscape_2x": "resources/splashes/ipad_landscape_2x.png", // 2048x1536
  "android_mdpi_portrait": "resources/splashes/android_mdpi_portrait.png", // 320x480
  "android_mdpi_landscape": "resources/splashes/android_mdpi_landscape.png", // 480x320
  "android_hdpi_portrait": "resources/splashes/android_hdpi_portrait.png", // 480x800
  "android_hdpi_landscape": "resources/splashes/android_hdpi_landscape.png", // 800x480
  "android_xhdpi_portrait": "resources/splashes/android_xhdpi_portrait.png", // 720x1280
  "android_xhdpi_landscape": "resources/splashes/android_xhdpi_landscape.png", // 1280x720
  "android_xxhdpi_portrait": "resources/splashes/android_xxhdpi_portrait.png", // 1080x1440
  "android_xxhdpi_landscape": "resources/splashes/android_xxhdpi_landscape.png" // 1440x1080
})

// Set PhoneGap/Cordova preferences
App.setPreference('HideKeyboardFormAccessoryBar', true);

App.accessRule('*.facebook.com/*', { type: 'navigation' } );
App.accessRule('*.google.com/*', { type: 'navigation' } );
App.accessRule('https://*.joyful-giver.com/*', { type: 'navigation' } );
App.accessRule('https://js.stripe.com/*', { type: 'navigation' } );
App.accessRule('http://www.balmingilead.org/*', { type: 'navigation' } );
App.accessRule('https://*.twilio.com/*');
App.accessRule('https://*.stripe.com/*');
App.accessRule('https://m.stripe.network/*');
App.accessRule('https://joyful-giver-cloud.s3-us-west-2.amazonaws.com/*', { type: 'navigation' });
//App.accessRule('*.amazonaws.com*', '');

App.accessRule('//104.236.145.69');
App.accessRule('//localhost/*');
App.accessRule('//joyful-giver.com/*');
App.accessRule('//res.cloudinary.com');
App.accessRule('*.vimeo.com/*');
App.accessRule('*.blob/*');
App.accessRule('blob:*');
App.accessRule('*.twilio.com/*');
App.accessRule('*.facebook.com/*');
App.accessRule('*.google.com/*');
App.accessRule('*.googleapis.com/*');
App.accessRule('*.gstatic.com/*');
App.setPreference('android-targetSdkVersion', '16');
App.setPreference('android-minSdkVersion', '16');
App.configurePlugin('cordova-plugin-googleplus', { REVERSED_CLIENT_ID: 'com.googleusercontent.apps.563471978323-uga0ovmopqiq2pbaj4tk6o8u5gti5udr' });
