//
//  PostingViewController.h
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDAVAssetExportSession.h"
#import <AVFoundation/AVFoundation.h>
#import "Base64.h"
#import "ProductDetailCellCar.h"
#import "ProductDetailCellProperty.h"



@interface PostingViewController : UIViewController

@property (nonatomic,retain)NSString *name;

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(IBAction)OnClick_btn:(id)sender;


@property (strong,nonatomic)ProductDetailCellCar * Cell_DetailCar;
@property (strong,nonatomic)ProductDetailCellProperty * Cell_DetailProperty;

@end
