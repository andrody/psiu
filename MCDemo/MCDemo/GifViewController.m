//
//  GifViewController.m
//  MCDemo
//
//  Created by Andrew on 12/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "GifViewController.h"
#import "Usuario.h"
#import "AppDelegate.h"

@interface GifViewController ()

@property NSArray *labels;
@property NSArray *gifs;
@property Usuario *user;
@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = [self.appDelegate mcManager].usuario_selecionado;
    
    self.gifs = @[@"sacanagem_batepapo", @"sacanagem_abraco", @"sacanagem_selinho", @"sacanagem_selinho"];
    self.labels = @[@"label_batepapo.png", @"label_abraco.png", @"label_selinho.png", @"label_lingua.png"];

    NSString *label = [self.labels objectAtIndex:self.user.sacanagem];
    NSString *gif = [self.gifs objectAtIndex:self.user.sacanagem];

    FLAnimatedImage *gifImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gif ofType:@"gif"]]];
    
    self.gif.animatedImage = gifImage;
    [self.view addSubview:self.gif];
    
    self.sacanagemImage.image = [UIImage imageNamed:label];
}

-(void) viewDidAppear:(BOOL)animated {
    
    [self showView];
    
}

-(void)showView{
    
    self.sacanagemImage.alpha = 0.0;
    [self.sacanagemImage setHidden:NO];
    [UIView beginAnimations:@"Fade-in" context:NULL];
    [UIView setAnimationDelay:5.0];
    [UIView setAnimationDuration:1.0];
    self.sacanagemImage.alpha = 1.0;
    
    CGRect optionsFrame = self.sacanagemImage.frame;
    optionsFrame.origin.y = 77;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.sacanagemImage.frame = optionsFrame;
    
    [UIView commitAnimations];
}

-(void)hideView{
    [UIView beginAnimations: @"Fade Out" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:.5];
    //hide your view with Fad animation
    [_sacanagemImage setHidden:TRUE];
    [UIView commitAnimations];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
