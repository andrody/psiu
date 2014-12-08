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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Usuario *user = [_appDelegate mcManager].usuario_selecionado;
    
    _imagem.image = user.imagem;
    
    [self setTitle:user.nome];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mandarPsiu:(UIBarButtonItem *)sender {
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
