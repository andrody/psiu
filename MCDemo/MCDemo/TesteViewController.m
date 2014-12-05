//
//  TesteViewController.m
//  MCDemo
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "TesteViewController.h"
#import "AppDelegate.h"

@interface TesteViewController ()

@property (nonatomic, strong) NSMutableArray *dipositivos;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation TesteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dipositivos = [[NSMutableArray alloc] init];
    [_table_dispositivos setDelegate:self];
    [_table_dispositivos setDataSource:self];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[[_appDelegate mcManager].session setDelegate:self];
    
    _browser = [[MCNearbyServiceBrowser alloc]initWithPeer:[_appDelegate mcManager].peerID  serviceType:@"chat-files"];
    [_browser setDelegate:self];
    [_browser startBrowsingForPeers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"pedeu o canecao");
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    [_dipositivos addObject:info[@"isaac"]];
    [_table_dispositivos reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dipositivos count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_dipositivos objectAtIndex:indexPath.row];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
