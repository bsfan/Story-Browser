//
//  BaseElementCell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/26/11.
//

#import "BaseElementCell.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
ASINetworkQueue* networkQueue;
@implementation BaseElementCell

+(CGFloat)heightForElement:(NSDictionary*) element{
    return 0;
}
-(void)loadElement:(NSDictionary*)element{

}

+(void)initNetworkQueue{
    networkQueue = [[ASINetworkQueue alloc] init];
    [networkQueue go];
}

-(ASINetworkQueue*) networkQueue{
    return networkQueue;
}

+(void)stopNetworkQueue{
    for (ASIHTTPRequest* req in [networkQueue operations] ){
        [req  clearDelegatesAndCancel];
        [req  cancel];
    }
    [networkQueue release];
    networkQueue = nil;
}

@end
