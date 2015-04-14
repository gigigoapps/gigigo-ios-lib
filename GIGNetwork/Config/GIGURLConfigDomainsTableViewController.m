//
//  GIGURLConfigDomainsTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigDomainsTableViewController.h"

#import "GIGURLManager.h"
#import "GIGURLConfigAddDomainViewController.h"


@interface GIGURLConfigDomainsTableViewController ()

@property (strong, nonatomic) GIGURLManager *manager;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@property (strong, nonatomic) NSArray *domains;

@end


@implementation GIGURLConfigDomainsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Domains";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapAddButton)];
    
    self.manager = [GIGURLManager sharedManager];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    self.domains = self.manager.domains;
    
    [self.notificationCenter addObserver:self selector:@selector(domainsDidChangeNotification:) name:GIGURLManagerDidChangeDomainNotification object:nil];
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - ACTIONS

- (void)tapAddButton
{
    GIGURLConfigAddDomainViewController *addDomain = [[GIGURLConfigAddDomainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addDomain];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - NOTIFICATIONS

- (void)domainsDidChangeNotification:(NSNotification *)notification
{
    self.domains = self.manager.domains;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.domains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"domain_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    GIGURLDomain *domain = self.domains[indexPath.row];
    cell.textLabel.text = domain.name;
    cell.detailTextLabel.text = domain.url;
    
    cell.accessoryType = ([domain isEqualToDomain:self.manager.domain]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.manager.domain = self.domains[indexPath.row];
    
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    GIGURLDomain *domain = self.domains[indexPath.row];
    
    return ![domain isEqualToDomain:self.manager.domain];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GIGURLDomain *domain = self.domains[indexPath.row];
    [self.manager removeDomain:domain];
}

@end
