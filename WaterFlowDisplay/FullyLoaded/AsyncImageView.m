//
//  AsyncImageView.m
//  AirMedia
//
//  Created by Xingzhi Cheng on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "FullyLoaded.h"

@interface AsyncImageView ()
- (void) downloadImage:(NSString*)imageURL;
@end

@implementation AsyncImageView
@synthesize request = _request;

- (void) dealloc {
	self.request.delegate = nil;
    [self cancelDownload];
    [super dealloc];
}

- (void) loadImage:(NSString*)imageURL {
    [self loadImage:imageURL withPlaceholdImage:nil];
}

- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage {
    self.image = placeholdImage;
    
    /*
    UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
    if (image) 
        self.image = image;
    else
        [self downloadImage:imageURL];
     */

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image) 
                self.image = image;
            else
                [self downloadImage:imageURL];
        });
    });

}

- (void) cancelDownload {
    [self.request cancel];
    self.request = nil;
}

#pragma mark - 
#pragma mark private downloads

- (void) downloadImage:(NSString *)imageURL {
    [self cancelDownload];
	NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newImageURL]];
    [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
    [self.request setDelegate:self];
    [self.request setCompletionBlock:^(void){
         self.request.delegate = nil;
         
         NSLog(@"async image download done");
         
         NSString * imageURL = [[self.request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.request = nil;
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
         dispatch_async(queue, ^{
            UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = image;
            });
    });}];
    [self.request setFailedBlock:^(void){
        [self.request cancel];
        self.request.delegate = nil;
        self.request = nil;
        
        NSLog(@"async image download failed");
     }];
    [self.request startAsynchronous];
//	NSLog(@"download Image %@", imageURL);
}

/*
- (void) requestFinished:(ASIHTTPRequest *)request 
{
    self.request.delegate = nil;
    self.request = nil;
	
	NSLog(@"async image download done");

    NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = image;
        });
    });
    
    
//    NSString * imageURL = [[request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    UIImage * image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
//    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
 
}


- (void) requestFailed:(ASIHTTPRequest *)request 
{ 
    [self.request cancel];
    self.request.delegate = nil;
    self.request = nil;
	
	NSLog(@"async image download failed");
}
 */

@end
