//
//  TPPagedPreviewScrollView.m
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPPagedPreviewScrollView.h"

@implementation TPPagedPreviewScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //NSLog(@"in hittest %f, %f", point.x, point.y);
    int pageWidth = 1024 * 10/16;
    CGPoint normalPoint = CGPointMake((int)(point.x)%pageWidth, point.y);
    CGRect normalRect = CGRectMake(0, 0, self.frame.size.width-1024*2/16, self.frame.size.height);
    if(CGRectContainsPoint(normalRect, normalPoint)){
        int expectedPage = (int)self.contentOffset.x / pageWidth;
        int tappedPage = (int)point.x / pageWidth;
        if(expectedPage == tappedPage)
            return [super hitTest:point withEvent:event];
    }
    return self;
}
@end
