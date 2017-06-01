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
#import "MoreDetailCell.h"
#import "SBJsonParser.h"
#import "Reachability.h"



@interface PostingViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    MoreDetailCell *moreCell;
    AddImageCell *imageCell;
    ProductDetailCell *detailCell;
    NSUserDefaults * defaults;
    UIImage *chosenImage ;
    UIImageView *imageView;
    UIImagePickerController *imagePicker;
    NSInteger count,imageCount;
    NSMutableArray *imageArray;
    int x ;
    UILabel *sellingPlaceholder,*hashPlaceholder,*morePlaceholder;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Create;
    NSMutableData *webData_Create;
    NSMutableArray *Array_Create;
    NSString *postIDValue;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageCount = 0;
    count = 0;
    imageArray = [[NSMutableArray alloc]init];
    defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"NO" forKey:@"CallPressed"];

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
   // NSString *nameStr = [NSString stringWithFormat:@"POST YOUR %@",self.name];

    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 50, 30)];
    
    nameLabel.text = [NSString stringWithFormat:@"Post your %@",self.name];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:26];
    [nameLabel sizeToFit];
    nameLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLabel;
    
    // self.navigationItem.title = @"POST YOUR CAR";
    
    
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton =YES;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(OnClick_btn:)];
    [btn setImage:[UIImage imageNamed:@"Whitearrow"]];
    
    btn.tintColor= [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btn;
    
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
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@" date=%@",[dateFormatter stringFromDate:[NSDate date]]);
    postIDValue = [NSString stringWithFormat:@"M%@%@",[dateFormatter stringFromDate:[NSDate date]],randomString];
    NSLog(@"postIDValue %@",postIDValue);
    

    
    
    
}

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}
-(void)galleryButtonPressed:(id)sender
{
    NSLog(@"galleryButtonPressed Pressed");

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = true;
        [self presentViewController:picker animated:true completion:nil];
    }
}



