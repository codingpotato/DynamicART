//
//  CPApplicationController.m
//  DynamicArt
//
//  Created by wangyw on 4/23/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPApplicationController.h"

#import "CPBlockController.h"
#import "CPMailBodyParser.h"
#import "CPTrace.h"

NSString *CPApplicationControllerKeyPathBlockController = @"blockController";

@interface CPApplicationController ()

@property (strong, nonatomic) NSMutableDictionary *appIndex;

@property (strong, nonatomic) NSString *documentsPath;

@property (strong, nonatomic) NSString *appIndexPath;

@property (strong, nonatomic) CPMailBodyParser *mailBodyParser;

- (NSString *)currentAppName;

- (void)setCurrentAppName:(NSString *)currentAppName;

- (NSMutableDictionary *)apps;

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification;

- (void)loadCurrentApp;

- (void)saveCurrentAppAsName:(NSString *)appName;

- (void)copyCurrentThumbnailToApp:(NSString *)appName;

- (void)loadAppFromParser;

@end

@implementation CPApplicationController

static NSString *_keyCurrentAppName = @"CurrentAppName";

static NSString *_keyApps = @"Apps";

static NSString *_fileExtension = @"dyb";

static NSString *_thumbnailExtension = @"png";

static NSString *_thumbnailSurfix = @"_thumbnail";

#pragma mark - singleton methods

static CPApplicationController *_defaultApplicationController;
static BOOL _observerAdded = NO;

+ (CPApplicationController *)defaultController {
    if (!_defaultApplicationController) {
        _defaultApplicationController = [[CPApplicationController alloc] init];
    }
    return _defaultApplicationController;
}

+ (void)loadAppFromUrl:(NSURL *)url {
    if (_defaultApplicationController) {
        [_defaultApplicationController loadAppFromUrl:url];
    } else {
        _defaultApplicationController = [[CPApplicationController alloc] initWithUrl:url];
    }
}

+ (BOOL)observerAdded {
    return _observerAdded;
}

+ (void)setObserverAdded:(BOOL)observerAdded {
    _observerAdded = observerAdded;
}

+ (void)releaseDefaultController {
    _defaultApplicationController = nil;
}

#pragma mark - lifecycle methods

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [self loadCurrentApp];
    }
    return self;
}

- (id)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [self loadAppFromUrl:url];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.appIndex writeToFile:self.appIndexPath atomically:YES];
    [self saveCurrentApp];

    CPTrace(@"%@ dealloc", self);
}

#pragma mark - public methods

- (NSUInteger)count {
    return self.apps.count;
}

- (NSArray *)appNames {
    return [self.apps.allKeys sortedArrayUsingSelector:@selector(localizedCompare:)];
}

- (BOOL)hasApp:(NSString *)appName {
    return [self.apps objectForKey:appName] != nil;
}

- (void)saveCurrentApp {
    if (self.blockController) {
        NSString *fileName = [self.apps objectForKey:self.blockController.appName];
        NSAssert(fileName, @"");
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:_fileExtension]];
        [NSKeyedArchiver archiveRootObject:self.blockController toFile:filePath];
    }
}

- (void)createNewApp:(NSString *)appName {
    [self saveCurrentApp];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGSize blockBoardSize = screenBounds.size;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        blockBoardSize = CGSizeMake(blockBoardSize.height, blockBoardSize.width);
    }
    self.blockController = [[CPBlockController alloc] initWithBlockBoardSize:blockBoardSize];
    [self saveCurrentAppAsName:appName];
}

- (void)duplicateCurrentAppTo:(NSString *)appName {
    [self saveCurrentApp];
    [self saveCurrentAppAsName:appName];
}

- (void)loadApp:(NSString *)appName {
    NSAssert(appName && ![appName isEqualToString:@""], @"");
    
    [self saveCurrentApp];
    if (!self.blockController || ![self.blockController.appName isEqualToString:appName]) {
        NSString *fileName = [self.apps objectForKey:appName];
        NSAssert1(fileName, @"file name of %@ should not be nil", appName);
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:_fileExtension]];
        
        self.blockController = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        self.currentAppName = self.blockController.appName;
    }
}

