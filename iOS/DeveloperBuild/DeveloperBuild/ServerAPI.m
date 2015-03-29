//
//  ServerAPI.m
//  DeveloperBuild
//
//  Created by Jamie Frampton Miller on 3/17/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ServerAPI.h"

#define postObservationsUrl @"http://luminousid.com/_post_observation"

@implementation ServerAPI

+ (BOOL) uploadObservation:(NSString*) date time:(NSString*) time lat:(float) lat lng:(float) lng image:(UIImage*) image {
    // Get a unique identifier.
    NSString* UDID;
    if ([[UIDevice currentDevice]respondsToSelector:@selector(identifierForVendor)]) {
        // Use vendor id, IOS>=6
        UDID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }else{
        // Use UDID, IOS<5
        UDID = [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
    }
    
    // Start creating request.
    NSURL* url = [NSURL URLWithString: postObservationsUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
 
    // Arbitrary string that MUST NOT appear anywhere else in the data.
    NSString* boundary = @"------------------------c039aeafabc7a828";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
 
    // Define some fields.
    NSString* imageName = @"picture";
    NSDictionary* dictionary = @{@"Time"            : time,
                                 @"Date"            : date,
                                 @"Latitude"        : [NSString stringWithFormat:@"%f", lat],
                                 @"Longitude"       : [NSString stringWithFormat:@"%f", lng],
                                 @"DeviceId"        : UDID,
                                 @"DeviceType"      : @"iOS"};
 
    NSMutableData* postData = [NSMutableData data];
    
    // Attach image data.
    float compression = 1.0; // 100%, high quality, jpeg is always lossy but I'd like to avoid that.
    NSData* imageData = UIImageJPEGRepresentation(image, compression);
    NSString* imageDataFormat = @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n";
    [postData appendData:[[NSString stringWithFormat: imageDataFormat, boundary, imageName, @"filename.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:imageData]];
    [postData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
 
    // Attach data from dictionary.
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString* dataFormat = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
        [postData appendData:[[NSString stringWithFormat: dataFormat, boundary, key, obj] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
 
    // Add a final delimeter.
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
    // Send request.
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSError* error;
    NSURLResponse* response;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check Response
    //NSLog([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]); // Logs response.
    id JSONResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    //NSString* result = JSONResponse[@"errors"]; Not currently needed, but available.
    NSString* result = JSONResponse[@"results"];
    return [result isEqualToString:@"sent"]; // Server says "sent" when it works.
}

@end
