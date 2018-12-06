
#import "FriendCahtingViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "Base64.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "AFNetworking.h"

static NSString* const CellIdentifier = @"DynamicTableViewCell";
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138
#define CELL_CONTENT_MARGIN 0.0f


@interface FriendCahtingViewController ()<UITextFieldDelegate>
{
    NSTimer *HomeTimer;
    NSURL *url_Vedio,* movieURLmain ;
    UIPinchGestureRecognizer *twoFingerPinch;
    UIImageView *Image_Amount,*Image_Date;
    UILabel * Label_paid_Unpaid,*Label_TitleTag,*Label_TitleTag1,*DateLabelHeder;
    UIImage *chosenImage;
    NSData *imageData,*ImageDataHeder,*newVedioData;
    NSDictionary *urlplist;
    NSURLConnection *Connection_Comment,*Connection_Comment_send,*Connection_Like;
    NSMutableData * webData_Comment,*webData_Comment_send,*webData_Like;
    NSMutableArray *Array_Comment,*Array_Like;
    NSString *ResultString,*String_Comment,*ResultString_sendComment,*ResultString_Like,*encodedImage,*chattype;
    UIGestureRecognizer *TabGestureDetailViewLikes,*TapGest_LabelHedingTap;
    NSUserDefaults * defaults;
    
    UIImageView * image_Desc,*ImageViews;
    UIView *headerView2,*headerView1,*PopUpImageVIew;
    UIButton *headerLabel1,* headerLabel2;
    NSArray * images_Array;
    NSString *   ImageNSdata;
    CGFloat HeightText0;
    CGRect TextViewCord,BackTextViewCord;
    UIButton * tapHederImage_Button;
    CGFloat lastScale;
    NSString *subImgname,* TagId_plist,*imageUserheight,*imageUserWidth,*Flag_TimeOneUser,*Flag_Timeseconduser;
    NSMutableArray * newCommentsArray_plist,*Array_Comment1;

    NSArray *previousArray;
    
    CGFloat hh,ww,xx,yy,th,tw,xt,yt,bty,btw,bth,btx,Bluesch,Bluescw,Bluescy,Bluescx,textBluex,textBluey,textBluew,textBlueh,hhone,wwone,xxone,yyone,keyboradHeight,textViewHeigh;
    NSString * flag1,*flag2,*flag3,*Str_TextfieldflagText;
    BOOL statusTextView;
    CGRect previousRect;
    
    UIView *sectionView;
    NSMutableArray * arracal;

}
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomSpace;
@end

static const CGFloat kButtonSpaceShowed = 90.0f;
static const CGFloat kButtonSpaceHided = 24.0f;
#define kBackgroundColorShowed [UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f];
#define kBackgroundColorHided [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];



@implementation FriendCahtingViewController
@synthesize HeadTopView,Table_Friend_chat,Label_UserName,Image_UserProfile;
@synthesize AllDataArray,TextViews,BackTextViews;
@synthesize textOne,tableOne,ViewTextViewOne,Cell_one1,Cell_Zero,Button_Back;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    defaults=[[NSUserDefaults alloc]init];
    previousArray  = [[NSArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:@"UpdatenotificationChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TappedImage) name:@"TappedImage" object:nil];
    
    CALayer *borderBottom = [CALayer layer];
    borderBottom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10f].CGColor;
    
    borderBottom.frame = CGRectMake(0, HeadTopView.frame.size.height - 2, HeadTopView.frame.size.width, 2);
    [HeadTopView.layer addSublayer:borderBottom];
    
    if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"] || [[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"] )
    {
        CGRect tableViewFrame = self.Table_Friend_chat.frame;
        tableViewFrame.origin.y = 56;
        self.Table_Friend_chat.frame = tableViewFrame;
    }
    if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
    {
        CGRect tableViewFrame = self.Table_Friend_chat.frame;
         tableViewFrame.origin.y = self.Table_Friend_chat.frame.origin.y+12;
        tableViewFrame.size.height = self.Table_Friend_chat.frame.size.height-12;
        self.Table_Friend_chat.frame = tableViewFrame;
    }
    else
    {
        CGRect tableViewFrame = self.Table_Friend_chat.frame;
        tableViewFrame.size.height = self.Table_Friend_chat.frame.size.height-8;
        self.Table_Friend_chat.frame = tableViewFrame;
    }
    
    
    NSString * documnetPath1=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSLog(@"%@",NSHomeDirectory());
    
    NSString * path = [documnetPath1 stringByAppendingPathComponent:@"ChatText.plist"];
    
    NSString * bundlePath = [[NSBundle mainBundle]pathForResource:@"ChatText" ofType:@"plist"];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        NSLog(@"File alredy exists");
    }
    else
    {
        [[NSFileManager defaultManager]copyItemAtPath:bundlePath toPath:path error:nil];
    }
    
    
    // [self Image_UserProfileTapped:nil];
    
