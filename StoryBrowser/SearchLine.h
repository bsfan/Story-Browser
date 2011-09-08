//
//  SearchLine.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/2/11.
//

#import "BaseElementCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
UIImageView* avatar;
UILabel* title;
ASIHTTPRequest* avatarReq;
@interface SearchLine : UITableViewCell
    @property(nonatomic,retain) UIImageView* avatar;
    @property(nonatomic,retain) UILabel* title;
    @property(nonatomic,retain) ASIHTTPRequest* avatarReq;

-(void)loadLine:(NSURL*)avatarURL title:(NSString*)title queue:(ASINetworkQueue*)queue;
@end
