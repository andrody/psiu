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
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Usuario *myuser = [_appDelegate mcManager].myUser;
    myuser.nome = [defaults objectForKey:@"user_nome"];
    myuser.idade = [defaults objectForKey:@"user_idade"];
    myuser.image_url = [defaults URLForKey:@"user_image_url"];
    myuser.imagem = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:myuser.image_url]];

    
    if([_appDelegate mcManager].usuarios == nil)
        [_appDelegate mcManager].usuarios = [NSMutableArray new];
    _usuarios = [_appDelegate mcManager].usuarios;   
    
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:YES];
    
    
    
    _browser = [[MCNearbyServiceBrowser alloc]initWithPeer:[_appDelegate mcManager].peerID  serviceType:@"chat-files"];
    [_browser setDelegate:self];
    [_browser startBrowsingForPeers];
    
    [self copySampleFilesToDocDirIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_usuarios count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celula" forIndexPath:indexPath];
    
    Usuario *user = [_usuarios objectAtIndex:indexPath.row];
    cell.foto.image = user.imagem;
    
    return cell;
}

-(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification{
    
    Usuario *user = [Usuario new];
    NSDictionary *dict = [notification userInfo];
    
    user.peer =[dict objectForKey:@"peerID"];
    
    NSURL *localURL = [dict objectForKey:@"localURL"];
    
    NSData *data = [NSData dataWithContentsOfURL:localURL];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    //NSString *resourceName = [dict objectForKey:@"resourceName"];
    bool existe_user = false;
    for(Usuario *u in _usuarios){
        if ([u.peer isEqual:user.peer]){
            u.imagem = img;
            existe_user = true;
        }
    }
    
    if(existe_user == false) {
        user.imagem = img;
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
    
    NSString *file1Path = [_documentsDirectory stringByAppendingPathComponent:@"kate2.jpg"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    if (![fileManager fileExistsAtPath:file1Path]) {
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"kate2" ofType:@"jpg"]
                             toPath:file1Path
                              error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        
    }
}







@end
