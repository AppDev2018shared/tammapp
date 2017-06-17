//
//  EnterPrice.m
//  Haraj_app
//
//  Created by Spiel on 12/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "EnterPrice.h"


@implementation EnterPrice

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
        [self.priceTextField becomeFirstResponder];
    }
    
    return self;
}
-(BOOL)becomeFirstResponder
{
    return YES;
}


- (IBAction)closeAction:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePopOver" object:self userInfo:nil];
    
          
    
}
@end
