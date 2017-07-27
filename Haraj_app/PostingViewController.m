//
//  PostingViewController.m
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "PostingViewController.h"
#import "AddImageCell.h"
#import "ProductDetailCell.h"
#import "ProductDetailCellCar.h"
#import "ProductDetailCellProperty.h"
#import "MoreDetailCell.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "BoostPost.h"



@interface PostingViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    MoreDetailCell *moreCell;
    AddImageCell *imageCell;
    ProductDetailCell *detailCell;
    NSUserDefaults * defaults;
    UIImage *chosenImage ;
    UIImageView *imageView,*Image_View;
    UIImagePickerController *imagePicker, *cameraUI, *pcker1;
    NSInteger count,imageCount;
    NSMutableArray *imageArray, *array_MediaTypes, *array_VideoUrl,* Array_mediaTypeId, *ImageId;
    
    UILabel *sellingPlaceholder,*hashPlaceholder,*morePlaceholder,*Label_confirm1;
    
    UIView * transperentViewIndicator,*whiteView1,* transperentViewIndicator11,*whiteView111;
    UIActivityIndicatorView *indicatorAlert;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Create, *Connection_Media;
    NSMutableData *webData_Create, *webData_Media;
    NSMutableArray *Array_Create, *Array_Media,*Array_RemovePicture;
    NSString * locationName, *cellloop;
    NSString *postIDValue ,*mediaTypeVal,* ImageNSdata,*ImageNSdataThumb, *encodedImage, *encodedImageThumb, *mediaIdStr, *imageTag, *removeIndexCount, *propertyType;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    UIImage *FrameImage;
    NSNumber *Vedio_Height,*Vedio_Width;
    NSData *imageData,*imageDataThumb;
    MPMoviePlayerViewController *movieController ;
    NSInteger indexCount , x;
    UILabel *KMlabel, *Sqmlabel;
    
    
  
    CLPlacemark *placemark;
    BOOL location;
    NSString *TEXT;
    
    BoostPost *myBoostXIBViewObj;
    NSString *boostpackVal,*boostAmountVal, *postIdVal;
    NSMutableArray *Array_Boost;
    
    
    NSArray *pickerArray;
    UIPickerView *carPickerView;
    UIToolbar *toolBar;


    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PostingViewController
@synthesize nameLabel,Cell_DetailCar,Cell_DetailProperty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    indexCount = 0;
    imageCount = 0;
    count = 0;
    imageArray = [[NSMutableArray alloc]init];
    array_MediaTypes = [[NSMutableArray alloc]init];
    array_VideoUrl = [[NSMutableArray alloc]init];
    Array_mediaTypeId= [[NSMutableArray alloc]init];
    ImageId = [[NSMutableArray alloc]init];

    Image_View = [[UIImageView alloc]init];
    pcker1=[[UIImagePickerController alloc]init];
     pcker1.delegate = self;
    
    defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"NO" forKey:@"CallPressed"];
    
    [defaults setObject:@"1" forKey:@"slival"];
    [defaults synchronize];

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
   // NSString *nameStr = [NSString stringWithFormat:@"POST YOUR %@",self.name];

    
   
    
    nameLabel.text = [NSString stringWithFormat:@"Post your %@",self.name];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:26];
    nameLabel.textColor = [UIColor whiteColor];
   
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.tableView addGestureRecognizer: tapRec];
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
  //---------------------------POST ID Creating ---------------------------------------------------------------
    
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [[NSMutableString alloc]init];
    for (int i=0; i<3; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    NSLog(@" Random String=%@",randomString);
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@" date=%@",[dateFormatter stringFromDate:[NSDate date]]);
    postIDValue = [NSString stringWithFormat:@"P%@%@",[dateFormatter stringFromDate:[NSDate date]],randomString];
    NSLog(@"postIDValue %@",postIDValue);
    

   
    
    transperentViewIndicator=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transperentViewIndicator.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    whiteView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 110,110)];
    whiteView1.center=transperentViewIndicator.center;
    [whiteView1 setBackgroundColor:[UIColor blackColor]];
    whiteView1.layer.cornerRadius=9;
    indicatorAlert = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorAlert.frame=CGRectMake((whiteView1.frame.size.width/2)-10, (whiteView1.frame.size.height/2)-15, 20, 20);
    [indicatorAlert startAnimating];
    [indicatorAlert setColor:[UIColor whiteColor]];
    
    Label_confirm1=[[UILabel alloc]initWithFrame:CGRectMake(0,(indicatorAlert.frame.size.height+indicatorAlert.frame.origin.y)+5, whiteView1.frame.size.width, 40)];
    
    
    Label_confirm1.text=@"Preparing...";
    Label_confirm1.font=[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16.0];
    Label_confirm1.textColor=[UIColor whiteColor];
    Label_confirm1.textAlignment=NSTextAlignmentCenter;
    
    
    [whiteView1 addSubview:indicatorAlert];
    
    [whiteView1 addSubview:Label_confirm1];
    
    [transperentViewIndicator addSubview:whiteView1];
    
     transperentViewIndicator11.hidden=YES;
    
    
    NSLocale *abc =[NSLocale currentLocale];
    NSString * xyz = [abc objectForKey:NSLocaleCountryCode];
    NSLog(@" country code%@",xyz);
    
    NSString * xyz1 = [abc displayNameForKey:NSLocaleCountryCode value:xyz];
    NSLog(@" country name %@",xyz1);
    
    sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
    hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
    
    
    
    propertyType = @"RENT";
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];


    

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithTitle:@""
                            style:UIBarButtonItemStylePlain
                            target:self
                            action:@selector(OnClick_btn:)];
    [btn setImage:[UIImage imageNamed:@"Whitearrow"]];
    
    btn.tintColor= [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btn;

}

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    [[self view] endEditing: YES];
}

-(void)galleryButtonPressed:(id)sender
{
    
    mediaTypeVal = @"IMAGE";
    NSLog(@"galleryButtonPressed Pressed");

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:true completion:nil];
    }
}

-(void)videoButtonPressed:(id)sender
{
    
    mediaTypeVal = @"VIDEO";
    NSLog(@"videoButtonPressed Pressed");
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
    
}
-(void)cameraButtonPressed:(id)sender
{
    
    
    mediaTypeVal = @"IMAGE";
    NSLog(@"cameraButtonPressed Pressed");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:true completion:nil];
    }
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    // UIImage *flippedImage = [UIImage imageWithCGImage:picture.CGImage scale:picture.scale orientation:UIImageOrientationLeftMirrored];
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    cameraUI.videoQuality = UIImagePickerControllerQualityType640x480;
    
    cameraUI.showsCameraControls = YES;
    cameraUI.videoMaximumDuration = 15.0f;
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    //    self.videoTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
    //    remainingCounts = 60;
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
}








