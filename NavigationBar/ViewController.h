//
//  ViewController.h
//  NavigationBar
//
//  Created by Woody on 2018/11/6.
//  Copyright © 2018年 Woody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint;

@property (weak, nonatomic) IBOutlet UINavigationBar *customNavigationBar;


@property (nonatomic, strong) NSMutableArray *tableData;


@end

