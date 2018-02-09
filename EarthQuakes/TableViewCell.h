//
//  TableViewCell.h
//  EarthQuakes
//
//  Created by Bohao Li on 2/8/18.
//  Copyright © 2018 Bohao Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UILabel *textLabel;

- (void) inflateWithTitle:(NSString*) title;

@end
