//
//  CocoaRestClientAppDelegate.m
//  CocoaRestClient
//
//  Created by mmattozzi on 1/5/10.
//

#import "CocoaRestClientAppDelegate.h"

#import <Foundation/Foundation.h>
#import "JSON.h"

@implementation CocoaRestClientAppDelegate

@synthesize window;
@synthesize submitButton;
@synthesize urlBox;
@synthesize responseText;
@synthesize responseTextHeaders;
@synthesize requestText;
@synthesize methodButton;
@synthesize headersTableView;
@synthesize username;
@synthesize password;

- (id) init {
	self = [super init];
	
	headersTable = [[NSMutableArray alloc] init];
	NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
	[row setObject:@"text/plain" forKey:@"header-value"];
	[row setObject:@"Content-Type" forKey:@"header-name"];
	[headersTable addObject:row];
	
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	[methodButton removeAllItems];
	[methodButton addItemWithTitle:@"GET"];
	[methodButton addItemWithTitle:@"POST"];
	[methodButton addItemWithTitle:@"PUT"];
	[methodButton addItemWithTitle:@"DELETE"];
	[methodButton addItemWithTitle:@"HEAD"];
	[[responseText textStorage] setFont:[NSFont fontWithName:@"Courier New" size:14]];
	[[requestText textStorage] setFont:[NSFont fontWithName:@"Courier New" size:14]];
	[urlBox setNumberOfVisibleItems:10];
}

- (IBAction) runSubmit:(id)sender {
	NSLog(@"Got submit press");
	// NSAlert *alert = [NSAlert new];
	// [alert setMessageText:@"Clicked submit"];
	// [alert setInformativeText: [urlBox stringValue]];
	// [alert runModal];
	
	[responseText setString: [urlBox stringValue]];
	[urlBox insertItemWithObjectValue: [urlBox stringValue] atIndex:0];
	
	if (! receivedData) {
		receivedData = [[NSMutableData alloc] init];
	}
	[receivedData setLength:0];
	contentType = NULL;
	
	NSURL *url = [NSURL URLWithString:[urlBox stringValue]];
	NSString *method = [NSString stringWithString:[methodButton titleOfSelectedItem]];
	NSData *body = NULL;
	if ([method isEqualToString:@"PUT"] || [method isEqualToString:@"POST"]) {
		body = [[requestText string] dataUsingEncoding:NSUTF8StringEncoding];
	}
	
	NSMutableDictionary *headersDictionary = [[NSMutableDictionary alloc] init];
	for (int i = 0; i < [headersTable count]; i++) {
		[headersDictionary setObject:[[headersTable objectAtIndex:i] objectForKey:@"header-value"] 
							  forKey:[[headersTable objectAtIndex:i] objectForKey:@"header-name"]];
		NSLog(@"%@ = %@", [[headersTable objectAtIndex:i] objectForKey:@"header-name"], [[headersTable objectAtIndex:i] objectForKey:@"header-value"]);
	}
	
	NSLog(@"Building req");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSLog(@"Sending method %@", method);
	[request setHTTPMethod:method];
	[request setAllHTTPHeaderFields:headersDictionary];
	if (body != NULL) {
		NSLog(@"Setting body");
		[request setHTTPBody:body];
	}
	
	//NSURLResponse *response = [[NSURLResponse alloc] init];
	//NSError *error = [[NSError alloc] init];
	//NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	//[responseText setString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	if (! connection) {
		NSLog(@"Could not open connection to resource");
	}

}

#pragma mark -
#pragma mark Url Connection Delegate methods
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
	//[responseText setString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Did receive response");
	
	NSMutableString *headers = [[NSMutableString alloc] init];
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
	[headers appendFormat:@"HTTP %d\n\n", [httpResponse statusCode]];
	NSDictionary *headerDict = [httpResponse allHeaderFields];
	for (NSString *key in headerDict) {
		[headers appendFormat:@"%@: %@\n", key, [headerDict objectForKey:key]];
		if ([key isEqualToString:@"Content-Type"]) {
			NSString *contentTypeLine = [headerDict objectForKey:key];
			NSArray *parts = [contentTypeLine componentsSeparatedByString:@"; "];
			contentType = [[NSString alloc] initWithString:[parts objectAtIndex:0]];
			NSLog(@"Got content type = %@", contentType);
		}
	}
	
	[responseTextHeaders setString:headers];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Did fail");
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *newCredential;
		newCredential = [NSURLCredential credentialWithUser:[username stringValue]
												   password:[password stringValue]
												persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		[responseText setString:@"Authentication Failed"];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	BOOL needToPrintPlain = YES;
	if (contentType != NULL) {
		if ([contentType isEqualToString:@"application/atom+xml"] || 
			[contentType isEqualToString:@"application/rss+xml"] || 
			[contentType isEqualToString:@"application/xml"]) {
			NSLog(@"Formatting XML");
			NSError *error;
			NSXMLDocument *responseXML = [[NSXMLDocument alloc] initWithData:receivedData options:NSXMLDocumentTidyXML error:&error];
			if (!responseXML) {
				NSLog(@"Error reading response: %@", error);
			}
			[responseText setString:[responseXML XMLStringWithOptions:NSXMLNodePrettyPrint]];
			needToPrintPlain = NO;
		} else if ([contentType isEqualToString:@"application/json"]) {
			NSLog(@"Formatting JSON");
			SBJSON *parser = [[SBJSON alloc] init];
			[parser setHumanReadable:YES];
			id jsonObj = [parser objectWithString:[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]];
			NSString *jsonFormattedString = [[NSString alloc] initWithString:[parser stringWithObject:jsonObj]]; 
			[responseText setString:jsonFormattedString];
			needToPrintPlain = NO;
			[parser release];
		}
	} 
	
	// Bail out, just print the text
	if (needToPrintPlain) {
		[responseText setString:[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]];
	}
}

#pragma mark Table view methods
- (NSInteger) numberOfRowsInTableView:(NSTableView *) tableView {
	NSLog(@"Calling number rows");
	return [headersTable count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSLog(@"Calling objectValueForTableColumn %d %@", row, [tableColumn identifier]);
	return [[headersTable objectAtIndex:row] objectForKey:[tableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSMutableDictionary *row = [headersTable objectAtIndex:rowIndex];
	if (row == NULL) {
		row = [[NSMutableDictionary alloc] init];
	}
	[row setObject:anObject forKey:[aTableColumn identifier]];
	[headersTable replaceObjectAtIndex:rowIndex withObject:row];
}

- (IBAction) plusHeaderRow:(id)sender {
	NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
	[headersTable addObject:row];
	[headersTableView reloadData];
	[headersTableView selectRow:([headersTable count] - 1) byExtendingSelection:NO];
	[headersTableView editColumn:0 row:([headersTable count] - 1) withEvent:nil select:YES];
}

- (IBAction) clearAuth:(id)sender {
	[username setStringValue:@""];
	[password setStringValue:@""];
}

@end
