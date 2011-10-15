//
//  VideoCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/7/11.
//

#import "BaseElementCell.h"
#import "ASIHTTPRequest.h"
UIImageView* preview;
UILabel* videoTitle;
UILabel* videoDescription;
ASIHTTPRequest* req;
NSTimer* delayRequest;
int loadingCounter;
@interface VideoCell : BaseElementCell
@property(nonatomic,retain) UIImageView* preview;
@property(nonatomic,retain) UILabel* videoTitle;
@property(nonatomic,retain) UILabel* videoDescription;
@property(nonatomic,retain) ASIHTTPRequest* req;
@property(nonatomic,retain) NSTimer* delayRequest;
@property(nonatomic,assign) int loadingCounter;
@end
