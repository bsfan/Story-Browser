//
//  StoryBrowserAppDelegate.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import "StoryBrowserAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "UIImage+edit.h"
#import "GANTracker.h"
#import "iRate.h"
@implementation StoryBrowserAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [ASIHTTPRequest setDefaultUserAgentString:@"boba fett"];
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.delegate=self;
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toObject:self selector:@selector(openURL:)];
    self.window.rootViewController = self.tabBarController;
    [navigator setWindow:self.window];
    [self.window makeKeyAndVisible];
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-16906489-5" dispatchPeriod:30 delegate:nil];
    
    [UIImage clearCacheForVersion:@"12"];
    return YES;
}
-(void)openURL:(NSURL*)url{
    TTWebController* ctr = [[[TTWebController alloc] init] autorelease];
    [ctr openURL:url];
    ctr.hidesBottomBarWhenPushed=YES;
    if ([self.tabBarController.selectedViewController class]==[UINavigationController class]){
        [((UINavigationController*)self.tabBarController.selectedViewController) pushViewController:ctr animated:YES];
    }
}

+ (void)initialize{
	[iRate sharedInstance].appStoreID = 463189225;
    [iRate sharedInstance].applicationName=@"Story Browser";
}

- (BOOL)navigator:(TTBaseNavigator*)navigator shouldPresentURL:(NSURL*)URL{
    return false;
}
- (BOOL)navigator:(TTBaseNavigator *)navigator shouldOpenURL:(NSURL *)URL{
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
    //[self saveContext];
}

- (void)awakeFromNib{
//    RootViewController *rootViewController = (RootViewController *)[self.navigationController topViewController];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
 }


@end
