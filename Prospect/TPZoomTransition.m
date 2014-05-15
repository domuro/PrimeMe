//
//  TPZoomTransition.m
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPZoomTransition.h"

static NSTimeInterval const TRANSITION_DURATION = 0.2f;
static int const IPAD_WIDTH = 1024;
static int const IPAD_HEIGHT = 768;

@implementation TPZoomTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
//        toViewController.view.center = CGPointMake(IPAD_WIDTH/2., 4/9. * IPAD_HEIGHT);
        toViewController.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:TRANSITION_DURATION delay:0 options:0 animations:^{
        if (self.reverse) {
            fromViewController.view.center = CGPointMake(IPAD_WIDTH/2., 4/9. * IPAD_HEIGHT);
            fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }
        else {
            toViewController.view.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return TRANSITION_DURATION;
}

@end
