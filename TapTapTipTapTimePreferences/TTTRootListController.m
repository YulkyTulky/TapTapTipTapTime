#include "TTTRootListController.h"

@implementation TTTRootListController

- (NSArray *)specifiers {

	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;

}

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier properties][@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[[specifier properties][@"key"]]) ?: [specifier properties][@"default"];

}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier properties][@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:[specifier properties][@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)[specifier properties][@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}

}

- (void)viewDidLoad {

    [super viewDidLoad];

	[self respringApply];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

	[[[[self navigationController] navigationController] navigationBar] setTintColor:[UIColor colorWithRed: 0.74 green: 0.17 blue: 0.13 alpha: 1.00]];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [UIView animateWithDuration:INFINITY animations:^{
        [[[[self navigationController] navigationController] navigationBar] setTintColor:nil];
    }];

}  

- (void)respringApply {

	_respringApplyButton = (_respringApplyButton) ? _respringApplyButton : [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
	[[self navigationItem] setRightBarButtonItem:_respringApplyButton animated:YES];

}

- (void)respringConfirm {

	if ([[[self navigationItem] rightBarButtonItem] isEqual:_respringConfirmButton]) {

		[self respring];

	} else {

		_respringConfirmButton = (_respringConfirmButton) ? _respringConfirmButton : [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respringConfirm)];
		[_respringConfirmButton setTintColor:[UIColor colorWithRed: 1.00 green: 0.27 blue: 0.27 alpha: 1.00]];
		[[self navigationItem] setRightBarButtonItem:_respringConfirmButton animated:YES];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self respringApply];
		});

	}

}

- (void)respring {

    NSTask *killallBackboardd = [NSTask new];
    [killallBackboardd setLaunchPath:@"/usr/bin/killall"];
    [killallBackboardd setArguments:@[@"-9", @"backboardd"]];
    [killallBackboardd launch];

}

- (void)github {
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/YulkyTulky/TapTapTipTapTime"] options:@{} completionHandler:nil];

}

- (void)discord {
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/gbzhzV"] options:@{} completionHandler:nil];

}

@end