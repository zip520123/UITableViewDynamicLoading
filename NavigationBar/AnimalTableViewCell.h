//
//  AnimalTableViewCell.h
//  NavigationBar
//
//  Created by Woody on 2018/11/6.
//  Copyright © 2018年 Woody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localtionLabel;
@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;



@end
