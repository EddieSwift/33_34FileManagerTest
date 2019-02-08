//
//  UIView+UITableViewCell.m
//  33_34FileManagerTest
//
//  Created by Eduard Galchenko on 2/7/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell*) superCell {
    
    if (!self.superview) {
        
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
            
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
}

@end
