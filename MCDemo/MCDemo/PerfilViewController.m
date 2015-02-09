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
#import "PerfilTableCell.h"
#import "Option.h"
#import "GifViewController.h"

@interface PerfilViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagem;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *psiu_btn;
@property (weak, nonatomic) IBOutlet UIView *gradient;
@property (weak, nonatomic) IBOutlet UILabel *nome_idade;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOptions;
@property NSArray *options;
@property Usuario *user;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollV;



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
    
    if (_user.match == YES && self.user.sacanagem_ja_escolhida == NO) {
        [_tableScrollV setHidden:NO];
        [self animateOptions];
    }
    
    else {
        [_tableScrollV setHidden:YES];
        [self animatePsiuButton];
        [self showPsiuBtn];
    }
}

-(void) animatePsiuButton {
    
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
    [borderAnimation setFromValue:[NSNumber numberWithFloat:14.0f]];
    [borderAnimation setToValue:[NSNumber numberWithFloat:2.0f]];
    [borderAnimation setRepeatCount:INT16_MAX];
    [borderAnimation setAutoreverses:YES];
    [borderAnimation setDuration:0.4f];
    
    [borderLayer addAnimation:borderAnimation forKey:@"animateBorder"];
    
}

-(void) animateOptions {
    
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    CGRect optionsFrame = self.tableViewOptions.frame;
    optionsFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.tableViewOptions.frame = optionsFrame;
    
    [UIView commitAnimations];
    
}

-(void) hideOptions {
    
    //CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    CGRect optionsFrame = self.tableViewOptions.frame;
    optionsFrame.origin.y = 240;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.tableViewOptions.frame = optionsFrame;
    
    [UIView commitAnimations];
    
}



-(void)showPsiuBtn{
    
    [UIView beginAnimations: @"Fade In" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:.5];
    //show your view with Fade animation lets say myView
    [_psiu_btn setHidden:FALSE];
    
    
    [UIView commitAnimations];
}


-(void)hidePsiuBtn{
    [UIView beginAnimations: @"Fade Out" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:.5];
    //hide your view with Fad animation
    [_psiu_btn setHidden:TRUE];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewOptions.delegate = self;
    _tableViewOptions.dataSource = self;
    
    [[_imagem layer] setCornerRadius:40];
    
    /*if (_user.match == YES) {
        [_psiu_btn setHidden:YES];
    }
    
    else {
        [_psiu_btn setHidden:NO];        
    }*/
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _user = [_appDelegate mcManager].usuario_selecionado;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradient.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [_gradient.layer insertSublayer:gradient atIndex:0];
    
    _nome_idade.text = _user.nome;
    _imagem.image = _user.imagem;
    
    NSString *anos = @"Anos";
    [self  setTitle:_user.nome];
    
    UIColor *azul = [UIColor colorWithRed:75.0/255.0 green:148.0/255.0 blue:229.0/255.0 alpha:1];
    UIColor *roxo = [UIColor colorWithRed:79.0/255.0 green:74.0/255.0 blue:181.0/255.0 alpha:1];
    UIColor *lilas = [UIColor colorWithRed:194.0/255.0 green:91.0/255.0 blue:220.0/255.0 alpha:1];
    UIColor *vermelho = [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:130.0/255.0 alpha:1];

    
    _options = @[[[Option new] setName:@"Bater Papo" cor:azul sacanagem:SPapo],
                 [[Option new] setName:@"Abraço e Beijo no Rosto" cor:roxo sacanagem:SAbraco],
                 [[Option new] setName:@"Selinho" cor:lilas sacanagem:SSelinho],
                 [[Option new] setName:@"Beijo de Lingua" cor:vermelho sacanagem:SLingua]
                 ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didMatch:)
                                                 name:@"Match"
                                               object:nil];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_options count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PerfilTableCell *cell = [_tableViewOptions dequeueReusableCellWithIdentifier:@"optionCelula" forIndexPath:indexPath];

    cell.option.text = [[_options objectAtIndex:indexPath.row] nome];
    cell.conteudoView.backgroundColor = [[_options objectAtIndex:indexPath.row] cor];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.user.sacanagem_ja_escolhida != YES) {
        [self hideOptions];
        self.user.sacanagem_ja_escolhida = YES;
        if(self.user.sacanagem == -1) {
            self.user.sacanagem = indexPath.row;

            //[self.navigationController pushViewController: perfilView animated:YES];
            //[self presentViewController:gifView animated:YES completion:nil];
            //[self dismissViewControllerAnimated:YES completion:nil];


            NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:indexPath.row]};
            [[_appDelegate mcManager] sendMessage:self.user.peer withDict:dict];
        }
        else {
            
            if (self.user.sacanagem > indexPath.row) self.user.sacanagem = indexPath.row;
            
            NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:SacanagemFinal],@"sacanagemFinal":[NSNumber numberWithInt:self.user.sacanagem]};
            [[_appDelegate mcManager] sendMessage:self.user.peer withDict:dict];
            
            self.user.sacanagem_final_escolhida = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MostrarGif"
                                                                object:nil
                                                              userInfo:dict];
            
        }
    }
}

-(NSInteger) getFinalSacanagem:(NSInteger)sacanagem {
    
    if (self.user.sacanagem > sacanagem) {
        self.user.sacanagem = sacanagem;
    }
    return self.user.sacanagem;
    
}


- (IBAction)mandarPsiu:(UIButton *)sender {
    
    //[[[[_psiu_btn layer] sublayers] objectAtIndex:1] removeAnimationForKey:@"animateBorder"];
    
    [_psiu_btn setImage:[UIImage imageNamed:@"psiubotao_off.png"] forState:UIControlStateDisabled];
    _psiu_btn.imageView.image = [UIImage imageNamed:@"psiubotao_off.png"];
    [_psiu_btn setEnabled:NO];
    
    Usuario *user = [_appDelegate mcManager].usuario_selecionado;

    if (user.psiu == -1) {
        NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:Psiu]};
        [[_appDelegate mcManager] sendMessage:user.peer withDict:dict];
    }
    
    else {
        
        NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:Match]};
        [[_appDelegate mcManager] sendMessage:user.peer withDict:dict];
        
        NSDictionary *user_dict = @{@"user_dict": user};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Match"
                                                            object:nil
                                                          userInfo:user_dict];
        
    }
    
    


}


- (IBAction)voltar:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)didMatch:(NSNotification *)notification{
    
    Usuario *user_match = [[notification userInfo] objectForKey:@"user_dict"];
    if([_user isEqual:user_match]) {
        _user.match = YES;
        [self performSelectorOnMainThread:@selector(viewDidAppear:) withObject:nil waitUntilDone:NO];

    }

}




@end
