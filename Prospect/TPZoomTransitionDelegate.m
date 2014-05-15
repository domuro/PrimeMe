//
//  TPZoomTransitionDelegate.m
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPZoomTransitionDelegate.h"
#import "TPZoomTransition.h"

@implementation TPZoomTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    TPZoomTransition *transitioning = [TPZoomTransition new];
    return transitioning;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TPZoomTransition *transitioning = [TPZoomTransition new];
    transitioning.reverse = YES;
    return transitioning;
}

@end