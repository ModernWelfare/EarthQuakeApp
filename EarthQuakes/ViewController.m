//
//  ViewController.m
//  EarthQuakes
//
//  Created by Bohao Li on 2018/1/30.
//  Copyright © 2018年 Bohao Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup table view
    
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self tableView].refreshControl = refreshControl;
    
    [refreshControl addTarget:self
                       action:@selector(refreshTableViewWithSender:)
             forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)refreshTableViewWithSender: (UIRefreshControl*) sender {
    NSURLSession *session = [self makeURLSession];
    NSURL *url = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *jsonParseError;
        NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParseError];
        NSLog(@"%@", dataString);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sender endRefreshing];
        });
    }] resume];
}

- (NSURLSession*) makeURLSession {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    return defaultSession;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