- (void)removeApp:(NSString *)appName {
    NSAssert(appName && ![appName isEqualToString:@""], @"");
    
    NSString *fileName = [self.apps objectForKey:appName];
    NSAssert1(fileName, @"file name of %@ should not be nil", appName);
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:_fileExtension]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    
    NSString *thumbnailPath = [self.documentsPath stringByAppendingPathComponent:[[fileName stringByAppendingString:_thumbnailSurfix] stringByAppendingPathExtension:_thumbnailExtension]];
    if ([fileManager fileExistsAtPath:thumbnailPath]) {
        [fileManager removeItemAtPath:thumbnailPath error:nil];
    }
    [self.apps removeObjectForKey:appName];
    if ([appName isEqualToString:self.blockController.appName]) {
        // appIndex will be saved by currentAppName assignment
        self.currentAppName = @"";
        self.blockController = nil;
    } else {
        [self.appIndex writeToFile:self.appIndexPath atomically:YES];
    }
}

- (void)saveThumbnailForCurrentApp:(UIImage *)thumbnailImage {
    NSAssert(thumbnailImage, @"");
    NSAssert(self.blockController, @"");
    
    NSString *fileName = [self.apps objectForKey:self.blockController.appName];
    NSAssert(fileName, @"");
    
    NSString *thumbnailPath = [self.documentsPath stringByAppendingPathComponent:[[fileName stringByAppendingString:_thumbnailSurfix] stringByAppendingPathExtension:_thumbnailExtension]];
    [UIImagePNGRepresentation(thumbnailImage) writeToFile:thumbnailPath atomically:YES];
}

- (UIImage *)thumbnailOfCurrrentApp {
    if (self.blockController && self.blockController.appName && ![self.blockController.appName isEqualToString:@""]) {
        return [self thumbnailOfApp:self.blockController.appName];
    } else {
        return nil;
    }
}

- (UIImage *)thumbnailOfApp:(NSString *)appName {
    NSAssert(appName && ![appName isEqualToString:@""], @"");
    
    NSString *fileName = [self.apps objectForKey:appName];
    NSAssert(fileName, @"");

    NSString *thumbnailPath = [self.documentsPath stringByAppendingPathComponent:[[fileName stringByAppendingString:_thumbnailSurfix] stringByAppendingPathExtension:_thumbnailExtension]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:thumbnailPath]) {
        return [[UIImage alloc] initWithContentsOfFile:thumbnailPath];
    } else {
        return nil;
    }
}
    
- (void)loadAppFromUrl:(NSURL *)url {
    self.mailBodyParser = [[CPMailBodyParser alloc] initWithUrl:url];
    if (self.mailBodyParser.blockController) {
        if ([self hasApp:self.mailBodyParser.blockController.appName]) {
            NSString *message = [[NSString alloc] initWithFormat:@"Block board \"%@\" exists, override it?", self.mailBodyParser.blockController.appName];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Import block board" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Override" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self loadAppFromParser];
                self.isLoadingFromUrl = NO;
                self.mailBodyParser = nil;
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (!self.blockController) {
                    [self loadCurrentApp];
                }
                self.isLoadingFromUrl = NO;
                self.mailBodyParser = nil;
            }]];
            UIWindow* alertWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            // keep mailBodyParser object for using in alert view delegate method
            self.isLoadingFromUrl = YES;
            return;
        } else {
            [self loadAppFromParser];
        }
    }
    self.mailBodyParser = nil;
}

#pragma mark - property methods

- (NSMutableDictionary *)appIndex {
    if (!_appIndex) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.appIndexPath]) {
            _appIndex = [[NSMutableDictionary alloc] initWithContentsOfFile:self.appIndexPath];
        } else {
            _appIndex = [[NSMutableDictionary alloc] init];
            [_appIndex setObject:@"" forKey:_keyCurrentAppName];
            [_appIndex setObject:[[NSMutableDictionary alloc] init] forKey:_keyApps];
            [self.appIndex writeToFile:self.appIndexPath atomically:YES];
        }
    }
    return _appIndex;
}

