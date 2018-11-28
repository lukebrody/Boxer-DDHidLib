//
//  HIDWatcher.m
//  Teleprompter
//
//  Created by Luke Brody on 11/27/18.
//  Copyright © 2018 Pavonine Software. All rights reserved.
//

#import "DDHidWatcher.h"

@implementation DDHidWatcher

void DeviceWasAdded( void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
    DDHidWatcher *watcher = (DDHidWatcher *)context;
    DDHidDevice *newDevice = [[DDHidDevice alloc]initWithDevice:IOHIDDeviceGetService(device) error: nil];
    
    [watcher->devices addObject:newDevice];
    [newDevice release];
    [watcher->delegate watcher:watcher addedDevice:newDevice];
}

void DeviceWasRemoved( void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
    DDHidWatcher *watcher = (DDHidWatcher *)context;
    for (int i = 0; i < [watcher->devices count]; i ++) {
        DDHidDevice *storedDevice = [watcher->devices objectAtIndex: i];
        if ([storedDevice ioDevice] == IOHIDDeviceGetService(device)) {
            [watcher->delegate watcher:watcher removedDevice: storedDevice];
            [watcher->devices removeObjectAtIndex: i];
            return;
        }
    }
}

- (id) initWithDelegate: (NSObject<DDHidWatcherDelegate> *) delegate {
    
    self = [super init];
    
    if (self) {
        self->delegate = delegate;
        
        devices = [[NSMutableArray alloc]init];
        manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDManagerOptionNone);
        IOHIDManagerSetDeviceMatching(manager, IOServiceMatching(kIOHIDDeviceKey));
        IOHIDManagerRegisterDeviceMatchingCallback(manager, DeviceWasAdded, self);
        IOHIDManagerRegisterDeviceRemovalCallback(manager, DeviceWasRemoved, self);
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    
    return self;
}

- (void)dealloc
{
    IOHIDManagerUnscheduleFromRunLoop(manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    CFRelease(manager);
    [devices release];
    [super dealloc];
}

@end
