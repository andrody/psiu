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
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        
        //UIImage *img = [UIImage imageNamed:@"kate.jpg"];
        
        
        //[_peerID setValue:img forKey:@"imagem"];
        
        //NSDictionary *dict = @{@"imagem": img};
        
        //MCNearbyServiceAdvertiser *advertiser =
        //[[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID
                                          //discoveryInfo:dict
                                            //serviceType:@"chat-files"];
        //advertiser.delegate = self;
        //[advertiser startAdvertisingPeer];
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:@"chat-files"];
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
        
        [self sendFoto:peerID];
        
        
    }
    
}

-(void) sendFoto:(MCPeerID *)peerID {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"kate2.jpg"];
    NSString *modifiedName = [NSString stringWithFormat:@"%@_%@", self.peerID.displayName, @"kate2.jpg"];
    
    
    
    
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    double h = [object fractionCompleted] * 100;
    NSLog(@"Enviado: %g", h);
    
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
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
    
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"localURL"      :   localURL
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishReceivingResourceNotification"
                                                        object:nil
                                                      userInfo:dict];
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}


/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
                                                        object:nil
                                                      userInfo:@{@"progress": (NSProgress *)object}];
}*/

@end