- (NSString *)documentsPath {
    if (!_documentsPath) {
        _documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return _documentsPath;
}

- (NSString *)appIndexPath {
    if (!_appIndexPath) {
        _appIndexPath = [self.documentsPath stringByAppendingPathComponent:@"AppIndex.plist"];
    }
    return _appIndexPath;
}

- (NSString *)currentAppName {
    return [self.appIndex objectForKey:_keyCurrentAppName];
}

- (void)setCurrentAppName:(NSString *)currentAppName {
    NSAssert(currentAppName, @"");

    [self.appIndex setObject:currentAppName forKey:_keyCurrentAppName];
    [self.appIndex writeToFile:self.appIndexPath atomically:YES];
}

- (NSMutableDictionary *)apps {
    return [self.appIndex objectForKey:_keyApps];
}

#pragma mark - private methods

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification {
    [self.appIndex writeToFile:self.appIndexPath atomically:YES];
    [self saveCurrentApp];
    self.appIndex = nil;
    self.documentsPath = nil;
    self.appIndexPath = nil;
}

- (void)loadCurrentApp {
    if (self.currentAppName && ![self.currentAppName isEqualToString:@""]) {
        [self loadApp:self.currentAppName];
    }
}

- (void)saveCurrentAppAsName:(NSString *)appName {
    NSAssert(appName && ![appName isEqualToString:@""], @"");
    NSAssert(self.blockController, @"");
    
    NSString *fileName = [self.apps objectForKey:appName];
    if (!fileName) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        fileName = (__bridge_transfer NSString *)uuidString;
        CFRelease(uuid);
        [self.apps setObject:fileName forKey:appName];
        [self.appIndex writeToFile:self.appIndexPath atomically:YES];
    }
    [self copyCurrentThumbnailToApp:appName];
    self.blockController.appName = appName;
    self.currentAppName = appName;

    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:_fileExtension]];
    [NSKeyedArchiver archiveRootObject:self.blockController toFile:filePath];
}

- (void)copyCurrentThumbnailToApp:(NSString *)appName {
    NSAssert(appName && ![appName isEqualToString:@""], @"");
    NSAssert(self.blockController, @"");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *thumbnailPathSrc = nil;
    NSString *fileNameSrc = [self.apps objectForKey:self.blockController.appName];
    if (fileNameSrc) {
        thumbnailPathSrc = [self.documentsPath stringByAppendingPathComponent:[[fileNameSrc stringByAppendingString:_thumbnailSurfix] stringByAppendingPathExtension:_thumbnailExtension]];
        if (![fileManager fileExistsAtPath:thumbnailPathSrc]) {
            thumbnailPathSrc = nil;
        }
    }
    NSString *fileNameDest = [self.apps objectForKey:appName];
    if (fileNameDest) {
        NSString *thumbnailPathDest = [self.documentsPath stringByAppendingPathComponent:[[fileNameDest stringByAppendingString:_thumbnailSurfix] stringByAppendingPathExtension:_thumbnailExtension]];
        if ([fileManager fileExistsAtPath:thumbnailPathDest]) {
            [fileManager removeItemAtPath:thumbnailPathDest error:nil];
        }
        if (thumbnailPathSrc) {
            [fileManager copyItemAtPath:thumbnailPathSrc toPath:thumbnailPathDest error:nil];
        }
    }
}

- (void)loadAppFromParser {
    NSAssert(self.mailBodyParser, @"");

    if (self.mailBodyParser && self.mailBodyParser.blockController) {
        self.blockController = self.mailBodyParser.blockController;
        [self saveCurrentAppAsName:self.blockController.appName];
        if (self.mailBodyParser.thumbnailData) {
            UIImage *thumbnailImage = [[UIImage alloc] initWithData:self.mailBodyParser.thumbnailData];
            [self saveThumbnailForCurrentApp:thumbnailImage];
        }
    }
}

@end
