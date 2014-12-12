//
//  Cell.h
//  DemoColletionView
//
//  Created by bepid on 24/11/14.
//  Copyright (c) 2014 Bepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *foto;

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loadingImage;




@end
