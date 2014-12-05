//
//  ViewControllerConfig.m
//  MCDemo
//
//  Created by bepid on 03/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ViewControllerConfig.h"
#import "AppDelegate.h"
#import "Usuario.h"

@interface ViewControllerConfig ()
@property (weak, nonatomic) IBOutlet UIImageView *fotoUser;
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *textoNome;
@property (weak, nonatomic) IBOutlet UITextField *textoidade;
@property Usuario *user;

@end

@implementation ViewControllerConfig

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textoNome.delegate =self;
    _textoidade.delegate =self;

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _user = [_appDelegate mcManager].myUser;
    _textoidade.text = _user.idade;
    _textoNome.text = _user.nome;
    
    _fotoUser.image = _user.imagem;
    
    if(_user.imagem == nil) _fotoUser.image = [UIImage imageNamed:@"Avatar-blank.jpg"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    
    if ([touch view] == _fotoUser){
        
        [self getPhoto];
    }
}
- (IBAction)cancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) getPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _fotoUser.image = pickedImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"avatar.jpg"];
    
    NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
    [imageData writeToFile:path atomically:YES];
    
    _user.imagem = _fotoUser.image;
    _user.image_url = [NSURL fileURLWithPath:path];
    
    NSMutableArray *usuarios = [_appDelegate mcManager].usuarios;
    
    for(Usuario *u in usuarios) {
        [[_appDelegate mcManager] sendFoto:u.peer];
    }
    
    [self salvar];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;  // Hide both keyboard and blinking cursor.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [_textoNome resignFirstResponder];
    [_textoidade resignFirstResponder];
    
    
    _user.nome = _textoNome.text;
    _user.idade = _textoidade.text;
    [self salvar];
    
    return YES;
}

-(void)salvar {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:_user.nome forKey:@"user_nome"];
    [defaults setValue:_user.idade forKey:@"user_idade"];
    [defaults setURL:_user.image_url forKey:@"user_image_url"];
    //[defaults setValue:_user.imagem forKey:@"user_image"];
    
    [defaults synchronize];
    
}

@end
