//
//  GifViewController.h
//  MCDemo
//
//  Created by Andrew on 12/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h" 
#import "FLAnimatedImageView.h"

@interface GifViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *sacanagemImage;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gif;

@end
