//
//  Usuario.h
//  MCDemo
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface Usuario : NSObject

@property UIImage *imagem;
@property NSURL *image_url;
@property MCPeerID *peer;
@property NSString *nome;
@property NSString *idade;
@property NSInteger psiu;
@property NSInteger sacanagem;
@property BOOL match;
@property BOOL sacanagem_ja_escolhida;


@end
