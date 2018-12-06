//
//  EnterComment.h
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/15/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterComment : UIView
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;



- (IBAction)closeButton_Action:(id)sender;
- (IBAction)submitButton_Action:(id)sender;

@end