//    Image_UserProfile.clipsToBounds = YES;
//    Image_UserProfile.layer.cornerRadius = Image_UserProfile.frame.size.height / 2;
    
    
  
    
    NSURL * url=[NSURL URLWithString:[[AllDataArray objectAtIndex:0] valueForKey:@"profilepic"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [Image_UserProfile setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        Image_UserProfile.image = image;
    }
failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
        
    }
      ];
    
    

    
    
    Label_UserName.text=[[AllDataArray objectAtIndex:0] valueForKey:@"name"];
    
    //     [Image_UserProfile setFrame:CGRectMake(HeadTopView.center.x-64,  Image_UserProfile.frame.origin.y, Image_UserProfile.frame.size.width, Image_UserProfile.frame.size.height)];
    //
    
    
    NSString *text=Label_UserName.text;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGFloat  widthCal=(size.width+Image_UserProfile.frame.size.width);
    CGFloat  ToatalWidth=((self.view.frame.size.width-widthCal)/2);
    
    NSLog(@"Length Of textttt==%f",size.width);
    NSLog(@"Length Of textttt==%f",widthCal);
    NSLog(@"Length Of textttt==%f",ToatalWidth);
    if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
    {
       [Image_UserProfile setFrame:CGRectMake(ToatalWidth,Image_UserProfile.frame.origin.y+11, 35,35)];
        
          [Button_Back setFrame:CGRectMake(Button_Back.frame.origin.x, Button_Back.frame.origin.y+12, Button_Back.frame.size.width, 30)];
        [Label_UserName setFrame:CGRectMake(Image_UserProfile.frame.origin.x+Image_UserProfile.frame.size.width+10,Label_UserName.frame.origin.y, Label_UserName.frame.size.width, Label_UserName.frame.size.height)];
    }
    else
    {
        [Image_UserProfile setFrame:CGRectMake(ToatalWidth,Image_UserProfile.frame.origin.y, Image_UserProfile.frame.size.width, Image_UserProfile.frame.size.height)];
        
        
        [Label_UserName setFrame:CGRectMake(Image_UserProfile.frame.origin.x+Image_UserProfile.frame.size.width+10,Label_UserName.frame.origin.y, Label_UserName.frame.size.width, Label_UserName.frame.size.height)];
   
    }
   
    
    Image_UserProfile.layer.cornerRadius = Image_UserProfile.frame.size.height / 2;
    Image_UserProfile.clipsToBounds = YES;
    
    _BlackViewOne.backgroundColor=[UIColor whiteColor];
    CALayer *borderTop = [CALayer layer];
    borderTop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.10f].CGColor;
    
    borderTop.frame = CGRectMake(0, 0, _BlackViewOne.frame.size.width, 1);
    [_BlackViewOne.layer addSublayer:borderTop];
    
    self.sendButton.userInteractionEnabled = NO;
    self.sendButton.hidden=NO;
    self.sendButton.enabled=NO;
    self.placeholderLabel.hidden=NO;
    [self.sendButton setBackgroundColor:[UIColor lightGrayColor]];//colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]];
    self.sendButton.layer.cornerRadius=self.sendButton.frame.size.height/2;
    self.sendButton.frame=CGRectMake((self.view.frame.size.width-self.sendButton.frame.size.width)-4, self.sendButton.frame.origin.y,self.sendButton.frame.size.width, self.sendButton.frame.size.height);
    
    self.BlackViewOne.frame=CGRectMake(self.view.frame.size.width,self.BlackViewOne.frame.origin.y,self.BlackViewOne.frame.size.width, self.BlackViewOne.frame.size.height);
    
    
    self.ImageGalButton.userInteractionEnabled = YES;
    _ImageGalButton.hidden=NO;
    _ImageGalButton.enabled=YES;
    [self.ImageGalButton setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.size.height);
    NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.size.width);
    NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.origin.y);
    
    NSLog(@"tableOne==%f",Table_Friend_chat.frame.size.height);
    NSLog(@"tableOne==%f",Table_Friend_chat.frame.size.width);
    NSLog(@"tableOne==%f",Table_Friend_chat.frame.origin.y);
    NSLog(@"tableOne==%f",Table_Friend_chat.frame.origin.x);
    
   
    textOne.clipsToBounds=YES;
    textOne.layer.cornerRadius=7.0f;
    
    ViewTextViewOne.clipsToBounds=YES;
    ViewTextViewOne.layer.cornerRadius=9.0f;
    
    
    
    
    
    hh=textOne.frame.size.height+5;
    ww=textOne.frame.size.width;
    xx=textOne.frame.origin.x;
    yy=textOne.frame.origin.y;
    
    
    
    if ([[UIScreen mainScreen]bounds].size.width==320 && [[UIScreen mainScreen]bounds].size.height==568)
    {
        
        ww=194.0;
        
    }
    else if ([[UIScreen mainScreen]bounds].size.width==375 && [[UIScreen mainScreen]bounds].size.height==667)
    {
        
        ww=249.0;
    }
    
    else  if ([[UIScreen mainScreen]bounds].size.width==414 && [[UIScreen mainScreen]bounds].size.height==736)
    {
        
         ww=288.0;
        
        
    }
    
    else if ([[UIScreen mainScreen]bounds].size.width==375 && [[UIScreen mainScreen]bounds].size.height==812.00)
    {
        ww=249.0;
    }
    
    
    th=Table_Friend_chat.frame.size.height;
    tw=Table_Friend_chat.frame.size.width;
    xt=Table_Friend_chat.frame.origin.x;
    yt=Table_Friend_chat.frame.origin.y;
    
    bth=_BlackViewOne.frame.size.height;
    btw=_BlackViewOne.frame.size.width;
    btx=_BlackViewOne.frame.origin.x;
    bty=_BlackViewOne.frame.origin.y;
    
    Bluesch=_BlackViewOne.frame.size.height;
    Bluescw=_BlackViewOne.frame.size.width;
    Bluescx=_BlackViewOne.frame.origin.x;
    Bluescy=_BlackViewOne.frame.origin.y;
    
    
    flag1=@"yes";
    
//    CGRect previousRect = CGRectZero;
    self.BlackViewOne.frame = CGRectMake(0, 55, btw,87);
   self.textOne.frame = CGRectMake(xx, yy,ww,36);
    ViewTextViewOne.frame = CGRectMake(xx, yy, ww,36);
    
 

 //  Table_Friend_chat.frame = CGRectMake(0,-1, tw, th);
//     Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-10);
  // Table_Friend_chat.backgroundColor=[UIColor greenColor];
    
    
    
    Table_Friend_chat.userInteractionEnabled=YES;
    UITapGestureRecognizer *TabGestureTablviewTuch =[[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(Tablview_Tuched:)];
    
    
    [Table_Friend_chat addGestureRecognizer:TabGestureTablviewTuch];
    
    
    subImgname =[[[AllDataArray objectAtIndex:0]valueForKey:@"tagpic"]lastPathComponent];
    NSLog(@"subImgname=%@",subImgname);
    
    
   
   
    
    [TextViews becomeFirstResponder];
    
    TextViewCord=TextViews.frame;
    BackTextViewCord=BackTextViews.frame;
    HeightText0=TextViews.frame.size.height;
    TextViews.layer.cornerRadius=8.0f;
    //    SendButton.hidden=YES;
    //    SendButton.layer.cornerRadius=8.0f;

    
   
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"data pay view profile=%@",AllDataArray);
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    
    Array_Comment = [[NSMutableArray alloc] init];
    Array_Like = [[NSMutableArray alloc] init];
    NSLog(@"paid data====%@",[[AllDataArray objectAtIndex:0]valueForKey:@"tagtype"] );
  
    
    Array_Comment1=[[NSMutableArray alloc]init];
   
    
//    NSString * documnetPath1=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    
//    NSLog(@"%@",NSHomeDirectory());
//    
//    NSString * path = [documnetPath1 stringByAppendingPathComponent:@"ChatText.plist"];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    
    NSLog(@"dictionary setValue:=%@",dictionary );
    if (AllDataArray.count==0)
    {
    Label_UserName.text=@"sachin";
        //receiveruserid = 201706231355556SU1;
      
       // senderuserid = 201706260616334AVG;
        TagId_plist=[defaults valueForKey:@"postid"];
    }
    else
    {
        TagId_plist=[[AllDataArray valueForKey:@"postid"]objectAtIndex:0];
        [defaults setObject:[[AllDataArray objectAtIndex:0]valueForKey:@"postid"] forKey:@"postid"];
       [defaults synchronize];
    }
   
    
    
    BOOL contains = [[dictionary allKeys] containsObject:TagId_plist];
    if(contains==YES)
    {
        NSLog(@"YEsssssssssssss");
        Array_Comment1=[dictionary valueForKey:TagId_plist];
        [Table_Friend_chat reloadData];
        if(Array_Comment1.count>=1)
        {
            
            
            [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        }
        NSLog(@"data plist path array==%@",Array_Comment1);
    }
   
    NSLog(@"Arrraararara:=%@",AllDataArray );
    
    
    Image_UserProfile.userInteractionEnabled=YES;
    UITapGestureRecognizer *TabGestureDetailView =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(Image_UserProfileTapped:)];
    
    
    [Image_UserProfile addGestureRecognizer:TabGestureDetailView];
    
    Label_UserName.userInteractionEnabled=YES;
    UITapGestureRecognizer *TabGestureDetailView2 =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(Image_UserProfileTapped:)];
    
    [Label_UserName addGestureRecognizer:TabGestureDetailView2];
    
    
    
if ([[[AllDataArray objectAtIndex:0]valueForKey:@"matchedfbid"] isEqualToString:@"play-date"])
    {
        _Button_Flag_Button.hidden=YES;
       
    }
    else
    {
        _Button_Flag_Button.hidden=NO;
    }
    
    
    
   
    
    
    [defaults setObject:@"yes" forKey:@"notification"];
    [defaults synchronize];
    
    Flag_TimeOneUser=@"yes";
    Flag_Timeseconduser=@"yes";

    [self CommentCommmunication];
    
