//
//  Option.m
//  MCDemo
//
//  Created by Andrew on 12/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "Option.h"

@implementation Option

-(Option*) setName:(NSString*)name cor:(UIColor*)cor sacanagem:(NSInteger)sacanagem {
    
    self.nome = name;
    self.cor = cor;
    self.sacanagem = &(sacanagem);
    return self;
}

@end
