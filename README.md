Billion Oyster Project
======================

## Tech stack:

* Meteor with
	* Node.js
	* Ionic Framework (AngularJS)
 
## Getting Started

To get started clone this repo and run the application.

* To run for browser just use `meteor`.
* To run for android : `meteor run android` 
* To run for ios : `meteor run ios`.


**Note: Server requires imagemagick for thumbnail creation! ** [modulus.io has it](http://help.modulus.io/customer/portal/questions/8574435-can-i-use-imagemagick-). Locally on OS X you can do, `brew install imagemagick`

image server base URL: `http://bop-images.s3-website-us-west-1.amazonaws.com/`


## Troubleshooting
I had trouble with geolocation preferences. The AndroidManifest.xml needs some permissions for GPS. If you add them directly there though they'll get overridden by builds. If you write them in the cordova-build/config.xml they'll be overwritten. There is no syntax for adding them via mobile-config.js which is the recommended way. The way these SHOULD get set is not by the developer at all. Rather, properly adding the geolocation cordova plugin (using meteor's CLI) should automatically add those settings in the manifest for you.

This command worked:

`meteor add cordova:cordova-plugin-geolocation@https://github.com/apache/cordova-plugin-geolocation/tarball/6dcc55b2a9ef36ae8f300ade8abecf74850e41f0`

Explanation of command above:

* All cordova plugins are installed starting with `meteor add cordova:`
* The next part is the plugin id. You can find this by finding the version of the plugin you want in github (you can get the master or go to a tagged version). Look inside the plugin.xml file for that plugin, you'll see the ID there. In this case, it was `cordova-plugin-geolocation`
* Meteor wants you to specify a version. I found doing @1.0.0 wasn't working for me – the plugin would appear to add but all that does is set it in some config file as a dependency, when you go to do a build it fails to download. Alternatively you can specify a tarball url. To get that you go to a particular commit in github for the plugin (again, you can use a tag id for this). In the browser's URL you'll see the word commit. Just copy that url but change the word `commit` in the url to '`tarball`. 