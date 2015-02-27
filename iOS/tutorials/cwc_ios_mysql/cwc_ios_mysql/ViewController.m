//
//  ViewController.m
//  cwc_ios_mysql
//
//  Created by Jacob Rail on 2/2/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//



#import "ViewController.h"
#import "Location.h"

@interface ViewController ()
{
	HomeModel *_homeModel;
	NSArray *_feedItems;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Set this view controller object as the delegate and data source for the table view
	/// This will let su implement the table view delagate method further down to populate the table view w/data.
	self.listTableView.delegate = self;
	self.listTableView.dataSource = self;
	
	// Create array object and assign it to _feedItems variable
	_feedItems = [[NSArray alloc] init];
	
	// Create new HomeModel object and assign it to _homeModel variable
	_homeModel.delagate = self;
	
	// Call the download itmes method of the home hodel object
	[_homeModel downloadItems];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) itemsDownloaded:(NSArray *)items
{
	// This delegate method will get called when the items are finished downloading
	
	// Set the downloaded itmes to the array
	_feedItems = items;
	
	// Realod the table view
	[self.listTableView reloadData];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of feed itmes (initially 0)
	return _feedItems.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Retrieve cell
	NSString *cellIdentifier = @"BasicCell";
	UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	// Get the location to be shown
	Location *item = _feedItems[indexPath.row];
	
	// Get references to labels of cell
	myCell.textLabel.text = item.address;
	
	return myCell;
}
@end
