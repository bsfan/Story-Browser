//
//  TweetText.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/27/11.
//

#import <UIKit/UIKit.h>
#import "BaseElementCell.h"
#import "Three20/Three20.h"
#import "ASIHTTPRequest.h"

UILabel* tweetText;
UIImageView* avatar;
UILabel* author;
UILabel* date;
UIImageView* bird;
ASIHTTPRequest* req;
NSTimer* delayRequest;
@interface TweetCell : BaseElementCell
@property(nonatomic,retain) UILabel* tweetText;
@property(nonatomic,retain) UIImageView* avatar;
@property(nonatomic,retain) UILabel* author;
@property(nonatomic,retain) ASIHTTPRequest* req;
@property(nonatomic,retain) UILabel* date;
@property(nonatomic,retain) UIImageView* bird;
@property(nonatomic,retain) NSTimer* delayRequest;
@end
