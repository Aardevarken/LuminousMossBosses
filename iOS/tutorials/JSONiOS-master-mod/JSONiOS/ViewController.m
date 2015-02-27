//
//  ViewController.m
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

//#define getDataURL @"http://flowerid.cheetahjokes.com/cgi-bin/imagedata.py?imageid=149"
#define getDataURL @"http://flowerid.cheetahjokes.com/cgi-bin/observations.py"
//#define getDataURL @"http://www.conkave.com/iosdemos/json.php"
#define MAX_NUMB_DISPLAYED 10

@implementation ViewController
@synthesize json, citiesArray, myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set the title
    self.title = @"Cities of the World";
    
    [self retrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return citiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    //Retrieve the current city object for use with this indexPath.row
    City * currentCity = [citiesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentCity.cityName;
    cell.detailTextLabel.text = currentCity.cityCountry;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * dvc = [[DetailViewController alloc]init];
    
    //Retrieve the current selected city
    City * currentCity = [citiesArray objectAtIndex:indexPath.row];
    dvc.name = currentCity.cityName;
    dvc.population = currentCity.cityPopulation;
    dvc.country = currentCity.cityCountry;
    
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark - Methods
- (void) retrieveData
{
    NSURL * url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    
    //Set up our cities array
    citiesArray = [[NSMutableArray alloc]init];
	//unsigned long jc = json.count;
	for (int i = 0;i < json.count && i < MAX_NUMB_DISPLAYED; i++)
    {
		NSLog(@"#%d: %@",i, [json objectAtIndex:i]);
		
		//Create city object
        NSString * cID = [NSString stringWithFormat:@"%@", [[json objectAtIndex:i] objectForKey:@"ObjectID"]];

		NSString * cName = [[json objectAtIndex:i] objectForKey:@"FileName"];
		//		NSString * cName = [[json objectAtIndex:i] objectForKey:@"cityName"];
		NSString * cState = [[json objectAtIndex:i] objectForKey:@""];
		//NSString * cState = [[json objectAtIndex:i] objectForKey:@"cityState"];
		NSString * cPopulation = [NSString stringWithFormat:@"%@", [[json objectAtIndex:i] objectForKey:@"ImageID"]];

		//NSNumber * cCountry = [[json objectAtIndex:i] objectForKey:@"ParentImageID"];
		
		//NSString * cCountry = [NSString stringWithFormat:@"%@", [[json objectAtIndex:i] objectForKey:@"ParentImageID"]];
		NSString * cCountry = [[json objectAtIndex:i] objectForKey:@"Location"];
		
        City * myCity = [[City alloc]initWithCityID:cID andCityName:cName andCityState:cState andCityPopulation:cPopulation andCityCountry:cCountry];
        
        //Add our city object to our cities array
        [citiesArray addObject:myCity];
    }
    
    
    [self.myTableView reloadData];
}

@end
