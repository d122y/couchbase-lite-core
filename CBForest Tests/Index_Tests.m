//
//  Index_Tests.m
//  CBForest
//
//  Created by Jens Alfke on 4/2/14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <forestdb.h>
#import "CBForestIndex.h"


#define kDBPath @"/tmp/temp.fdbindex"


@interface Index_Tests : XCTestCase

@end

@implementation Index_Tests
{
    CBForestIndex* index;
}


- (void) setUp {
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath: kDBPath error: &error];
    index = [[CBForestIndex alloc] initWithFile: kDBPath readOnly: NO error: &error];
    XCTAssert(index, @"Couldn't open index: %@", error);
}

- (void) tearDown {
    [index close];
    index = nil;
    [super tearDown];
}


- (void) testBasics {
    NSDictionary* docs = @{
        @"CA": @[@"California", @"San Jose", @"San Francisco", @"Cambria"],
        @"WA": @[@"Washington", @"Seattle", @"Port Townsend", @"Skookumchuk"],
        @"OR": @[@"Oregon", @"Portland", @"Eugene"]};
    for (NSString* docID in docs) {
        NSArray* body = docs[docID];
        NSString* name = body[0];
        NSArray* keys = [body subarrayWithRange: NSMakeRange(1, body.count-1)];
        NSMutableArray* values = [NSMutableArray array];
        for (NSUInteger i = 0; i < keys.count; i++)
            [values addObject: name];
        NSError* error;
        XCTAssert([index setKeys: keys values: values forDocument: docID error: &error],
                  @"Indexing failed: %@", error);
    }

    NSError* error;
    XCTAssert([index commit: &error], @"Commit failed: %@", error);

    NSLog(@"--- First query");
    __block int nRows = 0;
    BOOL ok = [index queryStartKey: nil endKey: nil options: NULL error: &error
                             block: ^(id key, NSString *docID, NSData *rawValue, BOOL *stop)
    {
        nRows++;
        NSLog(@"key = %@, value=%@, docID = %@", key, rawValue, docID);
    }];
    XCTAssert(ok, @"Query failed: %@", error);
    XCTAssertEqual(nRows, 8);

    XCTAssert(([index setKeys: @[@"Portland", @"Walla Walla", @"Salem"]
                       values: @[@"Oregon", @"Oregon", @"Oregon"]
                  forDocument: @"OR" error: &error]),
              @"Indexing failed: %@", error);
    XCTAssert([index commit: &error], @"Commit failed: %@", error);

    NSLog(@"--- After updating OR");
    nRows = 0;
    ok = [index queryStartKey: nil endKey: nil options: NULL error: &error
                        block: ^(id key, NSString *docID, NSData *rawValue, BOOL *stop)
    {
        nRows++;
        NSLog(@"key = %@, value=%@, docID = %@", key, rawValue, docID);
    }];
    XCTAssert(ok, @"Query failed: %@", error);
    XCTAssertEqual(nRows, 9);

    XCTAssert(([index setKeys: nil values: nil forDocument: @"CA" error: &error]),
              @"Indexing failed: %@", error);

    NSLog(@"--- After removing CA:");
    nRows = 0;
    ok = [index queryStartKey: nil endKey: nil options: NULL error: &error
                        block: ^(id key, NSString *docID, NSData *rawValue, BOOL *stop)
    {
        nRows++;
        NSLog(@"key = %@, value=%@, docID = %@", key, rawValue, docID);
    }];
    XCTAssert(ok, @"Query failed: %@", error);
    XCTAssertEqual(nRows, 6);

}


@end