#pragma mark - timer
    


}
-(void)viewDidLayoutSubviews
{
    if (Array_Comment1.count>=1)
    {
         [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
   
}
-(void)chatTimer
{
    HomeTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(CommentCommmunication) userInfo:nil  repeats:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self chatTimer];
     
//    HomeTimer =  [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(CommentCommmunication) userInfo:nil  repeats:YES];
    if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"] || [[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"])
    {
        CGRect tableViewFrame = self.Table_Friend_chat.frame;
        tableViewFrame.origin.y = 56;
        self.Table_Friend_chat.frame = tableViewFrame;
    }
    
    Image_UserProfile.userInteractionEnabled=YES;
    UITapGestureRecognizer *TabGestureDetailView =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(Image_UserProfileTapped:)];
    
    
    [Image_UserProfile addGestureRecognizer:TabGestureDetailView];
  
   
    [self subscribeToKeyboard];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [HomeTimer invalidate];
    HomeTimer=nil;
    [self an_unsubscribeKeyboard];
}


- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
           
//            self.tabBarBottomSpace.constant = CGRectGetHeight(keyboardRect);
//
//
//                Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-(textBlueh+CGRectGetHeight(keyboardRect)));
//            keyboradHeight=(textBlueh+CGRectGetHeight(keyboardRect));
            if ([UIScreen mainScreen].bounds.size.width==375.00 && [UIScreen mainScreen].bounds.size.height==812.00)
            {
                [_textOneBlue setFrame:CGRectMake(0,self.view.frame.size.height-_textOneBlue.frame.size.height-keyboardRect.size.height, _textOneBlue.frame.size.width, _textOneBlue.frame.size.height)];
                
                Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-(textBlueh+CGRectGetHeight(keyboardRect)));
                keyboradHeight=(textBlueh+CGRectGetHeight(keyboardRect));
            }
            else
            {
                self.tabBarBottomSpace.constant = CGRectGetHeight(keyboardRect);
            }
            
            if(Array_Comment1.count>=1)
            {
                if([subImgname isEqualToString:@"defaultimg.jpg"])
                {
                    
                    [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
                else
                {
                    [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
                
                NSLog(@"keyboard cordinates==height==%f", CGRectGetHeight(keyboardRect));
            }
            
            
            
            
        }
        else
        {
//            NSLog(@"keyboard cordinates==heightdisable==%f", CGRectGetHeight(keyboardRect));
//
//            self.tabBarBottomSpace.constant = 0.0f;
//           Table_Friend_chat.frame = CGRectMake(0,yt, tw, th);
//             keyboradHeight= 0.0f;
            
            NSLog(@"keyboard cordinates==heightdisable==%f", CGRectGetHeight(keyboardRect));
            if ([UIScreen mainScreen].bounds.size.width==375.00 && [UIScreen mainScreen].bounds.size.height==812.00)
            {
                [_textOneBlue setFrame:CGRectMake(0,(self.view.frame.size.height-_textOneBlue.frame.size.height)-34, _textOneBlue.frame.size.width, _textOneBlue.frame.size.height)];
            }
            else
            {
                self.tabBarBottomSpace.constant = 0.0f;
            }
            //
            Table_Friend_chat.frame = CGRectMake(0,yt, tw, th);
            keyboradHeight=0.0f;
            
        }
        
        
        [self.view layoutIfNeeded];
    } completion:nil];}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        
        if (Array_Comment1.count !=0)
        {
            return Array_Comment1.count+1;
        }
    }
  
     return 0;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//    return 0;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellid0 = @"CellZero";
    static NSString *Cellid1=@"CellOnes";
 
    
 
    if (indexPath.section == 0)
    {
        
        Cell_Zero = (CustomTableViewCellZero *)[Table_Friend_chat dequeueReusableCellWithIdentifier:Cellid0 forIndexPath:indexPath];
        
        
        Cell_Zero.postImageView.layer.cornerRadius = 10;
        Cell_Zero.postImageView.layer.masksToBounds = YES;
        
        NSURL * url=[NSURL URLWithString:[[AllDataArray objectAtIndex:indexPath.row] valueForKey:@"mediathumbnailurl"]];
        
     //   [Cell_Zero.postImageView setImageWithURL:[[AllDataArray objectAtIndex:indexPath.row] valueForKey:@"mediathumbnailurl"] placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
        
        
       
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [Cell_Zero.postImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             Cell_Zero.postImageView.image = image;
         }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             
         }
         ];
        
        

        Cell_Zero.postIdLabel.text = [NSString stringWithFormat:@"%@%@",[[AllDataArray objectAtIndex:indexPath.row]valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID[NSString stringWithFormat:@"POST ID:%@", [[AllDataArray objectAtIndex:indexPath.row]valueForKey:@"postid"]];
        
        NSLog(@"AllDataArray=%@",AllDataArray);
        
        
                

        
            return Cell_Zero;
        
  
    }
    else
    {
        
        UILabel *label = nil;
        UILabel *label1 = nil;
        UILabel *label_time = nil;
        UIImageView * desc_Imagepro=nil;
        //    UIImageView * Chat_ImageRight=nil;
        UIImageView * Chat_UserImage=nil;
        NSLog(@"Indexpath===%ld",(long)indexPath.row);
        Cell_one1 = [Table_Friend_chat dequeueReusableCellWithIdentifier:@"Cell"];
        Cell_one1.selectionStyle=UITableViewCellSelectionStyleNone;
        if (Cell_one1 == nil)
        {
            
            Cell_one1 = [[CustomTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:Cellid1] ;
            label1 = [[UILabel alloc] initWithFrame:CGRectZero];
            [label1 setLineBreakMode:UILineBreakModeWordWrap];
            [label1 setNumberOfLines:0];
            [label1 setTag:1];
            [label1 setBackgroundColor:[UIColor clearColor]];
            [[Cell_one1 contentView] addSubview:label1];
            
            
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setNumberOfLines:0];
            [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:FONT_SIZE]];
            [label setTag:5];
            [label setBackgroundColor:[UIColor clearColor]];
            [[Cell_one1 contentView] addSubview:label];
            
            
            
            label_time = [[UILabel alloc] initWithFrame:CGRectZero];
            [label_time setLineBreakMode:UILineBreakModeWordWrap];
            [label_time setNumberOfLines:0];
            [label_time setFont:[UIFont fontWithName:@"Helvetica-Light" size:12]];
            
            [label_time setBackgroundColor:[UIColor clearColor]];
            [[Cell_one1 contentView] addSubview:label_time];
            
            
            desc_Imagepro = [[UIImageView alloc] initWithFrame:CGRectZero];
            [desc_Imagepro setTag:4];
            [desc_Imagepro setBackgroundColor:[UIColor lightGrayColor]];
            [[Cell_one1 contentView] addSubview:desc_Imagepro];
            
            
            //        Chat_ImageRight = [[UIImageView alloc] initWithFrame:CGRectZero];
            //        [Chat_ImageRight setTag:4];
            //        [Chat_ImageRight setBackgroundColor:[UIColor lightGrayColor]];
            //        [[Cell_one1 contentView] addSubview:Chat_ImageRight];
            
            Chat_UserImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [Chat_UserImage setTag:5];
            [Chat_UserImage setBackgroundColor:[UIColor lightGrayColor]];
            [[Cell_one1 contentView] addSubview:Chat_UserImage];
            
            
            
        }
        
        
        Cell_one1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        if (!label)
            label = (UILabel*)[Cell_one1 viewWithTag:1];
        
        if (!label1)
            label1 = (UILabel*)[Cell_one1 viewWithTag:2];
        
        
        [label setBackgroundColor:[UIColor clearColor]];
        
        
        label.textColor=[UIColor blackColor];
        
        
        if (indexPath.row==0)
        {
            
          //  [label setText:[NSString stringWithFormat:@"%@%@%@%@",@"You matched with ",[[AllDataArray objectAtIndex:0] valueForKey:@"name"],@" on ",[[AllDataArray objectAtIndex:0] valueForKey:@"messagedate"]]];
//            [label setFrame:CGRectMake(0,label_time.frame.size.height,self.view.frame.size.width, Cell_one1.frame.size.height)];
//            label.textColor=[UIColor lightGrayColor];
//            label.textAlignment=NSTextAlignmentCenter;
//            label_time.hidden=YES;
        }
        else
        {
            
            label_time.tag=indexPath.row-1;
            
            label_time.textColor=[UIColor lightGrayColor];
            label_time.textAlignment=NSTextAlignmentCenter;
            label_time.hidden=NO;
            
            
            
            NSString *str = [[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagedate"];;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *dte = [dateFormat dateFromString:str];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            
            NSLog(@"Date format saecond %@",[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]]);
            NSString *str_Date=[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]];
            
            label_time.text=str_Date;
            label_time.hidden=NO;
            if (indexPath.row==1)
            {
                
                Flag_TimeOneUser=@"no";
                label_time.hidden=NO;
                [label_time setFrame:CGRectMake(0,0,self.view.frame.size.width, 20)];
                NSLog(@"Date format row11 %ld",indexPath.row-1);
            }
            else
            {
                label_time.hidden=NO;
                if (indexPath.row >=2)
                {
                    NSString *str1 = [[Array_Comment1 objectAtIndex:indexPath.row-2]valueForKey:@"messagedate"];;         NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                    [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSDate *dte1 = [dateFormat1 dateFromString:str1];
                    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
                    label_time.text=[NSString stringWithFormat:@"%@",[dateFormat1 stringFromDate:dte1]];
                    NSLog(@"Date format saecond1111 %@",[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte1]]);
                    NSString *str_Date1=[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte1]];
                    if ([str_Date isEqualToString:str_Date1])
                    {
                        [label_time setFrame:CGRectMake(0,0,0,0)];
                        label_time.text=@"";;
                    }
                    else
                    {
                        [label_time setFrame:CGRectMake(0,0,self.view.frame.size.width, 20)];
                        label_time.text=str_Date;
                    }
                    
                }
                
                
            }
            
            
            
            
            
            
            if ([[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagetype"] isEqualToString:@"TEXT"] || [[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagetype"] isEqualToString:@""])
            {
                
                
                
                NSString *text =[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"message"];
                CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                
                int lines = size.height/16;
                
                NSLog(@"lines count : %i \n\n",lines);
                
                
                
                [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:FONT_SIZE]];
                
                NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.alignment = NSTextAlignmentLeft;
                style.firstLineHeadIndent = 10.0f;
                style.headIndent = 10.0f;
                style.tailIndent = -10.0f;
                
                NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSParagraphStyleAttributeName : style}];
                
                label.numberOfLines = 0;
                label.attributedText = attrText;
                
                //   [label setText:text];
                
                label.clipsToBounds=YES;
                label.layer.cornerRadius=9.0f;
                label1.backgroundColor=[UIColor colorWithRed:13/255.0 green:146/255.0 blue:220/255.0 alpha:0.8];
                
                NSLog(@"Comment Width==%f",size.width);
                NSLog(@"Comment Height==%f",size.height);
                NSLog(@"Comment StringLength==%lu",(unsigned long)text.length);
                
                //          receiveruserid = 201706231355556SU1;
                //          senderuserid
                
                if ([[defaults valueForKey:@"userid"] isEqualToString:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"receiveruserid"]])
                {
                    
                    
                    
                    NSURL * url=[NSURL URLWithString:[[AllDataArray objectAtIndex:0]valueForKey:@"profilepic"]];
                 //   [desc_Imagepro setImageWithURL:[[AllDataArray objectAtIndex:0]valueForKey:@"profilepic"] placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"]];
                    
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [desc_Imagepro setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         desc_Imagepro.image = image;
                     }
                                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     {
                         
                     }
                     ];
                    
                    
                    label.backgroundColor=[UIColor colorWithRed:255/255.0 green:244/255.0 blue:96/255.0 alpha:0.7];
                    
                    label.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
                    if (size.width <=self.view.frame.size.width-132)
                    {
                        
                        
                        [label setFrame:CGRectMake(50,label_time.frame.size.height, size.width+22, MAX(size.height, 30.0f)+8)];
                        
                        
                    }
                    
                    else
                    {
                        [label setFrame:CGRectMake(50,label_time.frame.size.height, self.view.frame.size.width-140,MAX(size.height, 30.0f)+8)];
                        
                        
                    }
                    
                    [desc_Imagepro setFrame:CGRectMake(8,label.frame.origin.y+(label.frame.size.height-32),32,32)];
                    desc_Imagepro.clipsToBounds=YES;
                    desc_Imagepro.layer.cornerRadius=desc_Imagepro.frame.size.height/2;
                }
                else
                {
                    NSURL * url=[NSURL URLWithString:[defaults valueForKey:@"ProImg"]];
                //    [desc_Imagepro setImageWithURL:[defaults valueForKey:@"ProImg"] placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"]];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [desc_Imagepro setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         desc_Imagepro.image = image;
                     }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     {
                         
                     }
                     ];
                    
                    
                    if ([[defaults valueForKey:@"gender"] isEqualToString:@"Boy"])
                    {
                        label.backgroundColor=[UIColor colorWithRed:220/255.0 green:242/255.0 blue:253/255.0 alpha:1];
                        label.layer.borderColor=[UIColor colorWithRed:220/255.0 green:242/255.0 blue:253/255.0 alpha:1].CGColor;
                        label.layer.borderWidth=1.0f;
                        
                    }
                    else
                    {
                        label.backgroundColor=[UIColor colorWithRed:250/255.0 green:207/255.0 blue:214/255.0 alpha:1];
                        label.layer.borderColor=[UIColor colorWithRed:250/255.0 green:207/255.0 blue:214/255.0 alpha:1].CGColor;
                        label.layer.borderWidth=1.0f;
                    }
                    
                    
                    label.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
                    
                    if (size.width <=self.view.frame.size.width-132)
                    {
                        
                        
                        [label setFrame:CGRectMake(self.view.frame.size.width-(size.width+83),label_time.frame.size.height, size.width+22, MAX(size.height, 30.0f)+8)];
                    }
                    
                    else
                    {
                        
                        
                        [label setFrame:CGRectMake(self.view.frame.size.width-(size.width+83),label_time.frame.size.height, self.view.frame.size.width-140, MAX(size.height, 30.0f)+8)];
                        
                        
                        
                    }
                    
                    
                    [desc_Imagepro setFrame:CGRectMake(self.view.frame.size.width-48,label.frame.origin.y+(label.frame.size.height-32),32,32)];
                    desc_Imagepro.clipsToBounds=YES;
                    desc_Imagepro.layer.cornerRadius=desc_Imagepro.frame.size.height/2;
                }
                
                
                
                
            }
            
            else
            {
                
                
                CGFloat imgwidth=[[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"imagewidth"] floatValue];
                CGFloat imgheight=[[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"imageheight"] floatValue];
                
                
                NSURL * url=[NSURL URLWithString:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"imageurl"]];
                
             //   [Chat_UserImage setImageWithURL:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"imageurl"] placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [Chat_UserImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     Chat_UserImage.image = image;
                 }
                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                 {
                     
                 }
                 ];
                
                
                Chat_UserImage.clipsToBounds=YES;
                Chat_UserImage.layer.cornerRadius=9.0f;
                Chat_UserImage.contentMode=UIViewContentModeScaleAspectFit;
                
                
                
                
