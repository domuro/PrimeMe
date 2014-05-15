//
//  UIImage+TPThumbnail.m
//  Prospect
//
//  Created by Derek Omuro on 4/23/14.
//  Copyright (c) 2014 TeamProspect. All rights reserved.
//

#import "UIImage+TPThumbnail.h"

@implementation UIImage (TPThumbnail)

-(UIImage *)getThumbnail:(CGSize) size // as a category (so, 'self' is the input image)
{
    // fromCleverError's original
    // http://stackoverflow.com/questions/17884555
    CGSize finalsize = size;
    
    CGFloat scale = MAX(
                        finalsize.width/self.size.width,
                        finalsize.height/self.size.height);
    CGFloat width = self.size.width * scale;
    CGFloat height = self.size.height * scale;
    
    CGRect rr = CGRectMake( 0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(finalsize, NO, 0);
    [self drawInRect:rr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
