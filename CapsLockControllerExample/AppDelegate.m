//
//  AppDelegate.m
//  CapsLockControllerExample
//
//  Created by John VanSickle on 1/14/19.
//  Copyright © 2019 John VanSickle. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

CapsLockController *capsLockController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    capsLockController = [[CapsLockController alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)turnCapsOn:(id)sender {
    [capsLockController setCapsLockTo:1];
}

- (IBAction)turnCapsOff:(id)sender {
    [capsLockController setCapsLockTo:0];
}

@end
