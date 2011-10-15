//
//  WebBrowser.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/28/11.
//

#import <UIKit/UIKit.h>
IBOutlet UIToolbar* toolbar;
IBOutlet UIWebView* webView;

UIBarButtonItem* backButton;
UIBarButtonItem* forwardButton;
UIBarButtonItem* refreshButton;
UIBarButtonItem* stopButton;
NSURL* currentUrl;
NSString* pageTitle;
@interface WebBrowser : UIViewController<UIWebViewDelegate>
    @property(nonatomic,retain) IBOutlet UIToolbar* toolbar;
    @property(nonatomic,retain) IBOutlet UIWebView* webView;
    @property(nonatomic,retain) UIBarButtonItem* backButton;
    @property(nonatomic,retain) UIBarButtonItem* forwardButton;
    @property(nonatomic,retain) UIBarButtonItem* refreshButton;
    @property(nonatomic,retain) UIBarButtonItem* stopButton;
    @property(nonatomic,retain) NSURL* currentUrl;
    @property(nonatomic,retain) NSString* pageTitle;
@end
