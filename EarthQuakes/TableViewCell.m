//
//  TableViewCell.m
//  EarthQuakes
//
//  Created by Bohao Li on 2/8/18.
//  Copyright © 2018 Bohao Li. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)inflateWithTitle:(NSString *)title {
    [[self textLabel] setText:title];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