//                if ([[defaults valueForKey:@"userid"] isEqualToString:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"receiveruserid"]])
//                
//
                if ([[defaults valueForKey:@"userid"] isEqualToString:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"receiveruserid"]])
                {
                    
                
//                if (![[defaults valueForKey:@"userid1"] isEqualToString:[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"receiveruserid"]])
//                {
                 NSURL * url=[NSURL URLWithString:[[AllDataArray objectAtIndex:0]valueForKey:@"profilepic"]];
                    
               
                   
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [desc_Imagepro setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         desc_Imagepro.image = image;
                     }
                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     {
                         
                     }
                     ];

                    
                    
                    
                    
                    [Chat_UserImage setFrame:CGRectMake(52,4+label_time.frame.size.height,imgwidth,imgheight)];
                    Chat_UserImage.clipsToBounds=YES;
                    Chat_UserImage.layer.cornerRadius=9.0f;
                    Chat_UserImage.contentMode=UIViewContentModeScaleAspectFit;
                    [self displayImage:Chat_UserImage withImage:Chat_UserImage.image];
                    
                    [desc_Imagepro setFrame:CGRectMake(8,Chat_UserImage.frame.origin.y+(Chat_UserImage.frame.size.height-32),32,32)];
                    desc_Imagepro.clipsToBounds=YES;
                    desc_Imagepro.layer.cornerRadius=desc_Imagepro.frame.size.height/2;
                    
                }
                else
                {
                 NSURL * url=[NSURL URLWithString:[defaults valueForKey:@"ProImg"]];
    
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [desc_Imagepro setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         desc_Imagepro.image = image;
                     }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     {
                         
                     }
                     ];

                    
                    
                    [Chat_UserImage setFrame:CGRectMake((self.view.frame.size.width-64)-imgwidth,4+label_time.frame.size.height,imgwidth,imgheight)];
                    Chat_UserImage.clipsToBounds=YES;
                    Chat_UserImage.layer.cornerRadius=9.0f;
                    Chat_UserImage.contentMode=UIViewContentModeScaleAspectFit;
                    
                    [self displayImage:Chat_UserImage withImage:Chat_UserImage.image];
                    
                    [desc_Imagepro setFrame:CGRectMake(self.view.frame.size.width-48,Chat_UserImage.frame.origin.y+(Chat_UserImage.frame.size.height-32),32,32)];
                    desc_Imagepro.clipsToBounds=YES;
                    desc_Imagepro.layer.cornerRadius=desc_Imagepro.frame.size.height/2;
                }
                
                
            }
        }
        
    
        return Cell_one1;
    }
    
    
    return 0;

}




- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return 0;//128;

    }
    else
    {
    
 
    if (indexPath.row==0)
    {
       return 10;
    }
    else
    {
        CGFloat heightAdd = 0;
        NSString *str = [[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagedate"];;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *dte = [dateFormat dateFromString:str];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        NSLog(@"Date format saecond %@",[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]]);
        NSString *str_Date=[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]];
 
        if (indexPath.row==1)
        {
            heightAdd=20;
            
        }
        else
        {
          
            if (indexPath.row >=2)
            {
                NSString *str1 = [[Array_Comment1 objectAtIndex:indexPath.row-2]valueForKey:@"messagedate"];;         NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                [dateFormat1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate *dte1 = [dateFormat1 dateFromString:str1];
                [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
              
                NSLog(@"Date format saecond1111 %@",[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte1]]);
                NSString *str_Date1=[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte1]];
                if ([str_Date isEqualToString:str_Date1])
                {

                  heightAdd=0;
                }
                else
                {
                    
                heightAdd=20;
                }
                
            }
            
            
        }
        
        if ([[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagetype"] isEqualToString:@"TEXT"] ||[[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"messagetype"] isEqualToString:@""])
        {
        NSString *text = [[Array_Comment1 objectAtIndex:indexPath.row-1] valueForKey:@"message"];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 30.0f);
        return height + (CELL_CONTENT_MARGIN * 2)+15+heightAdd;
        }
        else
        {
            CGFloat imgheight=[[[Array_Comment1 objectAtIndex:indexPath.row-1]valueForKey:@"imageheight"] floatValue];
            return imgheight+15+heightAdd;
        }
 
   
    }
    }
    return 0;
}

-(IBAction)BackView:(id)sender
{
    
    
//    [defaults setObject:@"no" forKey:@"notification"];
//    [defaults synchronize];
//    if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"] || [[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"])
//    {
//        //        self.view.window.rootViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        //[self.view.window.rootViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        
//        [self performSegueWithIdentifier:@"back" sender:self];
//    }
//    else
//    {
//        [defaults setObject:@"no" forKey:@"letsChat"];
//        [defaults setObject:@"no" forKey:@"letsChatAd"];
//        
//        [defaults synchronize];
//        if ([[defaults valueForKey:@"friendRequest"] isEqualToString:@"yes"])
//        {
//            [defaults setObject:@"no" forKey:@"friendRequest"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//            
//        }
//        else
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        
//        
//    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    [HomeTimer invalidate];
    HomeTimer=nil;
}

-(IBAction)Send_Comments:(id)sender
{
    String_Comment=textOne.text;
    [self sendComment];
    textOne.text=nil;
    _ImageGalButton.enabled=YES;
    _placeholderLabel.hidden=NO;
    self.BlackViewOne.frame = CGRectMake(0, 55, btw,87);
    self.textOne.frame = CGRectMake(xx, yy, ww,36);
    ViewTextViewOne.frame = CGRectMake(xx, yy, ww,36);
    self.sendButton.enabled=NO;
    self.sendButton.backgroundColor=[UIColor lightGrayColor];
    Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-keyboradHeight);
            self.ImageGalButton.userInteractionEnabled = YES;  // uday
 
}
-(IBAction)CameraButtonAct:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take from camera",@"Choose from gallery",nil];
    popup.tag = 3;
    [popup showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((long)actionSheet.tag == 777)
    {
        NSLog(@"INDEXAcrtionShhet==%ld",(long)buttonIndex);
        
        if (buttonIndex== 0)
        {
            
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"Unfriend?" message:@"Are you sure you want to Unfriend this user? You will not be able to connect again in the future and all your chats will be deleted."preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [self UnfriendCommunication];
                                            
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else  if (buttonIndex== 1)
        {
            //[self FlagVedioCommunication];
            
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Flag Reason?" message:@"Please mention the reason of flagging this user:" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
             {
                 //         textField.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
                 textField.placeholder = @"Remarks";
                 
                 //        textField.secureTextEntry = YES;
             }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Flag" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                NSLog(@"Current password %@", [[alertController textFields][0] text]);
                                                Str_TextfieldflagText=[[alertController textFields][0] text];
                                                if (Str_TextfieldflagText.length !=0)
                                                {
                                                    
                                                  //  FlagStatus=@"Flagyes";
                                                    
                                                    [self FlagVedioCommunication];
                                                }
                                                
                                                
                                                
                                                
                                            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Canelled");
            }];
            [alertController addAction:confirmAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    }
    else
    {
    if (buttonIndex== 0)
    {
        
       
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        //  [self.navigationController pushViewController:picker animated:YES];
        // [self.navigationController presentModalViewController:picker animated:YES];
    }
    if (buttonIndex== 1)
    {
        
      
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
    }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    chattype=@"IMAGE";
    chosenImage = info[UIImagePickerControllerOriginalImage];
    
    UIImageView *attachmentImageNew = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width-120, self.view.frame.size.height-127)];
    attachmentImageNew.image = chosenImage;
    attachmentImageNew.backgroundColor = [UIColor redColor];
    attachmentImageNew.contentMode = UIViewContentModeScaleAspectFit;
   
  
    float widthRatio = attachmentImageNew.bounds.size.width / attachmentImageNew.image.size.width;
    float heightRatio = attachmentImageNew.bounds.size.height / attachmentImageNew.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageWidth = scale * attachmentImageNew.image.size.width;
    float imageHeight = scale * attachmentImageNew.image.size.height;
    
    NSLog(@"Size of pic is %f",imageWidth);
    NSLog(@"Size of pic is %f",imageHeight);
    if (imageWidth>=254)
    {
         imageUserWidth=[NSString stringWithFormat:@"%f",254.0];
    }
    else
    {
       imageUserWidth=[NSString stringWithFormat:@"%f",imageWidth];
    }
    
      imageUserheight=[NSString stringWithFormat:@"%f",imageHeight];
    
    UIImage *image =  [self scaleImage:chosenImage  toSize:CGSizeMake([imageUserWidth floatValue]*2,[imageUserheight floatValue]*2)];
    
    
    imageData = UIImageJPEGRepresentation(image,0.5);
    
    // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    ImageNSdata = [Base64 encode:imageData];

    
    encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));

    if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"] || [[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"])
    {
     [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self sendComment];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    chattype=@"";
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)sendComment
{
    
    NSLog(@"sachin %@",String_Comment);
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"activityaddchat"];
    url =[NSURL URLWithString:urlStrLivecount];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
