//
//  ViewController.h
//  PsiuProvaDeConceito
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 Bepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface UsersViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collection_dispositivos;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@end
