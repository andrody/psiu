//
//  PerfilViewController.m
//  MCDemo
//
//  Created by bepid on 05/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "PerfilViewController.h"
#import "AppDelegate.h"
#import "MCManager.h"



@interface PerfilViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *psiu_btn;
@property (weak, nonatomic) IBOutlet UIView *gradient;
@property (weak, nonatomic) IBOutlet UILabel *nome_idade;

@end

@implementation PerfilViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    UIColor *cor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.4];
    
    //[[_psiu_btn layer] setBorderWidth:2.0f];
    //[[_psiu_btn layer] setBorderColor:cor.CGColor];
    
    
    float f = _psiu_btn.frame.size.width / 2;
    [[_psiu_btn layer] setMasksToBounds:YES];
    //[[_psiu_btn layer] setCornerRadius:f];
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (_psiu_btn.frame.size.width), (_psiu_btn.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:f];
    [borderLayer setBorderWidth:3.0];
    [borderLayer setBorderColor:cor.CGColor];
    [[_psiu_btn layer] addSublayer:borderLayer];
    
    CABasicAnimation* borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    [borderAnimation setFromValue:[NSNumber numberWithFloat:6.0f]];
    [borderAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
    [borderAnimation setRepeatCount:INT16_MAX];
    [borderAnimation setAutoreverses:YES];
    [borderAnimation setDuration:0.4f];
    
    [borderLayer addAnimation:borderAnimation forKey:@"animateBorder"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Usuario *user = [_appDelegate mcManager].usuario_selecionado;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradient.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [_gradient.layer insertSublayer:gradient atIndex:0];
    
    _nome_idade.text = user.nome;
    _imagem.image = user.imagem;
    




    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mandarPsiu:(UIButton *)sender {
    Usuario *user = [_appDelegate mcManager].usuario_selecionado;

    if(![[_appDelegate mcManager].usuarios_dei_psiu containsObject:user]) {
    NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:Psiu]
                           };
    
    
    bool match = [[_appDelegate mcManager] checkMatch:user];
    
    if(match) {
        
        NSDictionary *user_dict = @{@"user_dict": user};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCMatch"
                                                            object:nil
                                                          userInfo:user_dict];
        
    }
    
    else {
        
        if([_appDelegate mcManager].usuarios_dei_psiu == nil) [_appDelegate mcManager].usuarios_dei_psiu = [NSMutableArray new];
        if([_appDelegate mcManager].usuarios_psiu == nil) [_appDelegate mcManager].usuarios_psiu = [NSMutableArray new];

        [[_appDelegate mcManager].usuarios_dei_psiu addObject:user];
        [[_appDelegate mcManager].usuarios_psiu addObject:user];

    }                                   
    
   
    [[_appDelegate mcManager] sendMessage:user.peer withDict:dict];
    }


}


- (IBAction)voltar:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