-(IBAction)OnClick_btn:(id)sender
{
    if ([[defaults valueForKey:@"PlusButtonPressed"] isEqualToString:@"profilepost"])
    {
        [defaults setObject:@"" forKey:@"PlusButtonPressed"];
        [self communication_cancelPost];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:YES];
        

    }
    else
    {
        
        [self communication_cancelPost];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popToRootViewControllerAnimated:YES];

        
    }
    
    
}
-(void)communication_cancelPost
{
  
    
    NSString *postid= @"postid";

    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postIDValue,userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"cancelpost"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                
                                                                                               
                                             }
                                             
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource and Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cell_detailcar=@"CellCar";
    static NSString *cell_detailproperty=@"CellProperty";
    

    
    
    switch (indexPath.section)
    {
        case 0:
        {
            imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
            
            [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.videoButton  addTarget:self action:@selector(videoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.cameraButton  addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect workingFrame =  imageCell.scrollView.frame;
            workingFrame.origin.x = 0;
             x = (imageArray.count *110) - 100;
            [imageCell.scrollView setContentOffset:CGPointMake((imageArray.count *110)-375, 0)];
            [imageCell.scrollView setContentSize:CGSizeMake((imageArray.count *110), workingFrame.size.height)];
            if(x<=339)
            {
                x=imageCell.scrollView.frame.size.width-110;
                [imageCell.scrollView setContentOffset:CGPointMake((3 *100)-375, 0)];
                [imageCell.scrollView setContentSize:CGSizeMake((3 *100), workingFrame.size.height)];
            }
           
            
            [imageCell.scrollView setPagingEnabled:YES];
          
            
            if (imageArray.count>3)
            {
                imageCell.scrollView.scrollEnabled = YES;
            }
            else
            {
                imageCell.scrollView.scrollEnabled = NO;
            }
            for(UIImageView* view in imageCell.scrollView.subviews)
            {
                
                [view removeFromSuperview];
                
            }

            
            for (int i=0; i<imageArray.count; i++)
                
            {
                
                imageView=[[UIImageView alloc]init];
                imageView.frame=CGRectMake(x,0, 100, imageCell.scrollView.frame.size.height);
                [imageView setTag:i];
                imageView.userInteractionEnabled=YES;
                imageView.image=[imageArray objectAtIndex:i];
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                
                
//                UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                           action:@selector(ImageTapped:)];
//                [imageView addGestureRecognizer:ImageTap];
                
                UIImageView *playButton = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width / 2) - 20, (imageView.frame.size.height / 2) - 20, 40, 40)];
                playButton.backgroundColor = [UIColor clearColor];
                [playButton setImage:[UIImage imageNamed:@"Play"]];
//                UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(ImageTapped:)];
//                [playButton addGestureRecognizer:ImageTap1];
                playButton.tag = i;
                [imageView addSubview:playButton];
                
              
                
                
                [imageCell.scrollView addSubview:imageView];
                [imageCell.contentView bringSubviewToFront:imageView];
                if ([[array_MediaTypes objectAtIndex:i] isEqualToString:@"VIDEO"])
                {
                    playButton.hidden = NO;
                }
                else
                {
                    playButton.hidden = YES;
                    
                }
                
                
                NSLog(@"INDEXC OF image arrsy=%d",i);
                for (int j = 0; j < Array_mediaTypeId.count; j++)
                    {
                        NSLog(@"INDEXC OF image arrsy=%d",j);
                        NSLog(@"INDEXC OF imageiii arrsy=%d",i);
                        NSLog(@"Array_mediaTypeId OF values arrsy=%@",[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]);
                         NSLog(@"ImageId OF values ImageId=%@",[ImageId objectAtIndex:i]);

                        if ([[ImageId objectAtIndex:i] isEqualToString:[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]])
                        {
                            NSLog(@"INDEXC OF image arrsy11111=%d",j);
                            NSLog(@"INDEXC OF imageiii arrsy1111=%d",i);
                            NSLog(@"Array_mediaTypeId OF values1111 arrsy1111=%@",[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]);
                            NSLog(@"ImageId OF values ImageId111111=%@",[ImageId objectAtIndex:i]);

                            UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(ImageTapped:)];
                            [imageView addGestureRecognizer:ImageTap];
                            
                                            UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                            action:@selector(ImageTapped:)];
                                            [playButton addGestureRecognizer:ImageTap1];


                            imageView.alpha = 1;
                            break;
                            
                        }
                        else
                            
                        {
                            UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(ImageTappedRemove:)];
                            [imageView addGestureRecognizer:ImageTap];
                            
                            UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                            action:@selector(ImageTappedRemove:)];
                            [playButton addGestureRecognizer:ImageTap1];

                            imageView.alpha = 0.5;
                        }
                        
                }

                x -= 110;

            }
            x=0;
           
          return imageCell;
            
        }
            break;
        case 1:
            
            
            if ([self.name isEqualToString:@"car"])
            {
                
                
                
                {
                    
                    Cell_DetailCar = [[[NSBundle mainBundle]loadNibNamed:@"ProductDetailCellCar" owner:self options:nil] objectAtIndex:0];
                    
                    
                    if (Cell_DetailCar == nil)
                    {
                        
                        Cell_DetailCar = [[ProductDetailCellCar alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_detailcar];
                        
                    }
                    
                    Cell_DetailCar.profileImageView.layer.cornerRadius = Cell_DetailCar.profileImageView.frame.size.height / 2;
                    Cell_DetailCar.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [Cell_DetailCar.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
                    
                    Cell_DetailCar.usernameLabel.text = [defaults valueForKey:@"UserName"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    Cell_DetailCar.locationLabel.text = locationstr;
                    
                    [Cell_DetailCar.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    if ([Cell_DetailCar.sellingTextview.text isEqualToString:@"What are you selling?"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""] )
                    {
                        Cell_DetailCar.sellingTextview.text = @"What are you selling?";
                        Cell_DetailCar.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    [Cell_DetailCar.carMakeTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailCar.modelTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailCar.mileageTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                   
                    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    Cell_DetailCar.carMakeTextField.inputView = dummyView;
                    


                    
                    [Cell_DetailCar.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
      //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder.text = @"This is your post headline";
                    sellingPlaceholder.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailCar.sellingTextview addSubview:sellingPlaceholder];
                    [Cell_DetailCar.contentView bringSubviewToFront:sellingPlaceholder];
                    
                    
                    Cell_DetailCar.hashTextView.delegate=self;
                    
                    if ([Cell_DetailCar.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [Cell_DetailCar.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        Cell_DetailCar.hashTextView.text = @"Add some #Hashtags";
                        Cell_DetailCar.hashTextView.textColor = [UIColor blackColor];
                    }
                    Cell_DetailCar.sellingTextview.tag = 2;
                    [Cell_DetailCar.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
                    //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailCar.hashTextView addSubview:hashPlaceholder];
                    [Cell_DetailCar.contentView bringSubviewToFront:hashPlaceholder];
                    
                    
                    

                    
                    
                    
                    return Cell_DetailCar;
                }
                
            }
            
            
            if ([self.name isEqualToString:@"property"])
            {
                
                
                {
                    
                    Cell_DetailProperty = [[[NSBundle mainBundle]loadNibNamed:@"ProductDetailCellProperty" owner:self options:nil] objectAtIndex:0];
                    
                    
                    
                    
                    if (Cell_DetailProperty == nil)
                    {
                        
                        Cell_DetailProperty = [[ProductDetailCellProperty alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_detailproperty];
                        
                        
                    }
                    
                    Cell_DetailProperty.profileImageView.layer.cornerRadius = Cell_DetailProperty.profileImageView.frame.size.height / 2;
                    Cell_DetailProperty.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [Cell_DetailProperty.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
                    
                    Cell_DetailProperty.usernameLabel.text = [defaults valueForKey:@"UserName"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    Cell_DetailProperty.locationLabel.text = locationstr;
                    [Cell_DetailProperty.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
    
                    
                    if ([Cell_DetailProperty.sellingTextview.text isEqualToString:@"What are you selling?"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""] )
                    {
                        Cell_DetailProperty.sellingTextview.text = @"What are you selling?";
                        Cell_DetailProperty.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    
                    [Cell_DetailProperty.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
                    //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder.text = @"This is your post headline";
                    sellingPlaceholder.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailProperty.sellingTextview addSubview:sellingPlaceholder];
                    [Cell_DetailProperty.contentView bringSubviewToFront:sellingPlaceholder];
                    
                    
                    Cell_DetailProperty.hashTextView.delegate=self;
                    
                    if ([Cell_DetailProperty.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [Cell_DetailCar.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        Cell_DetailProperty.hashTextView.text = @"Add some #Hashtags";
                        Cell_DetailProperty.hashTextView.textColor = [UIColor blackColor];
                    }
                    Cell_DetailProperty.sellingTextview.tag = 2;
                    [Cell_DetailProperty.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
       //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailProperty.hashTextView addSubview:hashPlaceholder];
                    [Cell_DetailProperty.contentView bringSubviewToFront:hashPlaceholder];
                    
                    [Cell_DetailProperty.rentButton  addTarget:self action:@selector(rentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [Cell_DetailProperty.saleButton  addTarget:self action:@selector(saleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    Cell_DetailProperty.propertySizeTextField.delegate = self;
                    Cell_DetailProperty.noOfBedroomTextField.delegate = self;
                    
                    [Cell_DetailProperty .propertySizeTextField bringSubviewToFront:Cell_DetailProperty];
                    
                    
                    [Cell_DetailProperty.propertySizeTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailProperty.noOfBedroomTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    
                    
                    return Cell_DetailProperty;
                }
            }
            
            else
            {
                
                {
                    
                    
                    detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
                    
                    detailCell.profileImageView.layer.cornerRadius = detailCell.profileImageView.frame.size.height / 2;
                    detailCell.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [detailCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
                    
                    detailCell.usernameLabel.text = [defaults valueForKey:@"name"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    detailCell.locationLabel.text = locationstr;
                    [detailCell.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([detailCell.sellingTextview.text isEqualToString:@"What are you selling?"] || [detailCell.sellingTextview.text isEqualToString:@""] )
                    {
                        detailCell.sellingTextview.text = @"What are you selling?";
                        detailCell.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    
                    [detailCell.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
      //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder.text = @"This is your post headline";
                    sellingPlaceholder.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder.textAlignment = NSTextAlignmentRight;
                    [detailCell.sellingTextview addSubview:sellingPlaceholder];
                    [detailCell.contentView bringSubviewToFront:sellingPlaceholder];
                    
                    
                    detailCell.hashTextView.delegate=self;
                    
                    if ([detailCell.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [detailCell.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        detailCell.hashTextView.text = @"Add some #Hashtags";
                        detailCell.hashTextView.textColor = [UIColor blackColor];
                    }
                    detailCell.sellingTextview.tag = 2;
                    [detailCell.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
       //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [detailCell.hashTextView addSubview:hashPlaceholder];
                    [detailCell.contentView bringSubviewToFront:hashPlaceholder];
                    
                    
                    return detailCell;
                    
                }
            }
            break;
            
        case 2:
        {
            moreCell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
            
            moreCell.currentDays_Label.text =[NSString stringWithFormat:@"%.f",moreCell.slider.value];

            moreCell.slider.maximumValue = 30;
            moreCell.slider.minimumValue = 1;
            moreCell.slider.continuous = TRUE;
            [moreCell.slider  addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            moreCell.slider.tag = 1;
            
            moreCell.moreTextView.delegate =self;
            
            if ([moreCell.moreTextView.text isEqualToString:@"Tell us more about the product"] || [moreCell.moreTextView.text isEqualToString:@""] )
            {
                

            moreCell.moreTextView.text = @"Tell us more about the product";
            moreCell.moreTextView.textColor = [UIColor blackColor];
            }
            [detailCell.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];

            [moreCell.createButton  addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [moreCell.callButton  addTarget:self action:@selector(callButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
           
            
           
            
            
            return moreCell;
        }
            break;
            
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 271;
    }
    else if (indexPath.section == 1)
    {
        
        if ([self.name isEqualToString:@"car"])
        {
            return 378;
        }
        else  if ([self.name isEqualToString:@"property"])
        {
            return 422;
        }
        else
        {
            return 253;
        }
    }
    else if (indexPath.section == 2)
    {
        return 366;
    }
    
    
    return 0;
    
}


-(void)textField_Action:(id)sender
{
    if ([self.name isEqualToString:@"car"])
    {
        
        if (Cell_DetailCar.modelTextField.text.length == 0 || Cell_DetailCar.mileageTextField.text.length == 0)
        {
            moreCell.createButton.enabled = NO;
            moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
            
            
        }
        else
        {
            moreCell.createButton.enabled =YES;
            moreCell .createButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
            
        }
        
    }
    
    else if ([self.name isEqualToString:@"property"])
    {
        if (Cell_DetailProperty.propertySizeTextField.text.length == 0 || Cell_DetailProperty.noOfBedroomTextField.text.length == 0)
        {
            moreCell.createButton.enabled = NO;
            moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
            
            
        }
        else
        {
            moreCell.createButton.enabled =YES;
            moreCell .createButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
            
        }

        
    }
    
}


-(void)rentButtonPressed:(id)sender
{
    
    propertyType = @"RENT";
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];

    
}
-(void)saleButtonPressed:(id)sender
{
     propertyType = @"SALE";
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
    
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];

}



#pragma mark - UITextView and UITextField Delegates
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"What are you selling?"] || [textView.text isEqualToString:@""])
    {
        textView.text = @"";
        sellingPlaceholder.hidden = YES;
        moreCell.createButton.enabled = NO;
        [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    else
    {
        sellingPlaceholder.hidden = YES;
//        moreCell.createButton.enabled = YES;
//        [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];

    }
    
    
    if ([self.name isEqualToString:@"car"])
    {
        
        if (Cell_DetailCar.sellingTextview.text.length == 0)
        {
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        }
        
        
        if ([Cell_DetailCar.modelTextField.text isEqualToString:@""]  || [Cell_DetailCar.mileageTextField.text isEqualToString:@""]) {
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
    }
    
    else if([self.name isEqualToString:@"property"])
    {
        
        if (Cell_DetailProperty.sellingTextview.text.length == 0)
        {
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        }
        
        
        if ([Cell_DetailProperty.propertySizeTextField.text isEqualToString:@""]  || [Cell_DetailProperty.noOfBedroomTextField.text isEqualToString:@""]) {
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
    }
    else
    {
        
        if (detailCell.sellingTextview.text.length == 0)
        {
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        }
        
        
    }

    
    
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.name isEqualToString:@"car"])
    {
        
        
        
        
        if ([textView isEqual: Cell_DetailCar.sellingTextview])
        {
            if ([textView.text isEqualToString:@"What are you selling?"] || [textView.text isEqualToString:@""])
            {
                textView.text = @"";
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = NO;
                [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
               
                
            }
            else
            {
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = YES;
                [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
               

            }
            
            
        }
        
        else if ([textView isEqual: Cell_DetailCar.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
            }
        }
    }
    else if ([self.name isEqualToString:@"property"])
    {
        if ([textView isEqual: Cell_DetailProperty.sellingTextview])
        {
            if ([textView.text isEqualToString:@"What are you selling?"] || [textView.text isEqualToString:@""])
            {
                textView.text = @"";
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = NO;
                [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
                

                
            }
            else
            {
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = YES;
                [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
               
            }
            
            
        }
        
        else if ([textView isEqual: Cell_DetailProperty.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
            }
        }
        
        
    }
    
    else
    {
        
        
        if ([textView isEqual: detailCell.sellingTextview])
        {
            if ([textView.text isEqualToString:@"What are you selling?"] || [textView.text isEqualToString:@""])
            {
                textView.text = @"";
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = NO;
                [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
                

                
            }
            else
            {
                sellingPlaceholder.hidden = YES;
                moreCell.createButton.enabled = YES;
                [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
                

            }
            
            
        }
        
        else if ([textView isEqual: detailCell.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
            }
        }
        
    }
    
    
    if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@"Tell us more about the product"] )
        {
            textView.text = @"";
            moreCell.morePlaceholder.hidden = YES;
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([self.name isEqualToString:@"car"])
    {
        
        
        
        if ([textView isEqual: Cell_DetailCar.sellingTextview])
        {
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"What are you selling?";
                sellingPlaceholder.hidden = NO;
                moreCell.createButton.enabled = NO;
                moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                

            }
        }
        
        else if ([textView isEqual: Cell_DetailCar.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }
        
    }
    else if ([self.name isEqualToString:@"property"])
    {
        
        
        
        if ([textView isEqual: Cell_DetailProperty.sellingTextview])
        {
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"What are you selling?";
                sellingPlaceholder.hidden = NO;
                moreCell.createButton.enabled = NO;
                moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                
            }
        }
        
        else if ([textView isEqual: Cell_DetailProperty.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }
        
    }
    else
    {
        
        
        if ([textView isEqual: detailCell.sellingTextview])
        {
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"What are you selling?";
                sellingPlaceholder.hidden = NO;
                moreCell.createButton.enabled = NO;
                moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                
            }
        }
        
        else if ([textView isEqual: detailCell.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }

        
    }

      if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@""] )
        {
            textView.text = @"Tell us more about the product";
            moreCell.morePlaceholder.hidden = NO;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        return NO;
    }
    

  
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if  ([textField isEqual:Cell_DetailCar.mileageTextField])
    {
       // Cell_DetailCar.mileageTextField.text =@"";
        KMlabel.frame = CGRectMake(0, 0, 0, 0);
        KMlabel.hidden = YES;
       
    }
    
    if  ([textField isEqual:Cell_DetailProperty.propertySizeTextField])
    {
        Cell_DetailProperty.propertySizeTextField.text =@"";
        Sqmlabel.frame = CGRectMake(0, 0, 0, 0);
        Sqmlabel.hidden = YES;
        
    }
    
    
    if  ([textField isEqual:moreCell.askingPriceTextField])
    {
    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 220 -40);
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;

    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if  ([textField isEqual:moreCell.askingPriceTextField])
    {
        self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 220);
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:Cell_DetailCar.carMakeTextField])
    {
        
        
        self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 14);
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self addPickerView];
    }
    
    
    
    
    if (moreCell.askingPriceTextField.text.length  == 0)
    {
        moreCell.askingPriceTextField.text = @"$";
    }
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if ([Cell_DetailCar.mileageTextField.text isEqualToString:@""])
    {
        KMlabel.frame = CGRectMake(0, 0, 0, 0);
        KMlabel.hidden = YES;
    }
    else
    {
    
    KMlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    KMlabel.text = @" KM";
    KMlabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    Cell_DetailCar.mileageTextField.rightViewMode = UITextFieldViewModeAlways;
        Cell_DetailCar.mileageTextField.rightView = KMlabel;
        
    }
    
    if ([Cell_DetailProperty.propertySizeTextField.text isEqualToString:@""])
    {
        Sqmlabel.frame = CGRectMake(0, 0, 0, 0);
        Sqmlabel.hidden = YES;
        
    }
    else
    {
        
        Sqmlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
        Sqmlabel.text = @" (Sqm)";
        Sqmlabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        Cell_DetailProperty.propertySizeTextField.rightViewMode = UITextFieldViewModeAlways;
        Cell_DetailProperty.propertySizeTextField.rightView = Sqmlabel;
    
    }

    
}

    
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.name isEqualToString: @"car"])
    {
        
       
        
    }
    else if ([self.name isEqualToString:@"property"])
    {
        
    }
    else
    {
    
    NSString *newText = [moreCell.askingPriceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"$"])
    {
        return NO;
    }
        
    }
    
    // Default:
    return YES;
}

#pragma mark - Image Tapped Functionality

-(void)ImageTapped:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;

    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
     NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    Image_View = imageView1;
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
//                                    [imageArray removeObjectAtIndex:(long)imageView1.tag];
//                                    [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
//                                    [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                  //  NSString *indexStr = [NSString stringWithFormat:@"%d",imageView1.tag];
                                    
//                                    for (int i =0 ; i < ImageId.count; i++)
//                                    {
                                        for (int j=0; j < Array_mediaTypeId.count; j++)
                                        {
                                            if ([[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"] isEqualToString:[ImageId objectAtIndex:imageView1.tag]])
                                            {
                                                mediaIdStr = [[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"];
                                                
                                                [Array_mediaTypeId removeObjectAtIndex:j];
                                                [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                                [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                                [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                                [ImageId removeObjectAtIndex:(long)imageView1.tag];


                                                [self removePictureConnection];
                                                break;
                                            }
                                       // }
                                        
                                        
                                        
                                    }
                
                                    [self.tableView reloadData];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *playAlert;
    
    if ([[array_MediaTypes objectAtIndex:imageView1.tag] isEqualToString:@"IMAGE"])
    {


       playAlert =[UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              
                              {
                                  [self displayImage:Image_View withImage:imageView1.image];
                                  
                                  
                                  NSLog(@"playAlert button Pressed");
                                  
                              }];
    }
    else
    {
       
        playAlert =[UIAlertAction actionWithTitle:@"Play" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   
                                   {
                                       movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[array_VideoUrl objectAtIndex:imageView1.tag ]];
                                       
                                       
                                       [self presentMoviePlayerViewControllerAnimated:movieController];
                                       [movieController.moviePlayer prepareToPlay];
                                       [movieController.moviePlayer play];
                                       
                                       NSLog(@"playAlert button Pressed");
                                       
                                   }];
    
    }
    
    [alert addAction:playAlert];
    
    
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              
                              {
                                  
                                  NSLog(@"No button Pressed");
                                  
                              }];
    
    [alert addAction:cancelAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)ImageTappedRemove:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    
    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
    NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    Image_View = imageView1;
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
                                    //                                    [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                    //                                    [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                    //                                    [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                    //  NSString *indexStr = [NSString stringWithFormat:@"%d",imageView1.tag];
                                    
                                    //                                    for (int i =0 ; i < ImageId.count; i++)
                                    //                                    {
                                   
                                            [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                            [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                            [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                            [ImageId removeObjectAtIndex:(long)imageView1.tag];
                                    
                                            removeIndexCount =  [ImageId objectAtIndex:(long)imageView1.tag];

                                    
                                    [self.tableView reloadData];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  
                                  {
                                      
                                      NSLog(@"No button Pressed");
                                      
                                  }];
    
    [alert addAction:cancelAction];
        
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image
{
    [Image_View setImage:image];
    [Image_View setupImageViewer1];
   
}

#pragma mark - Slider Functionality for days

-(void)sliderChanged:(UISlider*)sender{
   
    if (sender.tag == 1)
    {
        moreCell.currentDays_Label.text =[NSString stringWithFormat:@"%.f",sender.value];
        NSLog(@"%.f",sender.value);
        
        CGRect trackRect = [moreCell.slider trackRectForBounds:moreCell.slider.bounds];
        CGRect thumbRect = [moreCell.slider thumbRectForBounds:moreCell.slider.bounds
                                                 trackRect:trackRect
                                                     value:moreCell.slider.value];
        moreCell.currentDays_Label.center = CGPointMake(thumbRect.origin.x + moreCell.slider.frame.origin.x + 14,  moreCell.slider.frame.origin.y - 10);
        
        [defaults setObject:moreCell.currentDays_Label.text forKey:@"slival"];
        [defaults synchronize];

    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
    if ([mediaTypeVal isEqualToString:@"VIDEO"])
    {
       
        
        self.videoURL = info[UIImagePickerControllerMediaURL];
        
        
        
        mediaTypeVal=@"VIDEO";
        self.videoURL = info[UIImagePickerControllerMediaURL];
        
        [array_VideoUrl addObject:self.videoURL];
        
        NSData* videoData = [NSData dataWithContentsOfFile:[self.videoURL path]];
        
        int videoSize = [videoData length]/1024/1024;
        
        
        NSLog(@"data size==%d",videoSize);
        
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
        
        
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generateImg.appliesPreferredTrackTransform = YES;
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 7);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        NSLog(@"error==%@, Refimage==%@", error, refImg);
        
        [array_MediaTypes addObject:mediaTypeVal];
        FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        [imageArray addObject:FrameImage];
        
        
        
        NSLog(@"FrameImage height size==%f",FrameImage.size.height);
        NSLog(@"FrameImage width %fze==%f",FrameImage.size.width);
        
        
        
        if (FrameImage.size.height > FrameImage.size.width)
        {
            Vedio_Height=@960;
            Vedio_Width=@540;
        }
        else
        {
            Vedio_Height=@540;
            Vedio_Width=@960;
        }
        
        
        
        pcker1=picker;
        
        [self RecordingVediosImagepicker];
        
        
        
    }
    else
    {
        
        [array_VideoUrl addObject:@""];
       
        //chosenImage = info[UIImagePickerControllerEditedImage];
        chosenImage = info[UIImagePickerControllerOriginalImage];
        
          [imageArray addObject:chosenImage];
        [array_MediaTypes addObject:mediaTypeVal];
      //  NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
        imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
        // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        ImageNSdata = [Base64 encode:imageData];
        
        
        encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        [self postMediaConnection];
        //[self viewImgCrop];
        // [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    indexCount +=1;
    [ImageId addObject:[NSString stringWithFormat:@"%ld",(long)indexCount]];
    
    
   //  [self.tableView reloadData];
    
    
    [self.tableView beginUpdates];
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
}

-(void)RecordingVediosImagepicker
{
    [pcker1.view addSubview:transperentViewIndicator];
    
    NSString *finalVideoURLString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    finalVideoURLString = [finalVideoURLString stringByAppendingPathComponent:@"compressedVideo.mp4"];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:finalVideoURLString withIntermediateDirectories:YES attributes:nil error:nil];
    [manager removeItemAtPath:finalVideoURLString error:nil];
    
    NSURL *outputVideoUrl = ([[NSURL URLWithString:finalVideoURLString] isFileURL] == 1)?([NSURL URLWithString:finalVideoURLString]):([NSURL fileURLWithPath:finalVideoURLString]); // Url Should be a file Url, so here we check and convert it into a file Url
    
    
    
    SDAVAssetExportSession *compressionEncoder = [SDAVAssetExportSession.alloc initWithAsset:[AVAsset assetWithURL:_videoURL]]; // provide inputVideo Url Here
    compressionEncoder.outputFileType = AVFileTypeMPEG4;
    compressionEncoder.outputURL = outputVideoUrl;
    compressionEncoder.shouldOptimizeForNetworkUse = YES;//Provide output video Url here
    compressionEncoder.videoSettings = @
    
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: Vedio_Width,   //Set your resolution width here
    AVVideoHeightKey: Vedio_Height,  //set your resolution height here
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @2000000, // Give your bitrate here for lower size give low values
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    compressionEncoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [compressionEncoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (compressionEncoder.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"Compression Export Completed Successfully");
             
             NSData* videoData = [NSData dataWithContentsOfFile:[outputVideoUrl path]];
             int videoSize = [videoData length]/1024/1024;
             
             // [self.videoURL path]
             NSLog(@"data size path==%d",videoSize);
             
             imageData=[NSData dataWithContentsOfFile:[outputVideoUrl path]];
             // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
             
             ImageNSdata = [Base64 encode:imageData];
             
             encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
             
             
             self.videoController = [[MPMoviePlayerController alloc] init];
             
             [self.videoController setContentURL:outputVideoUrl];
             
             
             
             [self.videoController setScalingMode:MPMovieScalingModeAspectFill];
             _videoController.fullscreen=YES;
             _videoController.allowsAirPlay=NO;
             _videoController.shouldAutoplay=YES;
             
             
             
             imageDataThumb = UIImageJPEGRepresentation(FrameImage, 1.0);
             
             
             ImageNSdataThumb = [Base64 encode:imageDataThumb];
             
             
             encodedImageThumb = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdataThumb,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
             
             [pcker1.view hideActivityViewWithAfterDelay:1];
             
             [pcker1 dismissViewControllerAnimated:YES completion:nil];
             [self postMediaConnection];
             
         }
         else if (compressionEncoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Compression Export Canceled");
             
             NSLog(@"Compression Failed==%@",compressionEncoder.error);
             UIAlertController * alert=[UIAlertController
                                        
                                        alertControllerWithTitle:@"Compression Canceled" message:@"Compression Export Canceled. Please try again." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"ReCompress"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             [self RecordingVediosImagepicker];
                                             
                                         }];
             UIAlertAction* noButton = [UIAlertAction
                                        actionWithTitle:@"Cancel"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self.view hideActivityViewWithAfterDelay:0];
                                            [self dismissModalViewControllerAnimated:YES];
                                            //[pcker1 dismissViewControllerAnimated:YES completion:NULL];
                                            
                                        }];
             
             [alert addAction:yesButton];
             [alert addAction:noButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         else
         {
             NSLog(@"Compression Failed==%@",compressionEncoder.error);
             UIAlertController * alert=[UIAlertController
                                        
                                        alertControllerWithTitle:@"Compression Error" message:@"Could not compress your video. Please try again." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"ReCompress"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             [self RecordingVediosImagepicker];
                                             
                                         }];
             UIAlertAction* noButton = [UIAlertAction
                                        actionWithTitle:@"Cancel"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self.view hideActivityViewWithAfterDelay:0];
                                            [pcker1 dismissViewControllerAnimated:YES completion:NULL];
                                            
                                        }];
             
             [alert addAction:yesButton];
             [alert addAction:noButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }
     }];
    
    [self dismissModalViewControllerAnimated:YES];


    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createButtonPressed:(id)sender
{
    [detailCell.hashTextView resignFirstResponder];
    
     [self.view showActivityViewWithLabel:@"Creating post..."];
    
    
    NSLog(@"createButtonPressed");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    else
    {
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"createpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal = postIDValue;    //[defaults valueForKey:@"postid"];
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        
        NSString *title;
        NSString *titleVal;
        NSString *hashtags;
        NSString *hashtagsVal;
        
        
        
        
        

        
        if ([self.name isEqualToString:@"car"])
        {
            
            
             if ([Cell_DetailCar.sellingTextview.text isEqualToString:@"What are you selling?"])
             {
                 title= @"title";
                 titleVal = @"";
             }
            else
            {
                
                title= @"title";
                titleVal =Cell_DetailCar.sellingTextview.text;
            }
           
            
            
            if ([Cell_DetailCar.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = Cell_DetailCar.hashTextView.text;
                
            }
            
        }
        else if ([self.name isEqualToString:@"property"])
        {
//            title= @"title";
//            titleVal =Cell_DetailProperty.sellingTextview.text;// [defaults valueForKey:@"title"];
            
            if ([Cell_DetailProperty.sellingTextview.text isEqualToString:@"What are you selling?"])
            {
                title= @"title";
                titleVal = @"";
            }
            else
            {
                
                title= @"title";
                titleVal =Cell_DetailProperty.sellingTextview.text;
            }
            
            
            
    
            if ([Cell_DetailProperty.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = Cell_DetailProperty.hashTextView.text;
                
            }
            
        }
        else
        {
            
//            title= @"title";
//            titleVal =detailCell.sellingTextview.text;// [defaults valueForKey:@"title"];
            
            if ([detailCell.sellingTextview.text isEqualToString:@"What are you selling?"])
            {
                title= @"title";
                titleVal = @"";
            }
            else
            {
                
                title= @"title";
                titleVal =detailCell.sellingTextview.text;
            }
            

            if ([detailCell.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = detailCell.hashTextView.text;
                
            }
            
            
            
        }
        
        NSString *carmake = @"carmake";
        NSString *carmakeVal = Cell_DetailCar.carMakeTextField.text;

        
        NSString *carmodel = @"carmodel";
        NSString *carmodelVal = Cell_DetailCar.modelTextField.text;
        NSString *carmileage = @"carmileage";
        NSString *carmileageVal = Cell_DetailCar.mileageTextField.text;
        
        
        NSString *propertytype = @"propertytype";
        NSString *propertytypeVal = propertyType;
        
        NSString *propertysize = @"propertysize";
        NSString *propertysizeVal = Cell_DetailProperty.propertySizeTextField.text;
        NSString *noofrooms = @"noofrooms";
        NSString *noofroomsVal = Cell_DetailProperty.noOfBedroomTextField.text;
        
        
        
        
        
        

        
        
        
        NSString *allowcalls= @"allowcalls";
        NSString *allowcallsVal = [defaults valueForKey:@"CallPressed"];
        
//        NSString *enddays= @"enddays";
//        NSString *enddaysVal = [defaults valueForKey:@"slival"];
        
        NSString *askingprice;
        NSString *askingpriceVal;
        if ([moreCell.askingPriceTextField.text isEqualToString:@""])
        {
            askingprice= @"askingprice";
            askingpriceVal = @"0" ;
        }
        else
        {
            NSString *askingpriceValString = [NSString stringWithFormat:@"%@",moreCell.askingPriceTextField.text];
            askingpriceValString = [askingpriceValString substringFromIndex:1];
            askingprice= @"askingprice";
            askingpriceVal =askingpriceValString;
        }
        
        NSString *description;
        NSString *descriptionVal;
        if ([ moreCell.moreTextView.text isEqualToString:@"Tell us more about the product"] )
        {
          description= @"description";
          descriptionVal = @"";
            
        }
        else
        {
            description= @"description";
            descriptionVal = moreCell.moreTextView.text;
        }
        
        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];
        NSString *country= @"country";
        NSString *countryVal =[defaults valueForKey:@"Countryname"];
        NSString *category= @"category";
        NSString *categoryVal = self.name;
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,title,titleVal,allowcalls,allowcallsVal,askingprice,askingpriceVal,description,descriptionVal,hashtags,hashtagsVal,city,cityVal,country,countryVal,category,categoryVal,carmake,carmakeVal,carmodel,carmodelVal,carmileage,carmileageVal,propertytype,propertytypeVal,propertysize,propertysizeVal,noofrooms,noofroomsVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Create = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Create)
            {
                webData_Create =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    
}

-(void)callButtonPressed:(id)sender
{
    NSLog(@"callButtonPressed");
    
    if ([[defaults valueForKey:@"CallPressed"] isEqualToString:@"NO"])
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgreen"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"YES";
        moreCell.callLabel.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [defaults setObject:@"YES" forKey:@"CallPressed"];
    }
    else
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgrey"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"NO";
        moreCell.callLabel.textColor = [UIColor lightGrayColor];
        [defaults setObject:@"NO" forKey:@"CallPressed"];
    }
    
}

#pragma mark - NSURL CONNECTION

-(void)postMediaConnection
{
    
    NSLog(@"createButtonPressed");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    else
    {
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"uploadpostmedia"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal = postIDValue;
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *indexid= @"indexid";
        NSString *indexidVal =[NSString stringWithFormat:@"%ld",(long)indexCount];
        
        
        NSString *media= @"media";
        NSString *mediaVal =encodedImage;
        
        NSString *mediathumbnail= @"mediathumbnail";
        NSString *mediathumbnailVal = encodedImageThumb;
        
        NSString *mediatype= @"mediatype";
        NSString *mediatypeVal = mediaTypeVal;
        
        NSString *height= @"height";
        NSString *heightVal =[NSString stringWithFormat:@"%@",Vedio_Height];
        NSString *width= @"width";
        NSString *widthVal = [NSString stringWithFormat:@"%@",Vedio_Width];;
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,indexid,indexidVal,media,mediaVal,mediathumbnail,mediathumbnailVal,mediatype,mediatypeVal,height,heightVal,width,widthVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Media = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Media)
            {
                webData_Media =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }

    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"errorr===%@",error);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"Error in creating post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_Create)
    {
        [webData_Create setLength:0];
        
        
    }
    if(connection==Connection_Media)
    {
        [webData_Media setLength:0];
        
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Create)
    {
        [webData_Create appendData:data];
    }
    if(connection==Connection_Media)
    {
        [webData_Media appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_Create)
    {
        
        Array_Create=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_Create=[objSBJsonParser objectWithData:webData_Create];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Create encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_Create);
        NSLog(@"registration_status %@",[[Array_Create objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        if ([ResultString isEqualToString:@"done"])
        {
            
             [self.view hideActivityViewWithAfterDelay:0];
            
#pragma mark - Boost
            
            
            transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
            
            myBoostXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"BoostPost" owner:self options:nil]objectAtIndex:0];
            
            myBoostXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myBoostXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myBoostXIBViewObj.frame.size.width, myBoostXIBViewObj.frame.size.height);
            
            
            [self.view addSubview:myBoostXIBViewObj];
         
            myBoostXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"POST ID: %@",postIDValue];
  
            
            myBoostXIBViewObj.layer.cornerRadius = 10;
            myBoostXIBViewObj.clipsToBounds = YES;
            
            myBoostXIBViewObj.boostTextLabel.text = @"Your post has been successfully created! You can also Boost your post to increase your visibility and it will be displayed at the top of your chosen category for limited time.";
            
            [myBoostXIBViewObj.imageViewButton1 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton1_Action:)];
            
            [myBoostXIBViewObj.imageViewButton1 addGestureRecognizer:viewTapped1];
            
            [myBoostXIBViewObj.imageViewButton2 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton2_Action:)];
            [myBoostXIBViewObj.imageViewButton2 addGestureRecognizer:viewTapped2];
            
            [myBoostXIBViewObj.imageViewButton3 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton3_Action:)];
            [myBoostXIBViewObj.imageViewButton3 addGestureRecognizer:viewTapped3];
            
            
            [myBoostXIBViewObj.closeButton addTarget:self action:@selector(boostCloseAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [transparentView1 addSubview:myBoostXIBViewObj];
            [self.view addSubview:transparentView1];
            
            
            
            
            
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Your post has been successfully created and posted on the platform. Thank-you!" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action)
//                                       {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
//                                           CATransition *transition = [CATransition animation];
//                                           transition.duration = 0.3;
//                                           transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                                           transition.type = kCATransitionPush;
//                                           transition.subtype = kCATransitionFromRight;
//                                           
//                                           [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//                                           
//                                           [self.navigationController popViewControllerAnimated:YES];
//                                           
//                                           
//                                       }];
//
//            
//            
//            [alertController addAction:actionOk];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    if (connection==Connection_Media)
    {
        
        Array_Media=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_Media=[objSBJsonParser objectWithData:webData_Media];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Media encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"Array_Media %@",Array_Media);
     
        NSLog(@"Array_Media_ResultString %@",ResultString);
        if (Array_Media != 0)
        {
            
            
    
                
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"done" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                                   style:UIAlertActionStyleDefault
//                                                                 handler:nil];
//                [alertController addAction:actionOk];
            
           //     [self presentViewController:alertController animated:YES completion:nil];
                [Array_mediaTypeId addObject:[Array_Media objectAtIndex:0]];
            
            
            
           // [self.tableView reloadData];
            
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];

            
                
        
            
        }
        

        else if ([ResultString isEqualToString:@"nouserid"])
        {
            
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nouserid" message:@"User account has been deleted or has been deactivated. Please contact our team at support@tammapp.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
       }
        else if ([ResultString isEqualToString:@"nomedia"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nomedia" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }

         else if ([ResultString isEqualToString:@"imageerror"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"imageerror" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }

        else if ([ResultString isEqualToString:@"error"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
       
    }

}

-(void)removePictureConnection
{
    [self.view endEditing:YES];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm App." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *postid= @"postid";
        NSString *postidVal =[defaults valueForKey:@"postid"];
        
        NSString *media= @"media";
        NSString *mediaVal =encodedImage;
        
        NSString *indexid= @"indexid";
        


        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,postid,postidVal,media,mediaVal,indexid,removeIndexCount];
        
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"removepicture"];;
        url =[NSURL URLWithString:urlStrLivecount];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                         {
                                             if(data)
                                             {
                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                 NSInteger statusCode = httpResponse.statusCode;
                                                 if(statusCode == 200)
                                                 {
                                                     
                                                     Array_RemovePicture=[[NSMutableArray alloc]init];
                                                     SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     Array_RemovePicture=[objSBJsonParser objectWithData:data];
                                                     
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     //Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     NSLog(@"Array_AllData %@",Array_RemovePicture);
                                                     
                                                     
                                                     NSLog(@"Array_AllData ResultString %@",ResultString);
                                                     
                                                     
                                                     if (Array_RemovePicture.count !=0)
                                                     {
                                                         NSInteger serverid = [[[Array_RemovePicture objectAtIndex:0]valueForKey:@"indexid"] integerValue];
                                                         [ImageId removeObjectAtIndex:serverid];
                                                         [self.tableView reloadData];

                                                     }
                                                     
                                                     if ([ResultString isEqualToString:@"nouserid"])
                                                     {
                                                   
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your account does not exist or seems to have been suspended. Please contact admin." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault handler:nil];
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                         
                                                     }
                                                 }
                                                 
                                                 else
                                                 {
                                                     NSLog(@" error login1 ---%ld",(long)statusCode);
                                                     
                                                 }
                                                 
                                             }
                                             else if(error)
                                             {
                                                 
                                                 NSLog(@"error login2.......%@",error.description);
                                                 
                                             }
                                         }];
        [dataTask resume];
    }
    
}
-(IBAction)ChangeLocations:(id)sender
{
    locationManager = [[CLLocationManager alloc] init] ;
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy =kCLLocationAccuracyThreeKilometers; //kCLLocationAccuracyNearestTenMeters;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
             NSLog(@"placemark.country %@",placemark.country);
             NSLog(@"placemark.postalCode %@",placemark.postalCode);
             NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
             NSLog(@"placemark.locality %@",placemark.locality);
             NSLog(@"placemark.subLocality %@",placemark.subLocality);
             NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
             
             
             NSLog(@"placemark.subThoroughfare %@",[defaults valueForKey:@"Cityname"]);
             
             
             if (placemark.locality !=nil && placemark.country !=nil)
             {
                 
                 
                 [defaults setObject:placemark.locality forKey:@"Cityname"];
                 [defaults setObject:placemark.country forKey:@"Countryname"];
                 
                 locationName = placemark.locality ;
                 
                 
                 
                 [locationManager stopUpdatingLocation];
                 
                 
             }
             
             
         }
         else
         {
             NSLog(@"%@", error.debugDescription);
         }
     } ];
    
    [_tableView reloadData];
    
}


#pragma mark - Boost Post

-(void)boostCloseAction:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView1.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}
-(void)imageViewButton1_Action:(UIGestureRecognizer *)reconizer
{
    NSLog(@"imageViewButton1_Action");
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    
    boostpackVal = @"24H";
    boostAmountVal = @"4";
    [self boostConnection];
    
    
}



-(void)imageViewButton2_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    boostpackVal = @"48H";
    boostAmountVal = @"6";
    NSLog(@"imageViewButton2_Action");
    [self boostConnection];
    
}


-(void)imageViewButton3_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    NSLog(@"imageViewButton3_Action");
    boostpackVal = @"72H";
    boostAmountVal = @"10";
    [self boostConnection];
    
}

-(void)boostConnection
{
    NSString *postid= @"postid";
    
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *boostpack= @"boostpack";
    
    
    NSString *boostamount= @"boostamount";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postIDValue,userid,useridVal,boostpack,boostpackVal,boostamount,boostAmountVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"boostpost"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                 Array_Boost=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Boost =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Boost %@",Array_Boost);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Boosted" message:@"Thank-you for your payment, your post has been successfully boosted!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
//                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                                                                        style:UIAlertActionStyleDefault
//                                                                                                      handler:nil];
//                                                     [alertController addAction:actionOk];
//                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction *action)
                                                                                {
                                                                                    
                                                                                    
                                                                                    
                                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
                                                                                    CATransition *transition = [CATransition animation];
                                                                                    transition.duration = 0.3;
                                                                                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                                    transition.type = kCATransitionPush;
                                                                                    transition.subtype = kCATransitionFromRight;
                                                                                    
                                                                                    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                                                                    
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                    
                                                                                    
                                                                                }];
                                                     
                                                     
                                                     
                                                     [alertController addAction:actionOk];
                                                      [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                  
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"alreadyboosted"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your post is already boosted. Please wait for it to get over to boost again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"We encountered an error in boosting your post. Please try again or contact support." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and cannot be boosted." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                             }
                                             
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
    
    
    
    
}







#pragma marks - PickerView
-(void)addPickerView
{
    pickerArray = [[NSArray alloc]initWithObjects:@"Alfa Romeo",@"Aston Martin",@"Audi",@"Bentley",@"Bmw",@"Bugatti",@"Cadillac",@"Chevrolet",@"Chrysler",@"Citroen",@"Corvette",@"Dodge",@"Ferrari",@"Fiat",@"Ford",@"GMC",@"Honda",@"Hummer",@"Hyundai",@"Infiniti",@"Jaguar",@"Jeep",@"Lamborghini",@"Land Rover",@"Lexus",@"Lincoln",@"Maserati",@"Maybach",@"Mazda",@"Mclaren",@"Mercedes Benz",@"Mini",@"Mitsubishi",@"Mustang",@"Nissan",@"Peugeot",@"Porsche",@"Renault",@"Rolls Royce",@"SAAB",@"Skoda",@"Subaru",@"Tesla",@"Toyota",@"Volkswagen",@"Volvo",nil] ;
    
    
    
    
    carPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    carPickerView.dataSource = self;
    carPickerView.delegate = self;
    carPickerView.showsSelectionIndicator = YES;
    carPickerView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    doneButton.tintColor = [UIColor whiteColor];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          carPickerView.frame.size.height - 50, 375, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    [toolBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    [self.view addSubview:carPickerView];
    //    countryTextField.inputView = countryPickerView;
    [self.view addSubview:toolBar];
    
}



#pragma mark - Picker View Data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [Cell_DetailCar.carMakeTextField setText:[pickerArray objectAtIndex:row]];
    
    Cell_DetailCar.carMakeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Cell_DetailCar.carMakeTextField.text]];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
    
    
    
}

-(void)done:(UIBarButtonItem *)button
{
    
    carPickerView.hidden=YES;
    
    toolBar.hidden=YES;
    [carPickerView removeFromSuperview];
    [Cell_DetailCar.carMakeTextField endEditing:YES];
    
    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 14);
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}





@end

