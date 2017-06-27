//
//  ChattingViewController.m
//  Haraj_app
//
//  Created by Spiel on 27/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ChattingViewController.h"
#import "ChatOneTableViewCell.h"
#import "ChatTwoTableViewCell.h"

@interface ChattingViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    ChatOneTableViewCell *ChatOneCell;
    ChatTwoTableViewCell *ChatTwoCell;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Chat;
    NSMutableData *webData_Chat;
    NSMutableArray *Array_Chat;
    
}

@end

@implementation ChattingViewController
@synthesize userImageView,postIdLabel,postImageView,dateLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];
    
    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2 ;
    userImageView.clipsToBounds = YES;
    
    
    postImageView.layer.cornerRadius = 10;
    postImageView.clipsToBounds = YES;
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2 == 0)
    {
        ChatOneCell = [tableView dequeueReusableCellWithIdentifier:@"CellOne"];
        
       // ChatOneCell.cellOneImageView.layer.cornerRadius =
        
        ChatOneCell.cellOneImageView.layer.cornerRadius = ChatOneCell.cellOneImageView.frame.size.height / 2;
        ChatOneCell.cellOneImageView.clipsToBounds = YES;
        ChatOneCell.cellOneMessageLabel.layer.cornerRadius = 6;
        ChatOneCell.cellOneMessageLabel.clipsToBounds = YES;
        
        
        return ChatOneCell;

    }
    else
    {
    
        ChatTwoCell = [tableView dequeueReusableCellWithIdentifier:@"CellTwo"];
        
        ChatTwoCell.cellTwoImageView.layer.cornerRadius = ChatTwoCell.cellTwoImageView.frame.size.height / 2;
        ChatTwoCell.cellTwoImageView.clipsToBounds = YES;
        
        ChatTwoCell.cellTwoMessageLabel.layer.cornerRadius = 6;
        ChatTwoCell.cellTwoMessageLabel.clipsToBounds = YES;

    
    return ChatTwoCell;
    }
}

- (IBAction)BackButton_Action:(id)sender
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];

    
}

@end
