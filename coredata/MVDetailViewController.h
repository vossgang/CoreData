//
//  MVDetailViewController.h
//  coredata
//
//  Created by Matthew Voss on 3/18/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"


@interface MVDetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) Repo *detailItem;

@end
