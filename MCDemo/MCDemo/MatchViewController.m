//
//  MatchViewController.m
//  MCDemo
//
//  Created by bepid on 05/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "MatchViewController.h"
#import "AppDelegate.h"
#import "Usuario.h"
#import <QuartzCore/QuartzCore.h>


@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textMatch;
@property (weak, nonatomic) IBOutlet UILabel *textUser;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) Usuario *user;
@property (weak, nonatomic) IBOutlet UIView *viewOptions;

@end

@implementation MatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _user = [_appDelegate mcManager].usuario_match;
    _textMatch.text = @"A pessoa abaixo tambem deu psiu para voce!";
    _textUser.text = _user.nome;
    _imageView.image = _user.imagem;
    _imageView.layer.cornerRadius = 5.0;
    _imageView.layer.borderColor = (__bridge CGColorRef)([UIColor blueColor]);
    [_imageView.layer setBorderWidth: 10.0f];
    _imageView.layer.borderWidth = 10.0f;
    
    // Do any additional setup after loading the view.
}
- (IBAction)optionSelected:(UIButton *)sender {
    
    [_viewOptions removeFromSuperview];
    UIImageView *action =[[UIImageView alloc] initWithFrame:CGRectMake(20,240,280,175)];
    action.image=[UIImage imageNamed:@"kate2.jpg"];
    [self.view addSubview:action];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
