//
//  ViewController.m
//  PsiuProvaDeConceito
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 Bepid. All rights reserved.
//

#import "UsersViewController.h"
#import "AppDelegate.h"
#import "Usuario.h"
#import "Cell.h"
#import "PerfilViewController.h"
#import "MatchViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface UsersViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *usuarios;
@property (nonatomic, strong) NSString *documentsDirectory;


@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collection_dispositivos setDelegate:self];
    [_collection_dispositivos setDataSource:self];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //UIColor *color =[UIColor colorWithRed:136.0/255.0 green:221.0/255.0 blue:187.0/255.0 alpha:1];
    
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color}];
    
    //[self.navigationController.navigationBar.layer setBorderWidth:2.0];// Just to make sure its working
    //[self.navigationController.navigationBar.layer setBorderColor:[color CGColor]];

    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //-----Persistência de dados-----
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Usuario *myuser = [_appDelegate mcManager].myUser;
    myuser.nome = [defaults objectForKey:@"user_nome"];
    myuser.idade = [defaults objectForKey:@"user_idade"];
    myuser.image_url = [defaults URLForKey:@"user_image_url"];
    myuser.imagem = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:myuser.image_url]];
    //-----Persistência de dados-----
    
    
    if([_appDelegate mcManager].usuarios == nil)
        [_appDelegate mcManager].usuarios = [NSMutableArray new];
    _usuarios = [_appDelegate mcManager].usuarios;
    
    if([_appDelegate mcManager].usuario_match == nil) [_appDelegate mcManager].usuario_match = [Usuario new];
    if([_appDelegate mcManager].usuarios_match == nil) [_appDelegate mcManager].usuarios_match = [NSMutableArray new];

    
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:YES];
    
    
    
    _browser = [[MCNearbyServiceBrowser alloc]initWithPeer:[_appDelegate mcManager].peerID  serviceType:@"psiu"];
    [_browser setDelegate:self];
    [_browser startBrowsingForPeers];
    
    [self copySampleFilesToDocDirIfNeeded];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didMatch:)
                                                 name:@"Match"
                                               object:nil];
}


-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    for(Usuario *u in _usuarios){
        if ([u.peer isEqual:peerID]){
            [_usuarios removeObject:u];
            [_collection_dispositivos reloadData];
            break;
        }
    }
    
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    /*Usuario *user = [Usuario new];
    user.peer = peerID;
    user.imagem = info[@"imagem"];
    [_dipositivos addObject:user];
    [_collection_dispositivos reloadData];*/
    
    [browser invitePeer:peerID toSession:[_appDelegate mcManager].session withContext:nil timeout:50.0];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row < [_usuarios count]) {
    
        [_appDelegate mcManager].usuario_selecionado = [_usuarios objectAtIndex:indexPath.row];
        
        PerfilViewController *perfilView = [self.storyboard instantiateViewControllerWithIdentifier:@"perfilCtrl"];
    
        //[self.navigationController pushViewController: perfilView animated:YES];
        [self presentViewController:perfilView animated:YES completion:nil];

        
    }
    
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger valor = [_usuarios count];
    if(valor < 6) return 6;
    return valor;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celula" forIndexPath:indexPath];
    NSInteger valor = [_usuarios count];
    
    if(indexPath.row >= valor) {
        cell.foto.image = nil;
        cell.foto.alpha = 0.2;
        return cell;
    }
    cell.foto.alpha = 1.0;
    Usuario *user = [_usuarios objectAtIndex:indexPath.row];
    cell.foto.image = user.imagem;
    /*cell.foto.layer.cornerRadius = 5.0;
    cell.foto.layer.borderColor = (__bridge CGColorRef)([UIColor blueColor]);
    [cell.foto.layer setBorderWidth: 10.0f];
    cell.foto.layer.borderWidth = 10.0f;*/
    
    /*cell.foto.clipsToBounds = YES;
    CALayer * l = [cell.foto layer];
    [l setMasksToBounds:YES];
    float f = cell.foto.frame.size.width / 2;
    [l setCornerRadius:f];
    
    UIColor *color = [UIColor whiteColor];
    float borderW = 4.0f;
    
    if([[_appDelegate mcManager].usuarios_match containsObject:user]){
        color = [UIColor redColor];
        borderW = 2.0f;
    }
    
    // You can even add a border
    [l setBorderWidth:borderW];
    [l setBorderColor:[color CGColor]];*/
    
    return cell;
}

-(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification{
    
    Usuario *user = [Usuario new];
    NSDictionary *dict = [notification userInfo];
    
    user.peer =[dict objectForKey:@"peerID"];
    
    NSURL *localURL = [dict objectForKey:@"localURL"];
    
    NSData *data = [NSData dataWithContentsOfURL:localURL];
    UIImage *img = [[UIImage alloc] initWithData:data];
    NSString *nome = [dict objectForKey:@"resourceName"];
    
    //NSString *resourceName = [dict objectForKey:@"resourceName"];
    bool existe_user = false;
    for(Usuario *u in _usuarios){
        if ([u.peer isEqual:user.peer]){
            u.imagem = img;
            u.nome = nome;
            existe_user = true;
        }
    }
    
    if(existe_user == false) {
        user.imagem = img;
        user.nome = nome;
        [_usuarios addObject:user];
    }
    
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    //[fileManager copyItemAtURL:localURL toURL:destinationURL error:&error];
    
    //if (error) {
    //    NSLog(@"%@", [error localizedDescription]);
    //}
    
   
    
    [_collection_dispositivos performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)copySampleFilesToDocDirIfNeeded{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    
    NSString *file1Path = [_documentsDirectory stringByAppendingPathComponent:@"Avatar-blank.jpg"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    if (![fileManager fileExistsAtPath:file1Path]) {
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Avatar-blank" ofType:@"jpg"]
                             toPath:file1Path
                              error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];

    for(Usuario *u in _usuarios){
        if ([u.peer isEqual:peerID]){
            u.nome = [NSString stringWithFormat:@"%@,%@", dict[@"nome"], dict[@"idade"]];
        }
    }
    
    
    
}

-(void)didMatch:(NSNotification *)notification{
    
    Usuario *user_match = [[notification userInfo] objectForKey:@"user_dict"];
    user_match.match = YES;
    [_appDelegate mcManager].usuario_match = user_match;
    [[_appDelegate mcManager].usuarios_match addObject:[_appDelegate mcManager].usuario_match];
    [self performSelectorOnMainThread:@selector(telaMatch) withObject:nil waitUntilDone:NO];
    
}

-(void) telaMatch {
    
    //[_collection_dispositivos reloadData];
    //MatchViewController *matchView = [self.storyboard instantiateViewControllerWithIdentifier:@"matchCtrl"];
    
    //[self.navigationController pushViewController: matchView animated:YES];
    
    PerfilViewController *perfilView = [self.storyboard instantiateViewControllerWithIdentifier:@"perfilCtrl"];
    
    //[self.navigationController pushViewController: perfilView animated:YES];
    [self presentViewController:perfilView animated:YES completion:nil];
    
}









@end
