//
//  DemoAppDelegate.h
//  TableViewBreakDemo
//
//  Created by Geoff Harrison on 8/21/13.
//  Copyright (c) 2013 Geoff Harrison. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DemoAppDelegate : NSObject <NSApplicationDelegate> {
    NSOperationQueue *refreshQueue;
}

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTableView *demoTable;

- (IBAction)exitApplication:(id)sender;

@end
