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

    NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:Psiu]
                           };
    
    Usuario *user = [_appDelegate mcManager].usuario_selecionado;
    [[_appDelegate mcManager] sendMessage:user.peer withDict:dict];


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
