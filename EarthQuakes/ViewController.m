//
//  ViewController.m
//  EarthQuakes
//
//  Created by Bohao Li on 2018/1/30.
//  Copyright © 2018年 Bohao Li. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray* tableViewData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup table view
    
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self tableView].refreshControl = refreshControl;
    
    [refreshControl addTarget:self
                       action:@selector(refreshTableViewWithSender:)
             forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - data operations

- (void)refreshTableViewWithSender: (UIRefreshControl*) sender {
    NSURLSession *session = [self makeURLSession];
    NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonParseError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParseError];
        
        NSMutableArray* titles = @[].mutableCopy;
        
        for(NSDictionary *item in json[@"features"]) {
            [titles addObject:item[@"properties"][@"title"]];
        }
        
        [self setTableViewData:titles];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
            [sender endRefreshing];
        });
    }] resume];
}

- (NSURLSession*) makeURLSession {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    return defaultSession;
}

#pragma mark - table view data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"TableViewCell"];
    [cell inflateWithTitle:[self tableViewData][[indexPath row]]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[self tableViewData] count];
}

@end
