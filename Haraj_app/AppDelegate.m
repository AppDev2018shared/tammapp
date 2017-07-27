//
//  AppDelegate.m
//  Haraj_app
//
//  Created by udaysinh on 23/04/17.
//  Copyright (c) 2017 udaysinh. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Bolts/Bolts.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "MainNavigationController.h"
#import "HomeNavigationController.h"
#import "LoginWithViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "Firebase.h"
@import UserNotifications;

@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate>
{
    NSUserDefaults *defaults;
    CLLocationManager *locationManager ;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSString *channelIDglobal;
    BOOL location;

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm app." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        
        
        
        
        
        
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                 didFinishLaunchingWithOptions:launchOptions];
        
        [Fabric with:@[[Twitter class]]];
        defaults=[[NSUserDefaults alloc]init];
        
        if ([[defaults valueForKey:@"LoginView"] isEqualToString:@"yes"])
        {
            
            HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
            
            self.window.rootViewController=loginController;
        }
        else
        {
            
            
            MainNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainNavigationController"];
            
            self.window.rootViewController=loginController;
        }
        
    }
    
//-------------------------------------Location ---------------------------------------------------------------------
    
    location = true;
    defaults=[[NSUserDefaults alloc]init];
    
    
    locationManager = [[CLLocationManager alloc] init] ;
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy =kCLLocationAccuracyThreeKilometers; //kCLLocationAccuracyNearestTenMeters;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];

//----------------------------------------------------------------------------------------------------------------------
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //------------------------------token---------------------------------------
    
    NSString *token = [[FIRInstanceID instanceID] token];
    
    NSLog(@"registration token: %@", token);
    
    
    // Add observer to listen for the token refresh notification.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTokenRefresh) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
        
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    
        //            ];
    // Add any custom logic here.
    
    if ([[Twitter sharedInstance] application:application openURL:url options:options])
    {
        
        return YES;
    }
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
 
}


- (void)onTokenRefresh
{
    
    // Get the default token if the earlier default token was nil. If the we already
    
    // had a default token most likely this will be nil too. But that is OK we just
    
    // wait for another notification of this type.
    
    NSString *token = [[FIRInstanceID instanceID] token];
    
    NSLog(@"registration token1: %@", token);
    
    
    
    // custom stuff as before.
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:

     (void (^)(UIBackgroundFetchResult))completionHandler
{
    
    // Handle your message. With swizzling enabled, no need to indicate
    
    // that a message was received.
    
}


#pragma mark - location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    
    
    
    //
    //    if (currentLocation != nil) {
    //        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    //        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    //    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
             NSLog(@"placemark.country %@",placemark.country);
             NSLog(@"placemark.postalCode %@",placemark.postalCode);
             NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
             NSLog(@"placemark.locality %@",placemark.locality);
             NSLog(@"placemark.subLocality %@",placemark.subLocality);
             NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
             
             
             NSLog(@"placemark.subThoroughfare %@",[defaults valueForKey:@"Cityname"]);
             
             
             if (placemark.locality !=nil && placemark.country !=nil)
             {
            
                
                 [defaults setObject:placemark.locality forKey:@"Cityname"];
                 [defaults setObject:placemark.country forKey:@"Countryname"];
                 [defaults synchronize];
                 
                 
                 
                 [locationManager stopUpdatingLocation];
             }
             
             
         }
         else
         {
             NSLog(@"%@", error.debugDescription);
         }
     } ];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error
{
    if([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services Enabled");
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            location = false;
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App Permission Denied" message:@"To re-enable, please go to Settings and turn on Location Service for this app." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           [alertController dismissViewControllerAnimated:YES completion:nil];
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                       }];
            
            [alertController addAction:actionOk];
            
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        }
        
        
    }
    
}



@end
