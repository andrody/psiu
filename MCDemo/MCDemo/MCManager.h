//
//  MCManager.h
//  MCDemo
//
//  Created by Gabriel Theodoropoulos on 1/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Usuario.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    Psiu,
    Match,
} MessageType;

@interface MCManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property Usuario *myUser;
@property (nonatomic, strong) NSMutableArray *usuarios;
@property (nonatomic, strong) NSMutableArray *usuarios_psiu;
@property (nonatomic, strong) AVAudioPlayer *theAudio;


@property Usuario *usuario_selecionado;




-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void) sendFoto:(MCPeerID *)peerID;
-(void)sendUserInfo:(MCPeerID *)peerID;
-(void)sendMessage:(MCPeerID *)peerID withDict:(NSDictionary *)dict;
-(void) playPsiu;

@end