-(void)OnClick_btn:(UIBarButtonItem *)button
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
            
            [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
           
            CGRect workingFrame =  imageCell.scrollView.frame;
            workingFrame.origin.x = 0;
            x =880;
            
            [imageCell.scrollView setPagingEnabled:YES];
            [imageCell.scrollView setContentOffset:CGPointMake(1000-375, 0)];
            [imageCell.scrollView setContentSize:CGSizeMake(1000, workingFrame.size.height)];
            
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
                
                UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(ImageTapped:)];
                [imageView addGestureRecognizer:ImageTap];
                
                [imageCell.scrollView addSubview:imageView];
                [imageCell.contentView bringSubviewToFront:imageView];

                x -= 110;

            }
            
          return imageCell;
            
        }
            break;
        case 1:
        {
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
            
            detailCell.profileImageView.layer.cornerRadius = detailCell.profileImageView.frame.size.height / 2;
            detailCell.profileImageView.clipsToBounds = YES;
            
            //Selling textview
            
            detailCell.sellingTextview.delegate=self;
            detailCell.sellingTextview.text = @"What are you selling?";
            detailCell.sellingTextview.textColor = [UIColor blackColor];
            
            
            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
            sellingPlaceholder.text = @"This is your post headline";
            sellingPlaceholder.textColor = [UIColor lightGrayColor];
            sellingPlaceholder.textAlignment = NSTextAlignmentRight;
            [detailCell.sellingTextview addSubview:sellingPlaceholder];
            [detailCell.contentView bringSubviewToFront:sellingPlaceholder];
            
            
            detailCell.hashTextView.delegate=self;
            detailCell.hashTextView.text = @"Add some #Hashtags";
            detailCell.hashTextView.textColor = [UIColor blackColor];
            detailCell.sellingTextview.tag = 2;
            
            hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
            hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
            hashPlaceholder.textColor = [UIColor lightGrayColor];
            hashPlaceholder.textAlignment = NSTextAlignmentRight;
            [detailCell.hashTextView addSubview:hashPlaceholder];
            [detailCell.contentView bringSubviewToFront:hashPlaceholder];

            
            return detailCell;
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
            moreCell.moreTextView.text = @"Tell us more about the product";
            moreCell.moreTextView.textColor = [UIColor blackColor];
            
            [moreCell.createButton  addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [moreCell.callButton  addTarget:self action:@selector(callButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


            
            return moreCell;
        }
            break;
            
    }
    return nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView isEqual: detailCell.sellingTextview])
    {
         if ([textView.text isEqualToString:@"What are you selling?"])
         {
             textView.text = @"";
             sellingPlaceholder.hidden = YES;
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
    else if ([textView isEqual: moreCell.moreTextView])
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
    if ([textView isEqual: detailCell.sellingTextview])
    {
        if ([textView.text isEqualToString:@""])
        {
            textView.text = @"What are you selling?";
            sellingPlaceholder.hidden = NO;
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
    
    else if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@""] )
        {
            textView.text = @"Tell us more about the product";
            moreCell.morePlaceholder.hidden = NO;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)ImageTapped:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;

    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
     NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Do you want to remove selected image?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
                                    [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                    
                                    [self.tableView reloadData];
                                    
                                }];
    
    [alert addAction:yesAction];

    UIAlertAction *noAction =[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              
                              {
                                  
                                  NSLog(@"No button Pressed");
                                  
                              }];
    
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 271;
    }
    else if (indexPath.section == 1)
    {
        return 243;
    }
    else if (indexPath.section == 2)
    {
        return 520;
    }
    
    
    return 0;
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    chosenImage = info[UIImagePickerControllerOriginalImage];
    
    
    [imageArray addObject:chosenImage];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@" image=%lu",(unsigned long)imageArray.count);
    NSLog(@" image=%@",imageArray);
 
    [self.tableView reloadData];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createButtonPressed:(id)sender
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
        NSString *  urlStr=[urlplist valueForKey:@"createpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal = postIDValue;    //[defaults valueForKey:@"postid"];
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        NSString *title= @"title";
        NSString *titleVal =detailCell.sellingTextview.text;// [defaults valueForKey:@"title"];
        NSString *allowcalls= @"allowcalls";
        NSString *allowcallsVal = [defaults valueForKey:@"CallPressed"];
        NSString *enddays= @"enddays";
        NSString *enddaysVal = [defaults valueForKey:@"slival"];
        
        NSString *askingpriceValString = [NSString stringWithFormat:@"%@",moreCell.askingPriceTextField.text];
        askingpriceValString = [askingpriceValString substringFromIndex:1];
        NSString *askingprice= @"askingprice";
        NSString *askingpriceVal =askingpriceValString;
        
        NSString *description= @"description";
        NSString *descriptionVal = moreCell.moreTextView.text;//[defaults valueForKey:@"description"];
        NSString *hashtags= @"hashtags";
        NSString *hashtagsVal = detailCell.hashTextView.text;//[defaults valueForKey:@"hashtags"];
        NSString *city= @"city";
        NSString *cityVal = @"mumbai";//[defaults valueForKey:@"city"];
        NSString *country= @"country";
        NSString *countryVal = @"India";//[defaults valueForKey:@"country"];
        NSString *category= @"category";
        NSString *categoryVal = self.name;//[defaults valueForKey:@"category"];

        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,title,titleVal,allowcalls,allowcallsVal,enddays,enddaysVal,askingprice,askingpriceVal,description,descriptionVal,hashtags,hashtagsVal,city,cityVal,country,countryVal,category,categoryVal];
        
        
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    moreCell.askingPriceTextField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
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
-(void)CreatePostConnection
{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_Create)
    {
        [webData_Create setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Create)
    {
        [webData_Create appendData:data];
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
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
}

@end

/*
 case 0:
 {
 imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
 
 [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
 
 CGRect workingFrame =  imageCell.scrollView.frame;
 workingFrame.origin.x = 0;
 x =880;
 
 //[imageCell.scrollView setPagingEnabled:YES];
 [imageCell.scrollView setContentOffset:CGPointMake(1000-375, 0)];
 [imageCell.scrollView setContentSize:CGSizeMake(1000, workingFrame.size.height)];
 for (int i=1; i<=count; i++)
 {
 
 imageView=[[UIImageView alloc]init];
 imageView.frame=CGRectMake(x,0, 100, imageCell.scrollView.frame.size.height);
 //                imageView.image = chosenImage;
 // [imageView setContentMode:UIViewContentModeScaleAspectFit];
 [imageCell.scrollView addSubview:imageView];
 // [imageCell.contentView addSubview:imageView];
 [imageCell.contentView bringSubviewToFront:imageView];
 
 x -= 110;
 
 }
 imageView.image = chosenImage;
 //            UIImageView *imageView=[[UIImageView alloc]init];
 //            imageView.frame=workingFrame; //CGRectMake(375-100,0, 100, imageCell.scrollView.frame.size.height);
 //            imageView.image = chosenImage;
 //           // [imageView setContentMode:UIViewContentModeScaleAspectFit];
 //
 //            [imageCell.scrollView addSubview:imageView];
 //           // [imageCell.contentView addSubview:imageView];
 //            [imageCell.contentView bringSubviewToFront:imageView];
 
 
 return imageCell;
 }
 break;
 
 //            NSInteger sliderVal=[[NSString stringWithFormat:@"%@",[defaults valueForKey:@"slival"]]integerValue];
 //            moreCell.slider.value = sliderVal;
 //            moreCell.currentDays_Label.text = [defaults valueForKey:@"slival"];
 //            CGRect trackRect = [moreCell.slider trackRectForBounds:moreCell.slider.bounds];
 //            CGRect thumbRect = [moreCell.slider thumbRectForBounds:moreCell.slider.bounds
 //                                                         trackRect:trackRect
 //                                                             value:moreCell.slider.value];
 //            moreCell.currentDays_Label.center = CGPointMake(thumbRect.origin.x + moreCell.slider.frame.origin.x + 14,  moreCell.slider.frame.origin.y - 10);
 
 // Get the data for the image
 NSData* imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
 
 
 // Give a name to the file
 NSString* incrementedImgStr = [NSString stringWithFormat: @"UserCustomPotraitPic%ld.jpg", (long)count];
 
 
 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString* documentsDirectory = [paths objectAtIndex:0];
 
 // Now we get the full path to the file
 NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:incrementedImgStr];
 
 // and then we write it out
 [imageData writeToFile:fullPathToFile2 atomically:YES];
 
 
 
 
 //finding unique string
	$characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	$string = '';
	$max = strlen($characters) - 1;
	for ($i = 0; $i <4; $i++) {
 $string.= $characters[mt_rand(0, $max)];
 }
 
 $postid = "M".date('Y').date('m').date('d').date('H').date('i').date('s').$string;
 //echo $userid;
 
 When a user creates a post, create a unique postid which remains with him till he presses the cancel button.
 
 If he creates another post, a new postid is generated which is used to send to php server.
 
 You can use above code in obj-c to create unique postid..
 

 */
