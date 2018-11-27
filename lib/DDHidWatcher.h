//
//  DDHidWatcher.h
//  Teleprompter
//
//  Created by Luke Brody on 11/27/18.
//  Copyright © 2018 Pavonine Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDHidDevice.h"
#import <IOKit/hid/IOHIDManager.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHidWatcher;

@protocol DDHidWatcherDelegate <NSObject>

// Called initially for all existing devices
- (void) watcher: (DDHidWatcher *) watcher addedDevice: (DDHidDevice *) device;
- (void) watcher: (DDHidWatcher *) watcher removedDevice: (DDHidDevice *) device;

@end

@interface DDHidWatcher : NSObject {
    IOHIDManagerRef manager;
    NSMutableArray<DDHidDevice*> *devices;
    NSObject<DDHidWatcherDelegate> *delegate;
}

- (id) initWithDelegate: (NSObject<DDHidWatcherDelegate> *) delegate;

@end

NS_ASSUME_NONNULL_END
