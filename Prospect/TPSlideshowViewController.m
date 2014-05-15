//
//  TPSlideshowViewController.m
//  Prospect
//
//  Created by Derek Omuro on 4/18/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "TPSlideshowViewController.h"
#import "UIImage+TPThumbnail.h"

@interface TPSlideshowViewController ()

@end

@implementation TPSlideshowViewController
@synthesize event, index;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    unsigned long layout = [[event.images objectAtIndex:index] count];
    NSMutableArray *panels = [[NSMutableArray alloc] initWithCapacity:layout];
    for(int j = 0; j < layout; j++){
//        UIImage *image = [[[event.images objectAtIndex:index] objectAtIndex:j] getThumbnail:CGSizeMake(500, 500)];
        UIImage *image = [[event.images objectAtIndex:index] objectAtIndex:j];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        [iv setClipsToBounds:YES];
        [panels addObject:iv];
    }
    CGRect bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    switch (layout) {
        case 1:
            [[panels objectAtIndex:0] setFrame:bounds];
            break;
        case 2:
            bounds.size.width = bounds.size.width * 4/7;
            [[panels objectAtIndex:0] setFrame:bounds];
            bounds.origin.x += bounds.size.width+0.5;
            bounds.size.width = self.view.bounds.size.height - bounds.size.width - 0.5;
            [[panels objectAtIndex:1] setFrame:bounds];
            break;
        case 3:
            bounds.size.width = bounds.size.width/2;
            [[panels objectAtIndex:0] setFrame:bounds];
            bounds.size.width -= 0.5;
            bounds.origin.x += bounds.size.width + 1;
            bounds.size.height = bounds.size.height/2;
            [[panels objectAtIndex:1] setFrame:bounds];
            bounds.size.height -= 0.5;
            bounds.origin.y += bounds.size.height + 1;
            [[panels objectAtIndex:2] setFrame:bounds];
            break;
        case 4:
            bounds.size.width = bounds.size.width *3/5;
            [[panels objectAtIndex:0] setFrame:bounds];
            bounds.origin.x += bounds.size.width + 0.5;
            bounds.size.width = self.view.bounds.size.height - bounds.size.width - 0.5;
            bounds.size.height = bounds.size.height/3 - 0.5;
            [[panels objectAtIndex:1] setFrame:bounds];
            bounds.origin.y += bounds.size.height + 0.5;
            [[panels objectAtIndex:2] setFrame:bounds];
            bounds.origin.y += bounds.size.height + 0.5;
            [[panels objectAtIndex:3] setFrame:bounds];
            break;
        default:
            break;
    }
    
    for(int k = 0; k < layout; k++){
        [self.view addSubview:panels[k]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
