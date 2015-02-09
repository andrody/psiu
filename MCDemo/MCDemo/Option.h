//
//  Option.h
//  MCDemo
//
//  Created by Andrew on 12/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property NSString *nome;
@property UIColor *cor;
@property NSInteger *sacanagem;


-(Option*) setName:(NSString*)name cor:(UIColor*)cor sacanagem:(NSInteger)sacanagem;
@end
