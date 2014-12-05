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

@interface MCManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property Usuario *myUser;
@property NSMutableArray *usuarios;


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void) sendFoto:(MCPeerID *)peerID;

@end
