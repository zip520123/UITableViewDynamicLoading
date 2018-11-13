//
//  ViewController.m
//  NavigationBar
//
//  Created by Woody on 2018/11/6.
//  Copyright © 2018年 Woody. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AnimalTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UITableViewDelegate , UITableViewDataSource >

@end

@implementation ViewController {
    UILabel *titleLabel;
    UIView *navBarView;
    CGFloat headerViewOriginalHeight ;
    CGFloat lastVerticalOffset ;
}

@synthesize tableView;
@synthesize tableData;
@synthesize customNavigationBar;
@synthesize verticalSpaceConstraint;
@synthesize headerView;
NSInteger dataIndex ;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData:0];
    titleLabel = UILabel.new;
    dataIndex = 0;
    headerViewOriginalHeight = 0;
    lastVerticalOffset = 0;
    
    [customNavigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    [customNavigationBar setShadowImage:UIImage.new];
    [customNavigationBar setTranslucent:true];
    [customNavigationBar setTintColor:[UIColor blueColor]];
    
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@""];
    [titleLabel setText:@"台幣帳戶 ＄5,701,657"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    
    navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, customNavigationBar.frame.size.width, customNavigationBar.frame.size.height)];

    [navBarView addSubview:titleLabel];
    [titleLabel setCenter:navBarView.center];
    
    [item setTitleView:navBarView];
    [customNavigationBar setItems:nil];
    [customNavigationBar pushNavigationItem:item animated:true];
    
    headerViewOriginalHeight = headerView.frame.size.height;
    [tableView setContentInset:UIEdgeInsetsMake(headerViewOriginalHeight, 0, 0, 0)];
    [tableView setScrollIndicatorInsets:tableView.contentInset];
    lastVerticalOffset = tableView.contentOffset.y;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [navBarView setAlpha:0];
    [headerView setAlpha:1];
}
- (void)loadData :(NSInteger )index {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613&limit=30&offset=%ld",index * 30];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
	
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * uploadProgress) {

    } downloadProgress:^(NSProgress * downloadProgress) {

    } completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSDictionary *jsonDict = (NSDictionary *)responseObject;
            NSDictionary *result = [jsonDict objectForKey:@"result"];
            NSMutableArray *results = [result objectForKey:@"results"];
            
            NSLog(@"%@" , results[0]);
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof (weakself) self = weakself;
                if (!self){ return; }
                if (dataIndex == 0) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:results];;
                    self.tableData = array;
                }else {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tableData];
                    [array addObjectsFromArray:results];
                    self.tableData = array;
                }
                [self.tableView reloadData];
            });
        }
    }];
    [dataTask resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    AnimalTableViewCell *cell = (AnimalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if ( cell == nil ) {
        cell = [[AnimalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }

    cell.nameLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Name_Ch"];
    cell.localtionLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Location"];
    if ([[[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Behavior"] isEqualToString:@""]){
    	cell.behaviorLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Interpretation"];
    }else{
        cell.behaviorLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Behavior"];
    }
    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[[tableData objectAtIndex:indexPath.row] objectForKey:@"A_Pic01_URL"]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( indexPath.row == tableData.count - 1 ){
        dataIndex += 1;
        [self loadData:dataIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat verticalOffset = scrollView.contentOffset.y;
    CGFloat scrollAmout = verticalOffset - lastVerticalOffset;
    lastVerticalOffset = verticalOffset;
    CGFloat alphaVariation = scrollAmout / (headerViewOriginalHeight / 2);
    CGFloat newConstant = -verticalOffset;
    if (newConstant <= 0) {
        newConstant = 1;
        [navBarView setAlpha:1];
    }else if (newConstant>=1 && newConstant<headerViewOriginalHeight/2){
        [headerView setAlpha:0];
        [navBarView setAlpha:navBarView.alpha + alphaVariation ];
    }else if (newConstant>= headerViewOriginalHeight/2 && newConstant < headerViewOriginalHeight){
        [navBarView setAlpha:0];
        [headerView setAlpha:headerView.alpha - alphaVariation ];
    }else if (newConstant > headerViewOriginalHeight){
        newConstant = headerViewOriginalHeight;
        [headerView setAlpha:1];
    }
    [verticalSpaceConstraint setConstant:newConstant];

}

@end
