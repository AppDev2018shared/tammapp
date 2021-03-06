//
//  MyPostViewController.h
//  Haraj_app
//
//  Created by Spiel on 12/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterPrice.h"
#import "DetailTableViewCell.h"
#import "DetailCarTableViewCell.h"
#import "DetailPropertyTableViewCell.h"
#import "PostHeaderTableViewCell.h"
#import "CommentsTableViewCell.h"
#import "PostFooterTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDAVAssetExportSession.h"
#import <AVFoundation/AVFoundation.h>
@interface MyPostViewController : UIViewController
{
    UIView *transparentView,*transparentView1,*grayView;
}
@property  NSUInteger pageIndex;
@property (strong,nonatomic)DetailTableViewCell * detailCell;
@property (strong,nonatomic)DetailCarTableViewCell * detailCellCar;
@property (strong,nonatomic)DetailPropertyTableViewCell * detailCellProperty;

@property (strong,nonatomic)PostHeaderTableViewCell * cell_postcomments;
@property (strong,nonatomic)CommentsTableViewCell * ComCell;
@property (strong,nonatomic)PostFooterTableViewCell * cell_seeallcomments;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray * Array_UserInfo;
@property (nonatomic)NSInteger swipeCount;

@property (strong,nonatomic)NSMutableArray * Array_All_UserInfo;
@property (nonatomic, strong) NSArray *MoreImageArray;

@property (strong, nonatomic) NSURL *videoURL;
@end
