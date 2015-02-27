//
//  HomeModel.m
//  cwc_ios_mysql
//
//  Created by Jacob Rail on 2/2/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "HomeModel.h"
#import "Location.h"

@interface HomeModel()
{
	NSMutableData *_downloadedData;
}
@end

@implementation HomeModel
/*
 The PHP service should return results as JSON. Here we can
 parse those itmes in the "downloadItmes" method
 */
- (void) downloadItems
{
	// Download the json file
	NSURL *jsonFileUrl = [NSURL URLWithString:@"http://flowerid.cheetahjokes.com/cgi-bin/hello.py"]; /// Need to add in the path to the service.php file here!
	
	// Create the request
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
	
	// Create the NSURLConnection
	[NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// Initialize the data object
	_downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// Append the newly downloaded data
	[_downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Create an array to store the locations
	NSMutableArray *_locations = [[NSMutableArray alloc] init];
	
	// Parse the JSON that came in
	NSError *error;
	NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData
														 options:NSJSONReadingAllowFragments
														   error:&error];
	
	// Loop through Json objects, create question objects and add them to our questions array
	for (int i = 0; i < jsonArray.count; ++i){
		NSDictionary *jsonElement = jsonArray[i];
		
		// Create a new location object and set its props to JsonElement properties
		Location *newLocation = [[Location alloc] init];
		newLocation.name = jsonElement[@"Name"];
		newLocation.address = jsonElement[@"Address"];
		newLocation.latitude = jsonElement[@"Latitude"];
		newLocation.longitude = jsonElement[@"Longitude"];
		
		// Add this question to the locations array
		[_locations addObject:newLocation];
	}
	
	// Ready to notify delegate that data is ready and pass back itmes
	if(self.delagate){
		[self.delagate itemsDownloaded:_locations];
	}
}

@end
