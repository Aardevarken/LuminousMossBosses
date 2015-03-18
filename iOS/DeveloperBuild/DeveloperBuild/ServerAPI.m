//
//  ServerAPI.m
//  DeveloperBuild
//
//  Created by Jamie Frampton Miller on 3/17/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ServerAPI.h"

#define postObservationsUrl @"http://luminousid.com:5003/_post_observation"

@implementation ServerAPI

/*+ (BOOL) uploadObservation:(NSString*) date time:(NSString*) time lat:(float) lat lng:(float) lng image:(UIImage*) image{
    NSURL* url = [NSURL URLWithString: postObservationsUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dictionary = @{@"Latitude"        : [NSString stringWithFormat:@"%f", lat],
                                 @"Longitude"       : [NSString stringWithFormat:@"%f", lng],
                                 @"Date"            : date,
                                 @"Time"            : time,
                                 @"DeviceID"        : @"UDID goes here",
                                 @"DeviceType"      : @"iOS"};
    //"picture"
    // Convert dictionary to sendable string.
    NSMutableArray *postArray = [NSMutableArray array];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [postArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    NSString *post = [postArray componentsJoinedByString:@"&"];
    
    // Attach string and set headers.
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString* boundary = @"------------4fb8a7e2470d515833b9ba63ae8b47cb1------------"; // Arbitrary string that MUST NOT appear anywhere else in the data.
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    float compression = 0.8; // 80%, jpeg is always lossy.
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    NSError* error;
    NSURLResponse* response;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(newStr);
    //NSMutableArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return TRUE;
}*/

+ (BOOL) uploadObservation:(NSString*) date time:(NSString*) time lat:(float) lat lng:(float) lng image:(UIImage*) image {
 NSURL* url = [NSURL URLWithString: postObservationsUrl];
 NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
 [request setHTTPMethod:@"POST"];
 
 // Arbitrary string that MUST NOT appear anywhere else in the data.
 NSString* boundary = @"------------4fb8a7e2470d515833b9ba63ae8b47cb1------------";
 [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
 
 // Define some fields.
 NSString* imageName = @"picture";
 NSDictionary* dictionary = @{@"Latitude"        : [NSString stringWithFormat:@"%f", lat],
 @"Longitude"       : [NSString stringWithFormat:@"%f", lng],
 @"Date"            : date,
 @"Time"            : time,
 @"DeviceID"        : @"UDID goes here",
 @"DeviceType"      : @"iOS"};
 
 NSMutableData* postData = [NSMutableData data];
 
 // Attach data from dictionary.
 [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
 NSString* dataFormat = @"\r\n%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
 [postData appendData:[[NSString stringWithFormat: dataFormat, boundary, key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
 }];
 
 // Attach image data.
 float compression = 0.8; // 80%, jpeg is always lossy.
 NSData* imageData = UIImageJPEGRepresentation(image, compression);
 NSString* imageDataFormat = @"\r\n%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n";
 [postData appendData:[[NSString stringWithFormat: imageDataFormat, boundary, imageName, @"filename.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
 [postData appendData:[NSData dataWithData:imageData]];
 
 // Add a final delimeter.
 [postData appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 // Send request.
 NSLog([[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
 [request setHTTPBody:postData];
 NSError* error;
 NSURLResponse* response;
 NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 NSLog([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
 //NSMutableArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
 
 return TRUE;
 
 //= [post dataUsingEncoding:NSASCIIStringEncoding];
 //NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
 //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 }//*/

@end
