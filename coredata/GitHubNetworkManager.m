//
//  GitHubNetworkManager.m
//  coredata
//
//  Created by Matthew Voss on 3/20/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "GitHubNetworkManager.h"

#define GITHUB_API_URL @"https://api.github.com/users/%@/repos"

@interface GitHubNetworkManager()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end


@implementation GitHubNetworkManager

-(void)downloadReposForUser:(NSString *)userName
{
    if (!self.downloadQueue) {
        self.downloadQueue = [NSOperationQueue new];
    }
    
    [self.downloadQueue addOperationWithBlock:^{
        
        NSString *searchUrlString = [NSString stringWithFormat:GITHUB_API_URL, userName];
        NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
        NSData *data = [NSData dataWithContentsOfURL:searchUrl];
        
        if (data) {
            NSError *error;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
    
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!error) {
                    [self.delegate insertDownloadedArrayToController:json];
                }
            }];
        }
    }];
    
        
        
}




@end
