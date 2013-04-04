//
//  APIProcessingViewController.m
//  CYZSDotNetAPITester
//
//  Created by Wei Li on 04/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "APIProcessingViewController.h"
#import "CYZSDotNetAPIManager.h"
#import "RequestStatusData.h"

#define kWindowSize [[UIScreen mainScreen] bounds].size

@interface APIProcessingViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *selectorArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *resetButton;

@end

@implementation APIProcessingViewController


- (NSMutableArray *)resultArray {
    if (_resultArray == nil) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

#pragma mark - UIViewController LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kWindowSize.width, kWindowSize.height - 50 - 20)];
    self.tableView.rowHeight = 30;
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];

    self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton addTarget:self
                    action:@selector(startPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setFrame:CGRectMake(20, 10, 60, 30)];
    [self.view addSubview:self.startButton];

    self.resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.resetButton  setTitle:@"RESET" forState:UIControlStateNormal];
    [self.resetButton  addTarget:self
                   action:@selector(resetPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton  setFrame:CGRectMake(240, 10, 60, 30)];
    [self.view addSubview:self.resetButton];

    self.selectorArray = [CYZSDotNetAPIManager createAPIFunctionsArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Specified Method
- (void)startPressed:(id)sender {
    [self.startButton setEnabled:NO];
    [self.resetButton setEnabled:NO];
    self.index = 0;
    [self.resultArray removeAllObjects];
    [self doNetworkRequestWithSelectors:self.selectorArray];
}

- (void)doNetworkRequestWithSelectors:(NSArray *)selectorArray {
    if (self.index >= [selectorArray count]) {
        [self.startButton setEnabled:YES];
        [self.resetButton setEnabled:YES];
        return;
    }
    [CYZSDotNetAPIManager performSelector:[[selectorArray objectAtIndex:self.index] pointerValue] withObject:^(RequestStatusData *resultData){
        NSLog(@"time = %f", resultData.milliSeconds);
        [self.resultArray addObject:resultData];

        NSIndexPath* index = [NSIndexPath indexPathForRow:self.resultArray.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        self.index ++;
        [self doNetworkRequestWithSelectors:selectorArray];

    }];
}

- (void)resetPressed:(id)sender {
    [self.resultArray removeAllObjects];
    self.index = 0;
    [self.tableView reloadData];
}


#pragma mark - Network request and process


#pragma mark - Delegate and DataSource
#pragma mark -- UITableView delegate and Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell.textLabel setFont:[UIFont systemFontOfSize:11]];
    }

    RequestStatusData *singleData =  (RequestStatusData *) [self.resultArray objectAtIndex:(NSUInteger) indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", singleData.requestMethod, (int) singleData.milliSeconds];

    if (singleData.milliSeconds > 1000) {
        [cell.textLabel setTextColor:[UIColor redColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    if (singleData.resultId == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        [cell.textLabel setTextColor:[UIColor redColor]];
    }


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Test Results";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.resultArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RequestStatusData *singleData =  (RequestStatusData *) [self.resultArray objectAtIndex:(NSUInteger) indexPath.row];

    if ([singleData.errorMessage length] != 0) {
        UIAlertView *alert =   [[UIAlertView alloc] initWithTitle:@"错误信息"
                                                          message:[NSString stringWithFormat:@"Code: %d  %@", singleData.resultId, singleData.errorMessage]
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [alert show];
    }
}



@end
