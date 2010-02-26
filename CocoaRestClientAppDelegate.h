//
//  CocoaRestClientAppDelegate.h
//  CocoaRestClient
//
//  Created by mmattozzi on 1/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CocoaRestClientAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
    NSWindow *window;
	
	NSComboBox *urlBox;
	NSButton *submitButton;
	NSTextView *requestText;
	NSTextView *responseText;
	NSTextView *responseTextHeaders;
	NSPopUpButton *methodButton;
	NSTableView *headersTableView;
	
	NSTextField *username;
	NSTextField *password;
	
	NSMutableData *receivedData;
	NSString *contentType;
	
	NSMutableArray *headersTable;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSComboBox *urlBox;
@property (assign) IBOutlet NSButton *submitButton;
@property (assign) IBOutlet NSTextView *responseText;
@property (assign) IBOutlet NSTextView *responseTextHeaders;
@property (assign) IBOutlet NSPopUpButton *methodButton;
@property (assign) IBOutlet NSTextView *requestText;
@property (assign) IBOutlet NSTableView *headersTableView;
@property (assign) IBOutlet NSTextField *username;
@property (assign) IBOutlet NSTextField *password;

- (IBAction) runSubmit:(id)sender;
- (IBAction) plusHeaderRow:(id)sender;
- (IBAction) clearAuth:(id)sender;

@end
