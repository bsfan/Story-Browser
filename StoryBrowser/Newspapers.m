//
//  Newspapers.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/14/11.
//

#import "Newspapers.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "NSString+HTML.h"
#import "UIImage+edit.h"
#import "Search.h"
@implementation Newspapers
@synthesize  table,newspapers;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
        
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
       self.newspapers = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"newspapers.plist" withExtension:nil]];
    UIImageView* logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame=CGRectMake(0, 0, [UIImage imageNamed:@"logo.png"].size.width, [UIImage imageNamed:@"logo.png"].size.height);
    self.navigationItem.titleView=logo;
    [logo release];
    self.title=@"Newspapers";
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
-(IBAction)paf:(id)sender{
    NSMutableArray* myDic=[[NSMutableArray alloc] init];
    NSMutableArray* currentSection = [[NSMutableArray alloc] init];
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://storify.com/dshaw/storify-users-newspapers.json"]];
    [req startSynchronous];

    SBJsonParser* parser= [[SBJsonParser alloc] init];
    NSDictionary* dic =  [[parser objectWithString:req.responseString] objectForKey:@"elements"]; 
    for (int i =0; i<[dic count];i++){
        NSDictionary* element = [dic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([[element objectForKey:@"elementClass"] isEqualToString:@"text"]){
            NSLog(@"%@",[[element objectForKey:@"description"]stringByConvertingHTMLToPlainText]);
            currentSection = [[NSMutableArray alloc] init];
            [myDic addObject:currentSection];
        }else if ([[element objectForKey:@"elementClass"] isEqualToString:@"website"]){
            NSURL*  url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.json",[element objectForKey:@"permalink"]]];
            ASIHTTPRequest* req2 = [ASIHTTPRequest requestWithURL:url];
            [req2 startSynchronous];
            NSDictionary* dic2 =  [parser objectWithString:req2.responseString] ;
            ASIHTTPRequest* avatarReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[dic2 objectForKey:@"author"] objectForKey:@"avatar"]]];
            [avatarReq startSynchronous];
            UIImage* avatar = [[[[UIImage imageWithData:avatarReq.responseData] imageWithSize:CGSizeMake(44, 44)]imageWithRadius:2] imageWithMask:[UIImage imageNamed:@"mask_44.png"]] ;
            NSData* imgData = UIImagePNGRepresentation(avatar);
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[[dic2 objectForKey:@"author"] objectForKey:@"username"]]];
            
            if (![imgData writeToFile:path options:NSDataWritingAtomic error:nil]){
                NSLog(@"merde");
            }

            UIImage* avatar2 = [[[[UIImage imageWithData:avatarReq.responseData] imageWithSize:CGSizeMake(88, 88)]imageWithRadius:2] imageWithMask:[UIImage imageNamed:@"mask_44@2x.png"]] ;
            NSData* imgData2 = UIImagePNGRepresentation(avatar2);
            NSString *cachePath2 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path2 = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png",[[dic2 objectForKey:@"author"] objectForKey:@"username"]]];
            
            if (![imgData2 writeToFile:path2 options:NSDataWritingAtomic error:nil]){
                NSLog(@"merde2");
            }

            if (dic2!=nil){
                NSMutableDictionary* dic12= [[NSMutableDictionary alloc] init];
                [dic12 setObject:[[dic2 objectForKey:@"author"] objectForKey:@"name"] forKey:@"name"];
                [dic12 setObject:[[dic2 objectForKey:@"author"] objectForKey:@"location"] forKey:@"location"];
                [dic12 setObject:[[dic2 objectForKey:@"author"] objectForKey:@"website"] forKey:@"website"];
                [dic12 setObject:[[dic2 objectForKey:@"author"] objectForKey:@"username"] forKey:@"username"];
                [currentSection addObject:dic12];
                
            }
        }
    }
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:@"plop.plist"];
    
    [myDic writeToFile:path atomically:YES];
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"newspaperCell";
    UITableViewCell* cell= [self.table dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"username"]]];
    cell.textLabel.text=[[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text=[[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"location"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* username = [[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"username"];
    NSString* url = [NSString stringWithFormat:@"http://storify.com/%@.json",username];
    Search* search =[[[Search alloc] initWithNibName:@"Search" bundle:nil] autorelease];
    search.searchedString=url;
    search.defaultImage=[[NSBundle mainBundle] URLForResource:[[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"username"] withExtension:@"png"];
    search.title = [[[self.newspapers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:search animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"U.S. East Cost";
            break;
        case 1:
            return @"U.S. Midwest";
            break;
        case 2:
            return @"U.S. West Coast";
            break;
        case 3:
            return @"Canada";
            break;
        case 4:
            return @"Europe";
            break;
        case 5:
            return @"Asia";
            break;
        case 6:
            return @"Oceania";
            break;
            
        default:
            return @"";
            break;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.newspapers objectAtIndex:section] count];
}


@end
