//
//  FullyLoaded.m
//  FullyLoaded
//
//  Created by Anoop Ranganath on 1/1/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "FullyLoaded.h"
#import "SynthesizeSingleton.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#define MAXIMUM_CACHED_ITEMS 100

@interface FullyLoaded()

@property (atomic, retain) NSMutableDictionary *imageCache;

@end

@implementation FullyLoaded

SYNTHESIZE_SINGLETON_FOR_CLASS(FullyLoaded);

@synthesize imageCache = _imageCache;


- (void)dealloc {
	self.imageCache = nil;
	[super dealloc];
}

- (id)init {
    self = [super init];
	if (self) {
		self.imageCache = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)emptyCache {
	NSLog(@"Emptying Cache");
	[self.imageCache removeAllObjects];
}

- (void) removeAllCacheDownloads {
    NSLog(@"deleting all cache downloads");
    NSString * cacheFolderPath = [[self pathForImageURL:@"http://a.cn/b.jpg"] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] removeItemAtPath:cacheFolderPath error:nil];
}

- (UIImage*) imageForURL:(NSString*)imageURL {
    if (imageURL.length == 0) return nil;
    
    UIImage *image = nil;
    if ((image = [self.imageCache objectForKey:imageURL])) {
        return image;
    } else if ((image = [UIImage imageWithContentsOfFile:[self pathForImageURL:imageURL]])) {
        if ([self.imageCache count] > MAXIMUM_CACHED_ITEMS) 
            [self emptyCache];
        [self.imageCache setObject:image forKey:imageURL];
        return image;
    }
    return nil;
}

- (NSString*) pathForImageURL:(NSString*)imageURL {
    if ([imageURL hasPrefix:@"http://"] || [imageURL hasPrefix:@"https://"] || [imageURL hasPrefix:@"ftp://"])
        return [[self class] tmpFilePathForResourceAtURL:imageURL];
    return imageURL;
}

/////////////////////////////////////////////////
// storage related

+ (BOOL) fileExistsForResourceAtURL:(NSString*)url {
    NSString * localFile = [self filePathForResourceAtURL:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:localFile];
}

+ (BOOL) tmpFileExistsForResourceAtURL:(NSString*)url 
{
    NSString * localFile = [self tmpFilePathForResourceAtURL:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:localFile];
}

+ (NSString*) filePathForStorage {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return  path;
}

+ (NSString*) filePathForTemporaryStorage {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return  path;
}

+ (NSString*) fileNameForResourceAtURL:(NSString*)url {
    NSString * fileName = url;
    if ([url hasPrefix:@"http://"]) fileName = [url substringFromIndex:[@"http://" length]];
    else if ([url hasPrefix:@"https://"]) fileName = [url substringFromIndex:[@"https://" length]];
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"__"];
    return fileName;
}

+ (NSString*) filePathForResourceAtURL:(NSString*)url {
    NSString * fileName = [self fileNameForResourceAtURL:url];
    NSString * path = [self filePathForStorage];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString*) tmpFilePathForResourceAtURL:(NSString*)url {
    NSString * fileName = [self fileNameForResourceAtURL:url];
    NSString * path = [self filePathForTemporaryStorage];
    return [path stringByAppendingPathComponent:fileName];
}

@end
