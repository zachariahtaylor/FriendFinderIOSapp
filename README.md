# FriendFinder IOS app

Friend Finder is a IOS application which allows you to find your friends by updating your and their location data to a database and then displaying this
information in map form on your phone. Location services can be turned off to give you anonymity. The friend app will alert you when a friend is within a certain distance from you and 
then you can check your Friend Finder app to look at the map and see where in relationship to yourself that your friend is.

## Database

Currently the database will only be deployed for short amount of times
and will not specify who are your friends so everyone can access all people in the database.

The webpage index to the database can be accessed here: http://ec2-52-32-225-1.us-west-2.compute.amazonaws.com/

If for any reason you need to add Tester locations this would be the place to do it by inputing a Unique ID and a Latitude and Longitude.

## How to Use

The FriendFinder Application requires a location and if you will be testing it you will require two devices to properly test; one of which can be the xcode Iphone Simulator. These two devices should be controlled by two different people as you will be able to see your location data and that of your friend. If one of the testers moves around the other will be able to watch that movement from their own device. 

The FriendFinder App pulls all information from the database and stores it in a table and then renders that information. The MapView is then updated in real time to show locations of the friends around you. Also depending on your setting of the distance slider when a friend is within a certain range you will be notified that someone is a certain distance away. You can add tester locations to the database to test the notification or again use two testers. If you wish to add static locations to the database see the Database section.

To turn off location data and notifications press the Services On button which will turn off the services. This will stop all current updates to the table and all notifications from appearing. You will continue to see all of the last positions of friends after turning off services though it will not update their location until you turn Services back on. Note: For some reason turning off Services is tied to turning off the locationManager but will not stop your own location updating on the phone though it will no longer update in the database.

The slider bar is used to set the distance at which you want to be notified that a friend is nearby. So if you set your slider to 50 meters it will only notify you when someone is within that range. The calculation to get distance is based on Latitude and Longitude and may have a increasing discrepency as you move away from the equater due to earth not being a perfect sphere. 

When clicking on an Icon it will show you the users unique ID. When you have clicked on an icon please be warned that the currently selected pin will not update until you unselect the icon. This will be fixed in a future release. 

### Warning: All ID's must be Unique. 

A non-unique ID will update to both ID's locations making it shuffle from one position to another in the table depending on updating measures. To fix this in the future all ID's will be phone numbers and you will only get those friends who are in your contacts. This is scheduled for a future release.

## Future Goal:

After Implementing Friend Finder another app that works using the same database can be built called Friend Hider which will do similar things as the Friend Finder but will keep your location
data hidden so no one will be notified of your presence and will alert you when you might possibly run into a friend so you can take an alternate path to avoid your friend. 

## Built Using

* Xcode - Swift
* MEAN Stack

