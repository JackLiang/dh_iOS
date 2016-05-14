//
//  SUITableView.m
//  syshop
//
//  Created by Gordon Su on 16/4/21.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import "SUITableView.h"

@interface UITableView ()

- (BOOL)allowsHeaderViewsToFloat;
- (BOOL)allowsFooterViewsToFloat;

@end

@implementation SUITableView

- (BOOL)allowsHeaderViewsToFloat
{
    if (_disableFloatingSectionHeader) {
        return NO;
    }
    return [super allowsHeaderViewsToFloat];
}

- (BOOL)allowsFooterViewsToFloat
{
    if (_disableFloatingSectionFooter) {
        return NO;
    }
    return [super allowsFooterViewsToFloat];
}

@end
