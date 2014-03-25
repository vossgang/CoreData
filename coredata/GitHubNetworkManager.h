//
//  GitHubNetworkManager.h
//  coredata
//
//  Created by Matthew Voss on 3/20/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@protocol gitHubNetworkManagerDelegate

-(void)insertDownloadedArrayToController:(NSArray *)json;

@end


@interface GitHubNetworkManager : NSObject

@property (unsafe_unretained) id <gitHubNetworkManagerDelegate> delegate;

-(void)downloadReposForUser:(NSString *)user;

@end
