//
//  MTMigration.m
//  Tracker
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTMigration.h"

static NSString * const MTMigrationLastVersionKey      = @"MTMigration.lastMigrationVersion";
static NSString * const MTMigrationLastAppVersionKey   = @"MTMigration.lastAppVersion";

@implementation MTMigration

+ (void) migrateToVersion:(NSString *)version block:(MTExecutionBlock)migrationBlock {
    NSString *lastVersion = self.lastMigrationVersion,
             *currentVersion = self.appVersion;
    
	// version > lastMigrationVersion && version <= appVersion
    if ([version compare:lastVersion options:NSNumericSearch]    == NSOrderedDescending &&
        [version compare:currentVersion options:NSNumericSearch] != NSOrderedDescending) {
		
        migrationBlock(lastVersion, currentVersion);
		
        [self setLastMigrationVersion:version];
	}
}


+ (void) applicationUpdateBlock:(MTExecutionBlock)updateBlock {
    NSString *lastVersion = self.lastAppVersion,
             *currentVersion = self.appVersion;
    
    if (![lastVersion isEqualToString:currentVersion]) {
        
        updateBlock(lastVersion, currentVersion);

        [self setLastAppVersion:currentVersion];
    }
}


+ (void) reset {
    [self setLastMigrationVersion:nil];
    [self setLastAppVersion:nil];
}


+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (void) setLastMigrationVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MTMigrationLastVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) lastMigrationVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastVersionKey];
    
    return (res ? res : @"");
}

+ (void)setLastAppVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MTMigrationLastAppVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) lastAppVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastAppVersionKey];
    
    return (res ? res : @"");
}

@end
