//
//  EnterComment.m
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/15/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "EnterComment.h"

@implementation EnterComment

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    
    return self;
}



- (IBAction)closeButton_Action:(id)sender
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"HideEnterCommentPopOver" object:self userInfo:nil];
}
- (IBAction)submitButton_Action:(id)sender
{
    
    
}
@end
