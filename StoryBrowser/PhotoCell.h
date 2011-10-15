//
//  PhotoCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/29/11.
//

#import "BaseElementCell.h"
#import "ASIHTTPRequest.h"
UIImageView* photo;
UILabel* photoTitle;
UILabel* photoDescription;
ASIHTTPRequest* req;
NSTimer* delayRequest;
int loadingCounter;
@interface PhotoCell : BaseElementCell
    @property(nonatomic,retain) UIImageView* photo;
    @property(nonatomic,retain) UILabel* photoTitle;
    @property(nonatomic,retain) UILabel* photoDescription;
    @property(nonatomic,retain) ASIHTTPRequest* req;
    @property(nonatomic,retain) NSTimer* delayRequest;
    @property(nonatomic,assign) int loadingCounter;
@end
