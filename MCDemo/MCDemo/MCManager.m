//
//  MCManager.m
//  MCDemo
//
//  Created by Gabriel Theodoropoulos on 1/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "MCManager.h"


@implementation MCManager

-(id)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
        _myUser = [Usuario new];
        _myUser.image_url = nil;
        
        
    }
    
    
    
    return self;
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    //MCSession *session = [[MCSession alloc] initWithPeer:peerID];
    //session.delegate = self;
    
    //NSArray *ArrayInvitationHandler = [NSArray arrayWithObject:[invitationHandler copy]];
    
    //void (^invitationHandleer)(BOOL, MCSession *) = [ArrayInvitationHandler objectAtIndex:0];
    invitationHandler(YES, _session);
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {

}

#pragma mark - Public method implementation

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}


-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"psiu" session:_session];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        
        //UIImage *img = [UIImage imageNamed:@"kate.jpg"];
        
        
        //[_peerID setValue:img forKey:@"imagem"];
        
        //NSDictionary *dict = @{@"imagem": img};
        
        //MCNearbyServiceAdvertiser *advertiser =
        //[[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID
                                          //discoveryInfo:dict
                                            //serviceType:@"psiu"];
        //advertiser.delegate = self;
        //[advertiser startAdvertisingPeer];
        
        
        
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:@"psiu"];
        self.advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
    }
    else{
        [_advertiser stopAdvertisingPeer];
        _advertiser = nil;
        
    }
}


#pragma mark - MCSession Delegate method implementation


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    if(state == MCSessionStateConnected) {
        
        
        //[self sendUserInfo:peerID];
        [self sendFoto:peerID];
        
    }
    
}

-(void) sendFoto:(MCPeerID *)peerID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Avatar-blank.jpg"];
    NSString *modifiedName = [NSString stringWithFormat:@"%@, %@", _myUser.nome, _myUser.idade];
    
    
    
    
    NSURL *resourceURL;
    
    if(_myUser.image_url == nil)
        resourceURL = [NSURL fileURLWithPath:filePath];
    else
        resourceURL = _myUser.image_url;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSProgress *progress = [self.session sendResourceAtURL:resourceURL
                                                                        withName:modifiedName
                                                                          toPeer:peerID
                                                           withCompletionHandler:^(NSError *error) {
                                                               if (error) {
                                                                   NSLog(@"Error34: %@", [error localizedDescription]);
                                                               }
                                                               
                                                               else{                                                                }
                                                           }];
    
        NSLog(@"*** %f", progress.fractionCompleted);
        
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        });
    
}

-(void)sendUserInfo:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"tipo": [NSNumber numberWithInt:ChangeUserName],
                           @"nome": _myUser.nome,
                           @"idade": _myUser.idade};
    
    NSArray *allPeers = @[peerID];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSError *error;
    
    [_session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];

    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
   
}

-(bool)checkMatch:(Usuario *)user {
    
    for(Usuario *u in _usuarios_psiu){
        if ([u isEqual:user]){
            return true;
            break;
        }
    }
    return false;
    
}

-(void)sendMessage:(MCPeerID *)peerID withDict:(NSDictionary *)dict {
    
    NSArray *allPeers = @[peerID];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSError *error;
    
    [_session sendData:dataToSend
               toPeers:allPeers
              withMode:MCSessionSendDataReliable
                 error:&error];
    
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    double h = [object fractionCompleted] * 100;
    NSLog(@"Enviado: %g", h);
    
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSInteger tipoMsg = [dictionary[@"tipo"] integerValue];
    
    Usuario *user;
    for(Usuario *u in _usuarios){
        if ([u.peer isEqual:peerID]){
            user = u;
            break;
        }
    }
    if(tipoMsg == ChangeUserName) {
        
        NSString *nome = [dictionary objectForKey:@"nome"];
        NSString *idade = [dictionary objectForKey:@"idade"];

        user.nome = [NSString stringWithFormat:@"%@, %@", nome, idade];
        
        
    }

    
    else if(tipoMsg == Psiu) {
    
        user.psiu = Psiu;
        [self playPsiu];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

        
    }
    
    else if (tipoMsg == Match) {
        
        [self playPsiu];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //_usuario_selecionado = user;
        NSDictionary *user_dict = @{@"user_dict": user};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Match"
                                                            object:nil
                                                          userInfo:user_dict];
        
    }
    
    else if (tipoMsg == SPapo || tipoMsg == SAbraco || tipoMsg == SSelinho || tipoMsg == SLingua) {
        
        user.sacanagem = tipoMsg;
        
    }
    
    else if (tipoMsg == SacanagemFinal) {
        NSInteger sacanagemFinal = [dictionary[@"sacanagemFinal"] integerValue];
        user.sacanagem = sacanagemFinal;
        user.sacanagem_final_escolhida = YES;
        
        //_usuario_selecionado = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MostrarGif"
                                                            object:nil
                                                          userInfo:dict];
        
    }
    
    else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
    }
}

-(void) playPsiu {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"psiuSE" ofType:@"wav"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    
    self.theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    
    self.theAudio.volume = 1.0;
    
    self.theAudio.delegate = self;
    
    [self.theAudio prepareToPlay];
    
    [self.theAudio play];
    
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"progress"      :   progress
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidStartReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    });
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
    if(error == nil) {
        NSDictionary *dict = @{@"resourceName"  :   resourceName,
                               @"peerID"        :   peerID,
                               @"localURL"      :   localURL
                               };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    }
    else {
        NSLog(@"Error receive data: %@", [error localizedDescription]);    }
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}


/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
                                                        object:nil
                                                      userInfo:@{@"progress": (NSProgress *)object}];
}*/

@end
