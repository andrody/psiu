//
//  TesteViewController.h
//  MCDemo
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface TesteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table_dispositivos;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@end
