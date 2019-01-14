//
//  CapsLockController.m
//  CapsLockController
//
//  Created by John VanSickle on 1/14/19.
//  Copyright © 2019 John VanSickle. All rights reserved.
//

#import "CapsLockController.h"

@implementation CapsLockController

#define CAPSLOCK_OFF    0
#define CAPSLOCK_ON     1
#define CAPSLOCK_TOGGLE -1

- (int) setCapsLockTo:(int)onOrOff {
    kern_return_t kr = 0;
    io_service_t ios;
    io_connect_t ioc;
    CFMutableDictionaryRef mdict;
    int op;
    bool state;
    
    op = onOrOff;
    
    if (op != CAPSLOCK_ON && op != CAPSLOCK_OFF && op != CAPSLOCK_TOGGLE)
    {
        fprintf(stderr, "Usage: %s\n\t\%s\n\t%s\n\t%s\n\t%s\n",
                "[0|1|-1]",
                " 0 : capslock off",
                " 1 : capslock on",
                "-1 : toggle capslock state",
                "   : print current capslock state (0|1)"
                );
        return 1;
    }
    
    mdict = IOServiceMatching(kIOHIDSystemClass);
    ios = IOServiceGetMatchingService(kIOMasterPortDefault, (CFDictionaryRef) mdict);
    if (!ios)
    {
        if (mdict)
            CFRelease(mdict);
        fprintf(stderr, "IOServiceGetMatchingService() failed: %x\n", kr);
        return (int) kr;
    }
    
    kr = IOServiceOpen(ios, mach_task_self(), kIOHIDParamConnectType, &ioc);
    IOObjectRelease(ios);
    if (kr != KERN_SUCCESS)
    {
        fprintf(stderr, "IOServiceOpen() failed: %x\n", kr);
        return (int) kr;
    }
    
    switch (op)
    {
        case CAPSLOCK_ON:
        case CAPSLOCK_OFF:
            state = (op == CAPSLOCK_ON);
            kr = IOHIDSetModifierLockState(ioc, kIOHIDCapsLockState, state);
            if (kr != KERN_SUCCESS)
            {
                IOServiceClose(ioc);
                fprintf(stderr, "IOHIDSetModifierLockState() failed: %x\n", kr);
                return (int) kr;
            }
            break;
        case CAPSLOCK_TOGGLE:
            kr = IOHIDGetModifierLockState(ioc, kIOHIDCapsLockState, &state);
            if (kr != KERN_SUCCESS)
            {
                IOServiceClose(ioc);
                fprintf(stderr, "IOHIDGetModifierLockState() failed: %x\n", kr);
                return (int) kr;
            }
            state = !state;
            kr = IOHIDSetModifierLockState(ioc, kIOHIDCapsLockState, state);
            if (kr != KERN_SUCCESS)
            {
                IOServiceClose(ioc);
                fprintf(stderr, "IOHIDSetModifierLockState() failed: %x\n", kr);
                return (int) kr;
            }
            break;
    }
    
    IOServiceClose(ioc);
}

@end