//    NSString *receiverfbid=@"fbid2";
    
    NSString *receiverfbidVal;
    if ([[defaults valueForKey:@"userid"]isEqualToString:[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"]])
    {
        receiverfbidVal=[[AllDataArray objectAtIndex:0]valueForKey:@"senderuserid"];
    }
    else
    {
        receiverfbidVal=[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"];
    }
    
  //  NSString *receiverfbidVal=[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"];
    
//    NSString *senderfbid=@"fbid1";
    NSString *senderfbidVal=[defaults valueForKey:@"userid"];
    
    
    
   
     NSString *postidVal=[[AllDataArray objectAtIndex:0]valueForKey:@"postid"];
    
//    NSString *chatcount=@"chatcount";
    NSString *chatcountVal=@"";
    
//    NSString *message=@"message";
    NSString *messageVal=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)textOne.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
   
//    NSString *Chattypee=@"chattype";
    NSString *ChattypeeVal=chattype;
    
    
//    NSString *ChatImage=@"chatimage";
    NSString *ChatImageVal=encodedImage;
    
//    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",receiverfbid,receiverfbidVal,senderfbid,senderfbidVal,chatcount,chatcountVal,message,messageVal];
//    
//    
//    NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
//    [request setHTTPBody: requestData];
    
    
    
    
   NSString *parameter = [NSString stringWithFormat:@"userid1=%@&userid2=%@&postid=%@&chatcount=%@&message=%@&messagetype=%@&chatimage=%@&imagewidth=%@&imageheight=%@",senderfbidVal,receiverfbidVal,postidVal,chatcountVal,messageVal,ChattypeeVal,ChatImageVal,imageUserWidth,imageUserheight];
//    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    ;
    
//    
//    
     NSData * requestData = [NSData dataWithBytes:[parameter UTF8String] length: [parameter length]];
    
    
   
    [request setHTTPBody:requestData];
    
    
    Connection_Comment_send = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    {
        if( Connection_Comment_send)
        {
            webData_Comment_send=[[NSMutableData alloc]init];
            
            
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
    }
    
}
-(void)CommentCommmunication
{
    
    NSLog(@"comment communication");
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"activitychat"];
    url =[NSURL URLWithString:urlStrLivecount];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *userid=@"userid1";
    NSString *useridVal=[defaults valueForKey:@"userid"];
    
   


    
    NSString *postid,*userid1;
    NSString *postidVal,*userid1Val;
    
  
    if (AllDataArray.count==0)
    {
       userid1=@"userid2";
       userid1Val=[defaults valueForKey:@"userid1"];
        
        postid=@"postid";
        postidVal=[defaults valueForKey:@"postid1"];
        
        
    }
    else
    {
        userid1=@"userid2";
        
        if ([[defaults valueForKey:@"userid"]isEqualToString:[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"]])
        {
            userid1Val=[[AllDataArray objectAtIndex:0]valueForKey:@"senderuserid"];
            [defaults setObject:[[AllDataArray objectAtIndex:0]valueForKey:@"senderuserid"] forKey:@"userid1"];

        }
        else
        {
        
        userid1Val=[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"];
        [defaults setObject:[[AllDataArray objectAtIndex:0]valueForKey:@"receiveruserid"] forKey:@"userid1"];
        }
        
        
        
        
        postid=@"postid";
        postidVal=[[AllDataArray objectAtIndex:0]valueForKey:@"postid"];
        [defaults setObject:[[AllDataArray objectAtIndex:0]valueForKey:@"postid"] forKey:@"postid1"];
        [defaults synchronize];
    }
//    NSString *chatcount=@"fid";
//    NSString *taginviteVal=[];
//    
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",userid,useridVal,userid1,userid1Val,postid,postidVal];
    
    
    NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
    [request setHTTPBody: requestData];
    
    Connection_Comment = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    {
        if( Connection_Comment)
        {
            webData_Comment =[[NSMutableData alloc]init];
            
            
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    if(connection==Connection_Comment)
    {
        [webData_Comment setLength:0];
        
        
    }
    if(connection==Connection_Comment_send)
    {
        [webData_Comment_send setLength:0];
        
        
    }
    if(connection==Connection_Like)
    {
        [webData_Like setLength:0];
        
        
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Comment)
    {
        [webData_Comment appendData:data];
    }
    if(connection==Connection_Comment_send)
    {
        [webData_Comment_send appendData:data];
    }
    if(connection==Connection_Like)
    {
        [webData_Like appendData:data];
    }
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_Comment)
    {
       
      
      

        
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        ResultString=[[NSString alloc]initWithData:webData_Comment encoding:NSUTF8StringEncoding];
        Array_Comment= [objSBJsonParser objectWithData:webData_Comment];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSLog(@"Array_Comment %@",Array_Comment);
        NSLog(@"Array_Comment_ResultString%@",ResultString);
        if ([ResultString isEqualToString:@"NullError"])
        {
            
        }
       
        NSString * documnetPath1=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSLog(@"%@",NSHomeDirectory());
        
        NSString * path = [documnetPath1 stringByAppendingPathComponent:@"ChatText.plist"];
        
       
        if(Array_Comment.count!=0)
        {
            
            NSMutableDictionary *savedValue1 = [[[NSMutableDictionary alloc] initWithContentsOfFile: path]mutableCopy];
            
            NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:path]mutableCopy];
            
       
            
            if(Array_Comment1.count==0 || savedValue1==nil)
            {
                if (savedValue1==nil)
                {
                    NSMutableDictionary *data;
                    
                    data = [[NSMutableDictionary alloc] init];
                    
                    [data setObject:Array_Comment forKey:TagId_plist];
                    [data writeToFile:path atomically:YES];
                }
                
            }

            
            NSLog(@"NSHomeDirectory=%@",NSHomeDirectory());
            
            NSLog(@"dictionary setValue:=%@",dictionary );
            
            if (Array_Comment.count!=0)
            {
                Array_Comment1=Array_Comment;
                [dictionary setObject:Array_Comment forKey:TagId_plist];
                [dictionary writeToFile:path atomically:YES];
            }
            
           
            
            if (previousArray.count == Array_Comment.count)
            {
                
            }
            else
            {
                [Table_Friend_chat reloadData];
            }
            
            
            
            

          
            
            if(Array_Comment.count>=1 && previousArray.count != Array_Comment.count )
            {
                
                
                [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            }
            
            previousArray = Array_Comment;


            
                  }
        
        
        
    }
    if (connection==Connection_Comment_send)
    {
        
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        ResultString_sendComment=[[NSString alloc]initWithData:webData_Comment_send encoding:NSUTF8StringEncoding];
        Array_Comment=[objSBJsonParser objectWithData:webData_Comment_send];
        
        ResultString_sendComment = [ResultString_sendComment stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString_sendComment = [ResultString_sendComment stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSLog(@"Array_Commentsens %@",Array_Comment);
        NSLog(@"ResultString_sendComment%@",ResultString_sendComment);
        
        
        if ([ResultString isEqualToString:@"nullerror"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Could not retrieve your Account Id. Please login and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not retrieve your Account Id. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];

            
        }
        if ([ResultString isEqualToString:@"nofbid"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your account does not exist or it has been de-activated by the administrator. Please contact us at support@play-date.ae" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your account does not exist or it has been de-activated by the administrator. Please contact us at support@play-date.ae" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            

            
        }
        if ([ResultString isEqualToString:@"inserterror"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Error in sending message. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Error in sending message. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        if ([ResultString isEqualToString:@"messagenull"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your message text seems to be empty. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your message text seems to be empty. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        if ([ResultString isEqualToString:@"imagenull"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You seem to have not selected an image to send. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You seem to have not selected an image to send. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        
       if ([ResultString isEqualToString:@"imageerror"])
        {
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Could not upload the image you have selected. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//            [message show];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not upload the image you have selected. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];

        }


        if(Array_Comment.count !=0)
        {
          
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSLog(@"NSHomeDirectory=%@",NSHomeDirectory());
            
            
            
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ChatText.plist"];
            
            
            
            NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:path]mutableCopy];
            
            
            NSMutableDictionary *savedValue1 = [[[NSMutableDictionary alloc] initWithContentsOfFile: path]mutableCopy];
            
//            if(Array_Comment1.count==0 || savedValue1==nil)
//            {
//                if (savedValue1==nil)
//                {
                    NSMutableDictionary *data;
                    
                    data = [[NSMutableDictionary alloc] init];
                    
                    [data setObject:Array_Comment forKey:TagId_plist];
                    [data writeToFile:path atomically:YES];
//                }
//                
//            }

            
            
            
            
            NSLog(@"NSHomeDirectory=%@",NSHomeDirectory());
            
            NSLog(@"dictionary setValue:=%@",dictionary);
            if(Array_Comment.count !=0)
            {
                NSLog(@"NO11111");
                Array_Comment1=Array_Comment;
                [dictionary setObject:Array_Comment forKey:TagId_plist];
                [dictionary writeToFile:path atomically:YES];
            }
            
            
            
            
            

            
            [Table_Friend_chat reloadData];
            if(Array_Comment.count>=1)
            {
                
                    
                    [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
              
            }
            
        }
        
        
    }
    if (connection==Connection_Like)
    {
        
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        ResultString_Like=[[NSString alloc]initWithData:webData_Like encoding:NSUTF8StringEncoding];
        Array_Like= [objSBJsonParser objectWithData:webData_Like];
        
        ResultString_Like = [ResultString_Like stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString_Like = [ResultString_Like stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSLog(@"ResultString_Like %@",Array_Like);
        NSLog(@"ResultString_Like%@",ResultString_Like);
        if ([ResultString_Like isEqualToString:@"NoLikes"])
        {
            [Table_Friend_chat reloadData];
        }
        
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    //    [tableView_Pay scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    if(Array_Comment1.count>=1)
    {
    
            
            [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
    
    if (textView.text.length == 0)
    {
        self.sendButton.hidden=NO;
        self.sendButton.enabled=NO;
        self.placeholderLabel.hidden=NO;
        [self.sendButton setBackgroundColor:[UIColor lightGrayColor]];
        self.sendButton.userInteractionEnabled = NO;
        
        _ImageGalButton.hidden=NO;
        _ImageGalButton.enabled=YES;
        [self.ImageGalButton setBackgroundColor:[UIColor clearColor]];
        self.ImageGalButton.userInteractionEnabled = YES;
        
        
        
        
    }
    else
    {
        
        chattype=@"TEXT";
        
        
        self.placeholderLabel.hidden=YES;
        self.sendButton.hidden=NO;
        self.sendButton.enabled=YES;
        [self.sendButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        self.sendButton.userInteractionEnabled = YES;
        
       
        
        _ImageGalButton.userInteractionEnabled = NO;
        _ImageGalButton.hidden=NO;
        _ImageGalButton.enabled=NO;
      
    }
    
    
    CGFloat y = CGRectGetMaxY(self.textOne.frame);

    UITextPosition* pos = textOne.endOfDocument;
   
    CGRect currentRect = [textOne caretRectForPosition:pos];
    
    NSLog(@"dsdssdfds %f",currentRect.origin.y);
  
    if (currentRect.origin.y >65)
    {
        if ( [flag1 isEqualToString:@"yes" ])
        {
            
            self.BlackViewOne.frame = CGRectMake(0, bty - textView.contentSize.height+36, btw,bth+textView.contentSize.height);
            ViewTextViewOne.frame = CGRectMake(xx, yy, ww,textOne.frame.size.height+2);
            // tableView_Pay.frame = CGRectMake(0, yt - textView.contentSize.height+38, tw, th);
            Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-(textView.contentSize.height+(keyboradHeight-hh)));
            flag1=@"no";
        }
        else
        {
            flag1=@"no";
        }
        
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        if(currentRect.origin.y <=64)
        {
            flag1=@"yes";
        }
        
        
        
        self.BlackViewOne.frame = CGRectMake(0, bty - textView.contentSize.height+33, btw,bth+textView.contentSize.height);
        
        self.textOne.frame = CGRectMake(xx, yy, ww,textView.contentSize.height+10);
        ViewTextViewOne.frame = CGRectMake(xx, yy, ww,textView.contentSize.height);
        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-(textView.contentSize.height+(keyboradHeight-hh)));
        
        [self.textOne layoutIfNeeded];
        NSLog(@"BlueView==%f",_textOneBlue.frame.size.height);
        NSLog(@"BlueView==%f",_textOneBlue.frame.size.width);
        NSLog(@"BlueViewx==%f",_textOneBlue.frame.origin.x);
        NSLog(@"BlueViewy==%f",_textOneBlue.frame.origin.y);
        
        
        
        NSLog(@"tableView_Pay==%f",Table_Friend_chat.frame.size.height);
        NSLog(@"tableView_Payyy==%f",Table_Friend_chat.frame.origin.y);
        
        NSLog(@"ViewTextViewOne==%f",ViewTextViewOne.frame.size.height);
        
        NSLog(@"self.textOne.frame==%f",self.textOne.frame.size.height);
        
        NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.size.height);
        NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.size.width);
        NSLog(@"BlackViewOne==%f",_BlackViewOne.frame.origin.y);
        
        NSLog(@"tableOne==%f",Table_Friend_chat.frame.size.height);
        NSLog(@"tableOne==%f",Table_Friend_chat.frame.size.width);
        NSLog(@"tableOne==%f",Table_Friend_chat.frame.origin.y);
        NSLog(@"tableOne==%f",Table_Friend_chat.frame.origin.x);
    }
}
-(void)Tablview_Tuched:(UIGestureRecognizer *)reconizer
{
    [self.view endEditing:YES];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
////    if (_BlackViewOne.frame.size.height > bth)
////    {
////        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-_BlackViewOne.frame.size.height+90);
////    }
////    else
////    {
////        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th);
////       
////    }
//   
//  
//    
//}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [textOne becomeFirstResponder];
    
//    if (textView.text.length!=0)
//    {
//        Table_Friend_chat.frame = CGRectMake(0,yt, self.view.frame.size.width, th-_BlackViewOne.frame.size.height-125);
//        
//    }
//    else
//    {
//        
//        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-(textView.contentSize.height+190));
//    }
    
    if(Array_Comment1.count>=1)
    {
        
            
            [Table_Friend_chat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Array_Comment1.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
      
    
    }
    
}


- (void)Image_UserProfileTapped:(UITapGestureRecognizer *)recognizer
{
    if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"])
    {
        [self performSegueWithIdentifier:@"next" sender:self];
    }
    else if ([[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"])
    {
         [self performSegueWithIdentifier:@"nextAd" sender:self];
    }
    else
    {
       if ([[[AllDataArray objectAtIndex:0] valueForKey:@"profiletype"] isEqualToString:@"PROFILE"])
       {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   
       }
       else
       {
           UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           
           
       }
        
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"]) {
       
        
       
        
        
    }
    else if ([segue.identifier isEqualToString:@"nextAd"])
    {
    }
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    
   
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

-(void)updateLabel
{
    [self CommentCommmunication];
}
-(void)TappedImage
{
    if (_BlackViewOne.frame.size.height > bth)
    {
        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th-_BlackViewOne.frame.size.height+90);
    }
    else
    {
        Table_Friend_chat.frame = CGRectMake(0,yt, tw, th);
        
    }
    [self.view endEditing:YES];
}
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(IBAction)FlagButton_Acion:(id)sender
{
    
   
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Unfriend" otherButtonTitles:@"Flag as inappropriate",nil];
        popup.tag = 777;
        [popup showInView:self.view];
    
  
}

-(void)UnfriendCommunication
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        //        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please Note" message:@"Internet Connection is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        message.tag=100;
        //        [message show];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm app." preferredStyle:UIAlertControllerStyleAlert];
        
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
        
        
#pragma mark - flag session
        
        
        
        
        NSString *fbid1= @"fbid1";
        NSString *fbid1Val = [defaults valueForKey:@"fid"];;
        
        NSString *fbid2= @"fbid2";
        
        NSString *fbid2val;
        
        
        if (AllDataArray.count==0)
        {
            fbid2=@"fbid2";
            fbid2val=[defaults valueForKey:@"matchedfbid"];
        }
        else
        {
            fbid2=@"fbid2";
            fbid2val=[[AllDataArray objectAtIndex:0]valueForKey:@"matchedfbid"];
            
        }
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",fbid1,fbid1Val,fbid2,fbid2val];
        
        
        
        
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"unfriend"];
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
                                                     
                                                     // Array_Swipe=[[NSMutableArray alloc]init];
                                                     
                                                     
                                                     NSString * ResultString1=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     ResultString1 = [ResultString1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     ResultString1 = [ResultString1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     if ([ResultString1 isEqualToString:@"done"])
                                                     {
                                                         UIAlertController * alert=[UIAlertController
                                                                                    
                                                                                    alertControllerWithTitle:@"Unfriend" message:@"You have unfriended this user, and you are no longer connected."preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction* yesButton = [UIAlertAction
                                                                                     actionWithTitle:@"Ok"
                                                                                     style:UIAlertActionStyleDefault
                                                                                     handler:^(UIAlertAction * action)
                                                                                     {
                                                                                         
                                                                                         [defaults setObject:@"no" forKey:@"notification"];
                                                                                         [defaults synchronize];
                                                                                         if ([[defaults valueForKey:@"letsChat"] isEqualToString:@"yes"] || [[defaults valueForKey:@"letsChatAd"] isEqualToString:@"yes"])
                                                                                         {
                                                                                             //        self.view.window.rootViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                                                                             //[self.view.window.rootViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                                                                                             
                                                                                             [self performSegueWithIdentifier:@"back" sender:self];
                                                                                         }
                                                                                         else
                                                                                         {
                                                                                             [defaults setObject:@"no" forKey:@"letsChat"];
                                                                                             [defaults setObject:@"no" forKey:@"letsChatAd"];
                                                                                             
                                                                                             [defaults synchronize];
                                                                                             if ([[defaults valueForKey:@"friendRequest"] isEqualToString:@"yes"])
                                                                                             {
                                                                                                 [defaults setObject:@"no" forKey:@"friendRequest"];
                                                                                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                 
                                                                                                 
                                                                                             }
                                                                                             else
                                                                                             {
                                                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                                                 
                                                                                             }
                                                                                             
                                                                                             
                                                                                         }
                                                                                         
                                                                                         
                                                                                         
                                                                                         [HomeTimer invalidate];
                                                                                         HomeTimer=nil;
                                                                                         
                                                                                     }];
                                                         
                                                         
                                                         [alert addAction:yesButton];
                                                         
                                                         [self presentViewController:alert animated:YES completion:nil];
                                                     }
                                                     
                                                     
                                                     
                                                 }
                                                 else
                                                 {
                                                     NSLog(@"Error...   %ld",(long)statusCode);
                                                 }
                                                 
                                             }
                                             else if (error)
                                             {
                                                 NSLog(@"flag error=%@",error.description);
                                             }
                                             
                                             
                                             
                                         }];
        
        [dataTask resume];
        
        
        
        
        
    }
    
    
}
-(void)FlagVedioCommunication
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        //        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please Note" message:@"Internet Connection is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        message.tag=100;
        //        [message show];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm app." preferredStyle:UIAlertControllerStyleAlert];
        
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
        
        
#pragma mark - flag session
        
        
        
        
        NSString *fbid1= @"fbid1";
        NSString *fbid1Val = [defaults valueForKey:@"fid"];;
        
        NSString *fbid2= @"fbid2";
        
        NSString *fbid2val;
        
        
        if (AllDataArray.count==0)
        {
            fbid2=@"fbid2";
            fbid2val=[defaults valueForKey:@"matchedfbid"];
        }
        else
        {
            fbid2=@"fbid2";
            fbid2val=[[AllDataArray objectAtIndex:0]valueForKey:@"matchedfbid"];
           
        }
        
        NSString *flagreason= @"flagreason";
        NSString *flagfrom= @"flagfrom";
        NSString *flagfromval= @"chat";
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",fbid1,fbid1Val,fbid2,fbid2val,flagreason,Str_TextfieldflagText,flagfrom,flagfromval];
        
        
        
        
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"flagprofile"];
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
                                                     
                                                     // Array_Swipe=[[NSMutableArray alloc]init];
                                         
                                                     
        NSString * ResultString1=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
        ResultString1 = [ResultString1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    ResultString1 = [ResultString1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
     if ([ResultString1 isEqualToString:@"done"])
     {
         UIAlertController * alert=[UIAlertController
                                    
                                    alertControllerWithTitle:@"User Reported" message:@"Our team will check the details of this user and appropriate action will be taken. Thank-you for your help!"preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* yesButton = [UIAlertAction
                                     actionWithTitle:@"Ok"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         
                                        
                                         
                                     }];
        
         
         [alert addAction:yesButton];
       
         [self presentViewController:alert animated:YES completion:nil];
     }
                                                     
            if ([ResultString1 isEqualToString:@"alreadydone"])
                {
                    UIAlertController * alert=[UIAlertController
                                                                                    
                    alertControllerWithTitle:@"Flagged" message:@"You have already flagged this user, and our support team will be taking an appropriate action about it. Thank-you for your concern."preferredStyle:UIAlertControllerStyleAlert];
                                                         
                    UIAlertAction* yesButton = [UIAlertAction
                        actionWithTitle:@"Ok"
                    style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                                    {
                                                                                         
                                                                                         
                                                                                         
                                    }];
                                                         
                                                         
                            [alert addAction:yesButton];
                                                         
        [self presentViewController:alert animated:YES completion:nil];
                                        }
                                       
                                                     
                                                 }
                                                 else
                                                 {
                                                     NSLog(@"Error...   %ld",(long)statusCode);
                                                 }
                                                 
                                             }
                                             else if (error)
                                             {
                                                 NSLog(@"flag error=%@",error.description);
                                             }
                                             
                                             
                                             
                                         }];
        
        [dataTask resume];
        
        
        
        
        
    }
    
 
}
@end
