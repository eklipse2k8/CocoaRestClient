//
//  CocoaRestClientAppDelegate.h
//  CocoaRestClient
//
//  Created by mmattozzi on 1/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CRCRequest;

@interface CocoaRestClientAppDelegate : NSObject {
    @private 
    __unsafe_unretained NSWindow *window;
	
	__unsafe_unretained NSComboBox *urlBox;
	__unsafe_unretained NSButton *submitButton;
	__unsafe_unretained NSTextView *requestText;
	__unsafe_unretained NSTextView *responseText;
	__unsafe_unretained NSTabViewItem *headersTab;
	__unsafe_unretained NSTextView *responseTextHeaders;
	__unsafe_unretained NSPopUpButton *methodButton;
	__unsafe_unretained NSTableView *headersTableView;
	__unsafe_unretained NSTableView *filesTableView;
	__unsafe_unretained NSTableView *paramsTableView;
	
	__unsafe_unretained NSTextField *username;
	__unsafe_unretained NSTextField *password;
	
	NSMutableData *receivedData;
	NSString *contentType;
	
	NSMutableArray *headersTable;
	NSMutableArray *filesTable;
	NSMutableArray *paramsTable;
	
	__unsafe_unretained NSDrawer *savedRequestsDrawer;
    NSMutableArray *savedRequestsArray;
	__unsafe_unretained NSOutlineView *savedOutlineView;
	
	__unsafe_unretained NSPanel *saveRequestSheet;
	__unsafe_unretained NSTextField *saveRequestTextField;
	
	__unsafe_unretained NSPanel *timeoutSheet;
	__unsafe_unretained NSTextField *timeoutField;
	
	NSInteger timeout;
    
    BOOL allowSelfSignedCerts;
    BOOL followRedirects;
	
	__unsafe_unretained NSButton *plusParam;
	__unsafe_unretained NSButton *minusParam;
	BOOL rawRequestInput;
	__unsafe_unretained NSTabView *tabView;
	__unsafe_unretained NSTabViewItem *reqHeadersTab;
	NSDate *startDate;
	__unsafe_unretained NSTextField *status;
    

    CRCRequest *lastRequest;
	
}



@property (nonatomic, readonly) NSMutableArray *headersTable;
@property (nonatomic, readonly) NSMutableArray *filesTable;
@property (nonatomic, readonly) NSMutableArray *paramsTable;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSComboBox *urlBox;
@property (assign) IBOutlet NSButton *submitButton;
@property (assign) IBOutlet NSTextView *responseText;
@property (assign) IBOutlet NSTextView *responseTextHeaders;
@property (assign) IBOutlet NSPopUpButton *methodButton;
@property (assign) IBOutlet NSTextView *requestText;
@property (assign) IBOutlet NSTableView *headersTableView;
@property (assign) IBOutlet NSTableView *filesTableView;
@property (assign) IBOutlet NSTableView *paramsTableView;
@property (assign) IBOutlet NSTextField *username;
@property (assign) IBOutlet NSTextField *password;
@property (assign) IBOutlet NSOutlineView *savedOutlineView;
@property (assign) IBOutlet NSPanel *saveRequestSheet;
@property (assign) IBOutlet NSTextField *saveRequestTextField;
@property (assign) IBOutlet NSDrawer *savedRequestsDrawer;
@property (assign) IBOutlet NSTabViewItem *headersTab;
@property (assign) IBOutlet NSPanel *timeoutSheet;
@property (assign) IBOutlet NSTextField *timeoutField;
@property (assign) IBOutlet NSButton *plusParam;
@property (assign) IBOutlet NSButton *minusParam;
@property (assign) BOOL rawRequestInput;
@property (assign) IBOutlet NSTabView *tabView;
@property (assign) IBOutlet NSTabViewItem *reqHeadersTab;
@property (assign) IBOutlet NSTextField *status;

- (IBAction) runSubmit:(id)sender;
- (IBAction) plusHeaderRow:(id)sender;
- (IBAction) minusHeaderRow:(id)sender;
- (IBAction) clearAuth:(id)sender;
- (IBAction) outlineClick:(id)sender;
- (IBAction) saveRequest:(id) sender;
- (IBAction) doneSaveRequest:(id) sender;
- (void) loadSavedRequest:(NSDictionary *) request;
- (IBAction) deleteSavedRequest:(id) sender;
- (NSString *) pathForDataFile;
- (void) loadDataFromDisk;
- (void) saveDataToDisk;
- (void) applicationWillTerminate: (NSNotification *)note;
- (IBAction) openTimeoutDialog:(id) sender;
- (IBAction) closeTimoutDialog:(id) sender;
- (IBAction) plusFileRow:(id)sender;
- (IBAction) minusFileRow:(id)sender;
- (IBAction) plusParamsRow:(id)sender;
- (IBAction) minusParamsRow:(id)sender;
- (IBAction) contentTypeMenuItemSelected:(id)sender;
- (IBAction) handleOpenWindow:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)item;
- (IBAction) helpInfo:(id)sender;
- (IBAction) licenseInfo:(id)sender;
- (IBAction) reloadLastRequest:(id)sender;
- (IBAction) allowSelfSignedCerts:(id)sender;
- (IBAction) followRedirects:(id)sender;

- (void)setRawRequestInput:(BOOL)value;

@end
