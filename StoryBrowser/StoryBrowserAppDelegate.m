//
//  StoryBrowserAppDelegate.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import "StoryBrowserAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
@implementation UISearchBar (CustomBG)
- (void)drawRect:(CGRect)rect {
    UIView* segment=[self.subviews objectAtIndex:0];
	segment.hidden=YES;
	UIView* bg=[self.subviews objectAtIndex:1];
	bg.hidden=YES;
    
	UIImage *image = [UIImage imageNamed: @"noisy_bar_background.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}
@end

@implementation UINavigationBar (CustomBG)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"noisy_bar_background.png"];
    self.tintColor=[UIColor lightGrayColor];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation UIToolbar (CustomBG)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"noisy_bar_background.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation StoryBrowserAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    //[ASIHTTPRequest setDefaultUserAgentString:@"boba fett"];
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.delegate=self;
    TTURLMap* map = navigator.URLMap;

    //[map from:@"*" toViewController:[TTWebController class]];    
    [map from:@"*" toObject:self selector:@selector(openURL:)];
    self.window.rootViewController = self.navigationController;
    [navigator setWindow:self.window];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)openURL:(NSURL*)url{
    TTWebController* ctr = [[[TTWebController alloc] init] autorelease];
    [ctr openURL:url];
    [self.navigationController pushViewController:ctr animated:YES];
    //[[UIApplication sharedApplication] openURL:url];
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
