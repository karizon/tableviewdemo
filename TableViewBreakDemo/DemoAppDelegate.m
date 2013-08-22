//
//  DemoAppDelegate.m
//  TableViewBreakDemo
//
//  Created by Geoff Harrison on 8/21/13.
//  Copyright (c) 2013 Geoff Harrison. All rights reserved.
//

// Apparently this bug is fixable.  thanks to corbin_dunn for the fix

#import "DemoAppDelegate.h"

@implementation DemoAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Seed the random number generator for later
    srandom((uint)time(NULL));
    // Create our refresh Queue
    @synchronized(refreshQueue) {
        refreshQueue = [[NSOperationQueue alloc] init];
    }
    NSLog(@"Application Loaded Successfully, starting first Operation");
    @synchronized(refreshQueue) {
        __block NSOperation *new_operation = [self generateRefreshOperation];
        [refreshQueue addOperation:new_operation];
    }
}

- (IBAction)exitApplication:(id)sender {
    NSLog(@"Exiting Gracefully");
    exit(0);
}

#pragma mark NSOperation Generation

- (NSBlockOperation *) generateRefreshOperation {
    __block NSBlockOperation *refreshBlock = [NSBlockOperation blockOperationWithBlock:^ {
        if(![refreshBlock isCancelled]) {
            usleep(250000);
            NSLog(@"Reload Data Event triggered");
            @synchronized(_demoTable) {
                [_demoTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            @synchronized(refreshQueue) {
                __block NSOperation *new_operation = [self generateRefreshOperation];
                [refreshQueue addOperation:new_operation];
            }
        }
    }];
    
    return refreshBlock;
}


#pragma mark TableView Delegation

- (NSInteger) numberOfRowsInTableView: (NSTableView *) tv {

    // We'll return a random number of rows in this view so that it becomes obvious visually
    // when the number of elements should be changing - will return a number between 1 - 10
    
    NSLog(@"Returning Random Number of Table View Rows");
    return (int) (random() % 10) + 1;
    
}

- (id) tableView: (NSTableView *) tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSLog(@"Returning a random value for tableView Entry");
    return [NSString stringWithFormat:@"%d",(int) (random() % 10)];
}

@end
