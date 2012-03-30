//
//  AsyncImageView.h
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface AsyncImageView : UIImageView <ASIHTTPRequestDelegate>{
    
}
@property(nonatomic, retain) ASIHTTPRequest * request;

- (void) loadImage:(NSString*)imageURL;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;
- (void) cancelDownload;
@end
