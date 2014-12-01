//
//  NSCalendar+HLSExtensionsTestCase.m
//  CoconutKit-demo
//
//  Created by Samuel Défago on 17.08.11.
//  Copyright 2011 Samuel Défago. All rights reserved.
//

#import "NSCalendar+HLSExtensionsTestCase.h"

@interface NSCalendar_HLSExtensionsTestCase ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSTimeZone *timeZoneZurich;
@property (nonatomic, strong) NSTimeZone *timeZoneTahiti;
@property (nonatomic, strong) NSDate *date1;
@property (nonatomic, strong) NSDate *date2;
@property (nonatomic, strong) NSDate *date3;
@property (nonatomic, strong) NSDate *date4;
@property (nonatomic, strong) NSDate *date5;

@end

@implementation NSCalendar_HLSExtensionsTestCase

#pragma mark Test setup and tear down

- (void)setUp
{
    [super setUp];
    
    // Europe/Zurich uses CEST during summer, between 1:00 UTC on the last Sunday of March and until 1:00 on the last Sunday of October. 
    // CET is used for the rest of the year. Pacific/Tahiti does not use daylight saving times. In summary:
    //   - when Europe/Zurich uses CET (UTC+1): Zurich is 11 hours ahead of Tahiti (UTC-10)
    //   - when Europe/Zurich uses CEST (UTC+2): Zurich is 12 hours ahead of Tahiti (UTC-10)
    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Zurich"];
    
    self.timeZoneZurich = [NSTimeZone timeZoneWithName:@"Europe/Zurich"];
    self.timeZoneTahiti = [NSTimeZone timeZoneWithName:@"Pacific/Tahiti"];
    
    // The two dates below correspond to days which are different whether we are in the Zurich time zone or in the Tahiti time zone
    // Date corresponding to the beginning of the year
    
    // For Europe/Zurich, this corresponds to 2012-01-01 08:23:00 (CET, UTC+1); for Pacific/Tahiti to 2011-12-31 21:23:00 (UTC-10)
    self.date1 = [NSDate dateWithTimeIntervalSinceReferenceDate:347095380.];
    
    // Date corresponding to March 1st on a leap year
    // For Europe/Zurich, this corresponds to 2012-03-01 06:12:00 (CET, UTC+1); for Pacific/Tahiti to 2012-02-29 19:12:00 (UTC-10)
    self.date2 = [NSDate dateWithTimeIntervalSinceReferenceDate:352271520.];
    
    // The three dates below are used to test the CET -> CEST transition in the Europe/Zurich time zone
        
    // For Europe/Zurich, this corresponds to 2012-03-25 01:00:00 (CET, UTC+1); for Pacific/Tahiti to 2012-03-24 14:00:00 (UTC-10). This
    // is one hour before the transition occurs
    self.date3 = [NSDate dateWithTimeIntervalSinceReferenceDate:354326400.];
    
    // For Europe/Zurich, this corresponds to 2012-03-25 03:00:00 (CEST, UTC+2); for Pacific/Tahiti to 2012-03-24 15:00:00 (UTC-10). This
    // is the exact time at which the transition occurs (i.e. the first date in CEST)
    self.date4 = [NSDate dateWithTimeIntervalSinceReferenceDate:354330000.];
    
    // For Europe/Zurich, this corresponds to 2012-03-26 05:00:00 (CEST, UTC+2); for Pacific/Tahiti to 2012-03-25 17:00:00 (UTC-10). This
    // is about a day after the CET -> CEST transition has occurred
    self.date5 = [NSDate dateWithTimeIntervalSinceReferenceDate:354423600.];
}

#pragma mark Tests

- (void)testDateFromComponentsInTimeZone
{
    NSDateComponents *dateComponentsZurich1 = [[NSDateComponents alloc] init];
    [dateComponentsZurich1 setYear:2012];
    [dateComponentsZurich1 setMonth:1];
    [dateComponentsZurich1 setDay:1];
    [dateComponentsZurich1 setHour:8];
    [dateComponentsZurich1 setMinute:23];
    NSDate *dateZurich1 = [self.calendar dateFromComponents:dateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich1 isEqualToDate:self.date1]);
    
    NSDateComponents *dateComponentsZurich2 = [[NSDateComponents alloc] init];
    [dateComponentsZurich2 setYear:2012];
    [dateComponentsZurich2 setMonth:3];
    [dateComponentsZurich2 setDay:1];
    [dateComponentsZurich2 setHour:6];
    [dateComponentsZurich2 setMinute:12];
    NSDate *dateZurich2 = [self.calendar dateFromComponents:dateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich2 isEqualToDate:self.date2]);
    
    NSDateComponents *dateComponentsZurich3 = [[NSDateComponents alloc] init];
    [dateComponentsZurich3 setYear:2012];
    [dateComponentsZurich3 setMonth:3];
    [dateComponentsZurich3 setDay:25];
    [dateComponentsZurich3 setHour:1];
    NSDate *dateZurich3 = [self.calendar dateFromComponents:dateComponentsZurich3 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich3 isEqualToDate:self.date3]);
    
    NSDateComponents *dateComponentsZurich4 = [[NSDateComponents alloc] init];
    [dateComponentsZurich4 setYear:2012];
    [dateComponentsZurich4 setMonth:3];
    [dateComponentsZurich4 setDay:25];
    [dateComponentsZurich4 setHour:3];
    NSDate *dateZurich4 = [self.calendar dateFromComponents:dateComponentsZurich4 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich4 isEqualToDate:self.date4]);
    
    NSDateComponents *dateComponentsZurich5 = [[NSDateComponents alloc] init];
    [dateComponentsZurich5 setYear:2012];
    [dateComponentsZurich5 setMonth:3];
    [dateComponentsZurich5 setDay:26];
    [dateComponentsZurich5 setHour:5];
    NSDate *dateZurich5 = [self.calendar dateFromComponents:dateComponentsZurich5 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich5 isEqualToDate:self.date5]);
    
    NSDateComponents *dateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [dateComponentsTahiti1 setYear:2011];
    [dateComponentsTahiti1 setMonth:12];
    [dateComponentsTahiti1 setDay:31];
    [dateComponentsTahiti1 setHour:21];
    [dateComponentsTahiti1 setMinute:23];
    NSDate *dateTahiti1 = [self.calendar dateFromComponents:dateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti1 isEqualToDate:self.date1]);
    
    NSDateComponents *dateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [dateComponentsTahiti2 setYear:2012];
    [dateComponentsTahiti2 setMonth:2];
    [dateComponentsTahiti2 setDay:29];
    [dateComponentsTahiti2 setHour:19];
    [dateComponentsTahiti2 setMinute:12];
    NSDate *dateTahiti2 = [self.calendar dateFromComponents:dateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti2 isEqualToDate:self.date2]);
    
    NSDateComponents *dateComponentsTahiti3 = [[NSDateComponents alloc] init];
    [dateComponentsTahiti3 setYear:2012];
    [dateComponentsTahiti3 setMonth:3];
    [dateComponentsTahiti3 setDay:24];
    [dateComponentsTahiti3 setHour:14];
    NSDate *dateTahiti3 = [self.calendar dateFromComponents:dateComponentsTahiti3 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti3 isEqualToDate:self.date3]);
    
    NSDateComponents *dateComponentsTahiti4 = [[NSDateComponents alloc] init];
    [dateComponentsTahiti4 setYear:2012];
    [dateComponentsTahiti4 setMonth:3];
    [dateComponentsTahiti4 setDay:24];
    [dateComponentsTahiti4 setHour:15];
    NSDate *dateTahiti4 = [self.calendar dateFromComponents:dateComponentsTahiti4 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti4 isEqualToDate:self.date4]);
    
    NSDateComponents *dateComponentsTahiti5 = [[NSDateComponents alloc] init];
    [dateComponentsTahiti5 setYear:2012];
    [dateComponentsTahiti5 setMonth:3];
    [dateComponentsTahiti5 setDay:25];
    [dateComponentsTahiti5 setHour:17];
    NSDate *dateTahiti5 = [self.calendar dateFromComponents:dateComponentsTahiti5 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti5 isEqualToDate:self.date5]);
}

- (void)testComponentsFromDateInTimeZone
{
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitTimeZone;
    
    NSDateComponents *dateComponentsZurich1 = [self.calendar components:unitFlags fromDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich1 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsZurich1 month], (NSInteger)1);
    XCTAssertEqual([dateComponentsZurich1 day], (NSInteger)1);
    XCTAssertEqual([dateComponentsZurich1 hour], (NSInteger)8);
    XCTAssertEqual([dateComponentsZurich1 minute], (NSInteger)23);
    NSTimeZone *componentsTimeZone1 = [dateComponentsZurich1 timeZone];
    XCTAssertEqualObjects([componentsTimeZone1 name], [self.timeZoneZurich name]);

    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *dateComponentsZurich2 = [self.calendar components:unitFlags fromDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich2 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsZurich2 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsZurich2 day], (NSInteger)1);
    XCTAssertEqual([dateComponentsZurich2 hour], (NSInteger)6);
    XCTAssertEqual([dateComponentsZurich2 minute], (NSInteger)12);
    NSTimeZone *componentsTimeZone2 = [dateComponentsZurich2 timeZone];
    XCTAssertNil(componentsTimeZone2);
    
    NSDateComponents *dateComponentsZurich3 = [self.calendar components:unitFlags fromDate:self.date3 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich3 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsZurich3 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsZurich3 day], (NSInteger)25);
    
    NSDateComponents *dateComponentsZurich4 = [self.calendar components:unitFlags fromDate:self.date4 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich4 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsZurich4 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsZurich4 day], (NSInteger)25);
    XCTAssertEqual([dateComponentsZurich4 hour], (NSInteger)3);
    
    NSDateComponents *dateComponentsZurich5 = [self.calendar components:unitFlags fromDate:self.date5 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich5 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsZurich5 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsZurich5 day], (NSInteger)26);
    XCTAssertEqual([dateComponentsZurich5 hour], (NSInteger)5);

    NSDateComponents *dateComponentsTahiti1 = [self.calendar components:unitFlags fromDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual([dateComponentsTahiti1 year], (NSInteger)2011);
    XCTAssertEqual([dateComponentsTahiti1 month], (NSInteger)12);
    XCTAssertEqual([dateComponentsTahiti1 day], (NSInteger)31);
    XCTAssertEqual([dateComponentsTahiti1 hour], (NSInteger)21);
    XCTAssertEqual([dateComponentsTahiti1 minute], (NSInteger)23);
    
    NSDateComponents *dateComponentsTahiti2 = [self.calendar components:unitFlags fromDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual([dateComponentsTahiti2 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsTahiti2 month], (NSInteger)2);
    XCTAssertEqual([dateComponentsTahiti2 day], (NSInteger)29);
    XCTAssertEqual([dateComponentsTahiti2 hour], (NSInteger)19);
    XCTAssertEqual([dateComponentsTahiti2 minute], (NSInteger)12);
    
    NSDateComponents *dateComponentsTahiti3 = [self.calendar components:unitFlags fromDate:self.date3 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual([dateComponentsTahiti3 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsTahiti3 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsTahiti3 day], (NSInteger)24);
    XCTAssertEqual([dateComponentsTahiti3 hour], (NSInteger)14);
    
    NSDateComponents *dateComponentsTahiti4 = [self.calendar components:unitFlags fromDate:self.date4 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual([dateComponentsTahiti4 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsTahiti4 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsTahiti4 day], (NSInteger)24);
    XCTAssertEqual([dateComponentsTahiti4 hour], (NSInteger)15);
    
    NSDateComponents *dateComponentsTahiti5 = [self.calendar components:unitFlags fromDate:self.date5 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual([dateComponentsTahiti5 year], (NSInteger)2012);
    XCTAssertEqual([dateComponentsTahiti5 month], (NSInteger)3);
    XCTAssertEqual([dateComponentsTahiti5 day], (NSInteger)25);
    XCTAssertEqual([dateComponentsTahiti5 hour], (NSInteger)17);
}

- (void)testNumberOfDaysInUnitContainingDateInTimeZone
{
    NSUInteger nbrDaysInMonthZurich1 = [self.calendar numberOfDaysInUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(nbrDaysInMonthZurich1, (NSUInteger)31);
    
    NSUInteger nbrDaysInYearZurich1 = [self.calendar numberOfDaysInUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(nbrDaysInYearZurich1, (NSUInteger)366);
    
    NSUInteger nbrDaysInMonthZurich2 = [self.calendar numberOfDaysInUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(nbrDaysInMonthZurich2, (NSUInteger)31);
    
    NSUInteger nbrDaysInYearZurich2 = [self.calendar numberOfDaysInUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(nbrDaysInYearZurich2, (NSUInteger)366);
    
    NSUInteger nbrDaysInMonthTahiti1 = [self.calendar numberOfDaysInUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(nbrDaysInMonthTahiti1, (NSUInteger)31);
    
    NSUInteger nbrDaysInYearTahiti1 = [self.calendar numberOfDaysInUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(nbrDaysInYearTahiti1, (NSUInteger)365);
    
    NSUInteger nbrDaysInMonthTahiti2 = [self.calendar numberOfDaysInUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(nbrDaysInMonthTahiti2, (NSUInteger)29);
    
    NSUInteger nbrDaysInYearTahiti2 = [self.calendar numberOfDaysInUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(nbrDaysInYearTahiti2, (NSUInteger)366);
}

- (void)testStartDateOfUnitContainingDateInTimeZone
{
    NSDate *startDateMonthZurich1 = [self.calendar startDateOfUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateMonthComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedStartDateMonthComponentsZurich1 setYear:2012];
    [expectedStartDateMonthComponentsZurich1 setMonth:1];
    [expectedStartDateMonthComponentsZurich1 setDay:1];
    NSDate *expectedStartDateMonthZurich1 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateMonthZurich1 isEqualToDate:expectedStartDateMonthZurich1]);
    
    NSDate *startDateYearZurich1 = [self.calendar startDateOfUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateYearComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedStartDateYearComponentsZurich1 setYear:2012];
    [expectedStartDateYearComponentsZurich1 setMonth:1];
    [expectedStartDateYearComponentsZurich1 setDay:1];
    NSDate *expectedStartDateYearZurich1 = [self.calendar dateFromComponents:expectedStartDateYearComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateYearZurich1 isEqualToDate:expectedStartDateYearZurich1]);
    
    NSDate *startDateMonthZurich2 = [self.calendar startDateOfUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateMonthComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedStartDateMonthComponentsZurich2 setYear:2012];
    [expectedStartDateMonthComponentsZurich2 setMonth:3];
    [expectedStartDateMonthComponentsZurich2 setDay:1];
    NSDate *expectedStartDateMonthZurich2 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateMonthZurich2 isEqualToDate:expectedStartDateMonthZurich2]);
    
    NSDate *startDateYearZurich2 = [self.calendar startDateOfUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateYearComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedStartDateYearComponentsZurich2 setYear:2012];
    [expectedStartDateYearComponentsZurich2 setMonth:1];
    [expectedStartDateYearComponentsZurich2 setDay:1];
    NSDate *expectedStartDateYearZurich2 = [self.calendar dateFromComponents:expectedStartDateYearComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateYearZurich2 isEqualToDate:expectedStartDateYearZurich2]);
    
    NSDate *startDateMonthTahiti1 = [self.calendar startDateOfUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateMonthComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedStartDateMonthComponentsTahiti1 setYear:2011];
    [expectedStartDateMonthComponentsTahiti1 setMonth:12];
    [expectedStartDateMonthComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateMonthTahiti1 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateMonthTahiti1 isEqualToDate:expectedStartDateMonthTahiti1]);
    
    NSDate *startDateYearTahiti1 = [self.calendar startDateOfUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateYearComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedStartDateYearComponentsTahiti1 setYear:2011];
    [expectedStartDateYearComponentsTahiti1 setMonth:1];
    [expectedStartDateYearComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateYearTahiti1 = [self.calendar dateFromComponents:expectedStartDateYearComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateYearTahiti1 isEqualToDate:expectedStartDateYearTahiti1]);
    
    NSDate *startDateMonthTahiti2 = [self.calendar startDateOfUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateMonthComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedStartDateMonthComponentsTahiti2 setYear:2012];
    [expectedStartDateMonthComponentsTahiti2 setMonth:2];
    [expectedStartDateMonthComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateMonthTahiti2 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateMonthTahiti2 isEqualToDate:expectedStartDateMonthTahiti2]);
    
    NSDate *startDateYearTahiti2 = [self.calendar startDateOfUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateYearComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedStartDateYearComponentsTahiti2 setYear:2012];
    [expectedStartDateYearComponentsTahiti2 setMonth:1];
    [expectedStartDateYearComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateYearTahiti2 = [self.calendar dateFromComponents:expectedStartDateYearComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateYearTahiti2 isEqualToDate:expectedStartDateYearTahiti2]);
}

- (void)testEndDateOfUnitContainingDateInTimeZone
{
    NSDate *endDateMonthZurich1 = [self.calendar endDateOfUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateMonthComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedEndDateMonthComponentsZurich1 setYear:2012];
    [expectedEndDateMonthComponentsZurich1 setMonth:2];
    [expectedEndDateMonthComponentsZurich1 setDay:1];
    NSDate *expectedEndDateMonthZurich1 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([endDateMonthZurich1 isEqualToDate:expectedEndDateMonthZurich1]);
    
    NSDate *endDateYearZurich1 = [self.calendar endDateOfUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateYearComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedEndDateYearComponentsZurich1 setYear:2013];
    [expectedEndDateYearComponentsZurich1 setMonth:1];
    [expectedEndDateYearComponentsZurich1 setDay:1];
    NSDate *expectedEndDateYearZurich1 = [self.calendar dateFromComponents:expectedEndDateYearComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([endDateYearZurich1 isEqualToDate:expectedEndDateYearZurich1]);
    
    NSDate *endDateMonthZurich2 = [self.calendar endDateOfUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateMonthComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedEndDateMonthComponentsZurich2 setYear:2012];
    [expectedEndDateMonthComponentsZurich2 setMonth:4];
    [expectedEndDateMonthComponentsZurich2 setDay:1];
    NSDate *expectedEndDateMonthZurich2 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([endDateMonthZurich2 isEqualToDate:expectedEndDateMonthZurich2]);
    
    NSDate *endDateYearZurich2 = [self.calendar endDateOfUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateYearComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedEndDateYearComponentsZurich2 setYear:2013];
    [expectedEndDateYearComponentsZurich2 setMonth:1];
    [expectedEndDateYearComponentsZurich2 setDay:1];
    NSDate *expectedEndDateYearZurich2 = [self.calendar dateFromComponents:expectedEndDateYearComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([endDateYearZurich2 isEqualToDate:expectedEndDateYearZurich2]);
    
    NSDate *endDateMonthTahiti1 = [self.calendar endDateOfUnit:NSCalendarUnitMonth containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateMonthComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedEndDateMonthComponentsTahiti1 setYear:2012];
    [expectedEndDateMonthComponentsTahiti1 setMonth:1];
    [expectedEndDateMonthComponentsTahiti1 setDay:1];
    NSDate *expectedEndDateMonthTahiti1 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([endDateMonthTahiti1 isEqualToDate:expectedEndDateMonthTahiti1]);
    
    NSDate *endDateYearTahiti1 = [self.calendar endDateOfUnit:NSCalendarUnitYear containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateYearComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedEndDateYearComponentsTahiti1 setYear:2012];
    [expectedEndDateYearComponentsTahiti1 setMonth:1];
    [expectedEndDateYearComponentsTahiti1 setDay:1];
    NSDate *expectedEndDateYearTahiti1 = [self.calendar dateFromComponents:expectedEndDateYearComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([endDateYearTahiti1 isEqualToDate:expectedEndDateYearTahiti1]);
    
    NSDate *endDateMonthTahiti2 = [self.calendar endDateOfUnit:NSCalendarUnitMonth containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateMonthComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedEndDateMonthComponentsTahiti2 setYear:2012];
    [expectedEndDateMonthComponentsTahiti2 setMonth:3];
    [expectedEndDateMonthComponentsTahiti2 setDay:1];
    NSDate *expectedEndDateMonthTahiti2 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([endDateMonthTahiti2 isEqualToDate:expectedEndDateMonthTahiti2]);
    
    NSDate *endDateYearTahiti2 = [self.calendar endDateOfUnit:NSCalendarUnitYear containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateYearComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedEndDateYearComponentsTahiti2 setYear:2013];
    [expectedEndDateYearComponentsTahiti2 setMonth:1];
    [expectedEndDateYearComponentsTahiti2 setDay:1];
    NSDate *expectedEndDateYearTahiti2 = [self.calendar dateFromComponents:expectedEndDateYearComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([endDateYearTahiti2 isEqualToDate:expectedEndDateYearTahiti2]);
}

- (void)testRangeOfUnitInUnitForDateInTimeZone
{
    // Days in a year are always in [1; 31], whatever the date
    NSRange rangeDayInYearZurich1 = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue(NSEqualRanges(rangeDayInYearZurich1, NSMakeRange(1, 31)));
    
    // Months in a year are always in [1; 12], whatever the date
    NSRange rangeMonthInYearZurich1 = [self.calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue(NSEqualRanges(rangeMonthInYearZurich1, NSMakeRange(1, 12)));
    
    // January 2012: 31 days
    NSRange rangeDayInMonthZurich1 = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue(NSEqualRanges(rangeDayInMonthZurich1, NSMakeRange(1, 31)));
    
    // March 2012: 31 days
    NSRange rangeDayInMonthZurich2 = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue(NSEqualRanges(rangeDayInMonthZurich2, NSMakeRange(1, 31)));
    
    // December 2011: 31 days
    NSRange rangeDayInMonthTahiti1 = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue(NSEqualRanges(rangeDayInMonthTahiti1, NSMakeRange(1, 31)));
    
    // February 2012: 29 days
    NSRange rangeDayInMonthTahiti2 = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue(NSEqualRanges(rangeDayInMonthTahiti2, NSMakeRange(1, 29)));
}

- (void)testOrdinalityOfUnitInUnitForDateInTimeZone
{
    NSUInteger ordinalityDayInYearZurich1 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityDayInYearZurich1, (NSUInteger)1);
    
    NSUInteger ordinalityDayInYearZurich2 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityDayInYearZurich2, (NSUInteger)61);
    
    NSUInteger ordinalityDayInYearTahiti1 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityDayInYearTahiti1, (NSUInteger)365);
    
    NSUInteger ordinalityDayInYearTahiti2 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityDayInYearTahiti2, (NSUInteger)60);
    
    NSUInteger ordinalityMonthInYearZurich1 = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityMonthInYearZurich1, (NSUInteger)1);

    NSUInteger ordinalityMonthInYearZurich2 = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityMonthInYearZurich2, (NSUInteger)3);

    NSUInteger ordinalityMonthInYearTahiti1 = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityMonthInYearTahiti1, (NSUInteger)12);
    
    NSUInteger ordinalityMonthInYearTahiti2 = [self.calendar ordinalityOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityMonthInYearTahiti2, (NSUInteger)2);
    
    NSUInteger ordinalityDayInMonthZurich1 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityDayInMonthZurich1, (NSUInteger)1);
    
    NSUInteger ordinalityDayInMonthZurich2 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual(ordinalityDayInMonthZurich2, (NSUInteger)1);
    
    NSUInteger ordinalityDayInMonthTahiti1 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityDayInMonthTahiti1, (NSUInteger)31);
    
    NSUInteger ordinalityDayInMonthTahiti2 = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertEqual(ordinalityDayInMonthTahiti2, (NSUInteger)29);
}

- (void)testRangeOfUnitStartDateIntervalForDateInTimeZone
{
    NSTimeInterval intervalDayInMonthZurich1 = 0.;
    NSDate *startDateZurich1 = nil;
    [self.calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDateZurich1 interval:&intervalDayInMonthZurich1 forDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedStartDateComponentsZurich1 setYear:2012];
    [expectedStartDateComponentsZurich1 setMonth:1];
    [expectedStartDateComponentsZurich1 setDay:1];
    NSDate *expectedStartDateZurich1 = [self.calendar dateFromComponents:expectedStartDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateZurich1 isEqualToDate:expectedStartDateZurich1]);
    XCTAssertEqual(round(intervalDayInMonthZurich1 / (24 * 60 * 60)), 31.);        // January 2012: 31 days
    
    NSTimeInterval intervalDayInMonthZurich2 = 0.;
    NSDate *startDateZurich2 = nil;
    [self.calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDateZurich2 interval:&intervalDayInMonthZurich2 forDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedStartDateComponentsZurich2 setYear:2012];
    [expectedStartDateComponentsZurich2 setMonth:3];
    [expectedStartDateComponentsZurich2 setDay:1];
    NSDate *expectedStartDateZurich2 = [self.calendar dateFromComponents:expectedStartDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([startDateZurich2 isEqualToDate:expectedStartDateZurich2]);
    XCTAssertEqual(round(intervalDayInMonthZurich2 / (24 * 60 * 60)), 31.);       // March 2012: 31 days
    
    NSTimeInterval intervalDayInMonthTahiti1 = 0.;
    NSDate *startDateTahiti1 = nil;
    [self.calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDateTahiti1 interval:&intervalDayInMonthTahiti1 forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedStartDateComponentsTahiti1 setYear:2011];
    [expectedStartDateComponentsTahiti1 setMonth:12];
    [expectedStartDateComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateTahiti1 = [self.calendar dateFromComponents:expectedStartDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateTahiti1 isEqualToDate:expectedStartDateTahiti1]);
    XCTAssertEqual(round(intervalDayInMonthTahiti1 / (24 * 60 * 60)), 31.);       // December 2011: 31 days
    
    NSTimeInterval intervalDayInMonthTahiti2 = 0.;
    NSDate *startDateTahiti2 = nil;
    [self.calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDateTahiti2 interval:&intervalDayInMonthTahiti2 forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedStartDateComponentsTahiti2 setYear:2012];
    [expectedStartDateComponentsTahiti2 setMonth:2];
    [expectedStartDateComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateTahiti2 = [self.calendar dateFromComponents:expectedStartDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([startDateTahiti2 isEqualToDate:expectedStartDateTahiti2]);
    XCTAssertEqual(round(intervalDayInMonthTahiti2 / (24 * 60 * 60)), 29.);       // February 2012: 29 days
}

- (void)testDateByAddingComponentsToDateOptionsInTimeZone
{
    NSDateComponents *addedDateComponents = [[NSDateComponents alloc] init];
    [addedDateComponents setYear:2];
    [addedDateComponents setMonth:-1];
    [addedDateComponents setDay:6];
    [addedDateComponents setHour:2];
    [addedDateComponents setMinute:-20];
    
    NSDate *dateZurich1 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date1 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich1 setYear:2013];
    [expectedDateComponentsZurich1 setMonth:12];
    [expectedDateComponentsZurich1 setDay:7];
    [expectedDateComponentsZurich1 setHour:10];
    [expectedDateComponentsZurich1 setMinute:3];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1]);
    
    NSDate *dateZurich2 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date2 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich2 setYear:2014];
    [expectedDateComponentsZurich2 setMonth:2];
    [expectedDateComponentsZurich2 setDay:7];
    [expectedDateComponentsZurich2 setHour:7];
    [expectedDateComponentsZurich2 setMinute:52];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2]);
    
    NSDate *dateZurich3 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date3 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich3 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich3 setYear:2014];
    [expectedDateComponentsZurich3 setMonth:3];
    [expectedDateComponentsZurich3 setDay:3];
    [expectedDateComponentsZurich3 setHour:2];
    [expectedDateComponentsZurich3 setMinute:40];
    NSDate *expectedDateZurich3 = [self.calendar dateFromComponents:expectedDateComponentsZurich3 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich3 isEqualToDate:expectedDateZurich3]);
    
    NSDate *dateZurich4 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date4 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich4 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich4 setYear:2014];
    [expectedDateComponentsZurich4 setMonth:3];
    [expectedDateComponentsZurich4 setDay:3];
    [expectedDateComponentsZurich4 setHour:4];
    [expectedDateComponentsZurich4 setMinute:40];
    NSDate *expectedDateZurich4 = [self.calendar dateFromComponents:expectedDateComponentsZurich4 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich4 isEqualToDate:expectedDateZurich4]);
    
    NSDate *dateZurich5 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich5 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich5 setYear:2014];
    [expectedDateComponentsZurich5 setMonth:3];
    [expectedDateComponentsZurich5 setDay:4];
    [expectedDateComponentsZurich5 setHour:6];
    [expectedDateComponentsZurich5 setMinute:40];
    NSDate *expectedDateZurich5 = [self.calendar dateFromComponents:expectedDateComponentsZurich5 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich5 isEqualToDate:expectedDateZurich5]);
    
    NSDate *dateTahiti1 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date1 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti1 setYear:2013];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:6];
    [expectedDateComponentsTahiti1 setHour:23];
    [expectedDateComponentsTahiti1 setMinute:3];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1]);
    
    NSDate *dateTahiti2 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date2 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti2 setYear:2014];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:3];
    [expectedDateComponentsTahiti2 setHour:20];
    [expectedDateComponentsTahiti2 setMinute:52];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2]);
    
    NSDate *dateTahiti3 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date3 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti3 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti3 setYear:2014];
    [expectedDateComponentsTahiti3 setMonth:3];
    [expectedDateComponentsTahiti3 setDay:2];
    [expectedDateComponentsTahiti3 setHour:15];
    [expectedDateComponentsTahiti3 setMinute:40];
    NSDate *expectedDateTahiti3 = [self.calendar dateFromComponents:expectedDateComponentsTahiti3 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti3 isEqualToDate:expectedDateTahiti3]);
    
    NSDate *dateTahiti4 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date4 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti4 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti4 setYear:2014];
    [expectedDateComponentsTahiti4 setMonth:3];
    [expectedDateComponentsTahiti4 setDay:2];
    [expectedDateComponentsTahiti4 setHour:16];
    [expectedDateComponentsTahiti4 setMinute:40];
    NSDate *expectedDateTahiti4 = [self.calendar dateFromComponents:expectedDateComponentsTahiti4 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti4 isEqualToDate:expectedDateTahiti4]);
    
    NSDate *dateTahiti5 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date5 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti5 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti5 setYear:2014];
    [expectedDateComponentsTahiti5 setMonth:3];
    [expectedDateComponentsTahiti5 setDay:3];
    [expectedDateComponentsTahiti5 setHour:18];
    [expectedDateComponentsTahiti5 setMinute:40];
    NSDate *expectedDateTahiti5 = [self.calendar dateFromComponents:expectedDateComponentsTahiti5 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti5 isEqualToDate:expectedDateTahiti5]);
}

- (void)testComponentsFromDateToDateOptionsInTimeZone
{
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *dateComponentsZurich43 = [self.calendar components:unitFlags fromDate:self.date3 toDate:self.date4 options:0 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich43 hour], (NSInteger)1);
    
    NSDateComponents *dateComponentsZurich53 = [self.calendar components:unitFlags fromDate:self.date3 toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich53 day], (NSInteger)1);
    XCTAssertEqual([dateComponentsZurich53 hour], (NSInteger)4);
    
    NSDateComponents *dateComponentsZurich54 = [self.calendar components:unitFlags fromDate:self.date4 toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    XCTAssertEqual([dateComponentsZurich54 day], (NSInteger)1);
    XCTAssertEqual([dateComponentsZurich54 hour], (NSInteger)2);
}

- (void)testDateAtNoonTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[NSDateComponents alloc] init];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    [expectedDateComponents1 setHour:12];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1];
    XCTAssertTrue([date1 isEqualToDate:expectedDate1]);
    
    NSDateComponents *expectedDateComponents2 = [[NSDateComponents alloc] init];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    [expectedDateComponents2 setHour:12];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2];
    XCTAssertTrue([date2 isEqualToDate:expectedDate2]);
}

- (void)testDateAtNoonTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    [expectedDateComponentsZurich1 setHour:12];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1]);
    
    NSDateComponents *expectedDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    [expectedDateComponentsZurich2 setHour:12];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2]);
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    [expectedDateComponentsTahiti1 setHour:12];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1]);
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    [expectedDateComponentsTahiti2 setHour:12];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2]);
}

- (void)testDateAtMidnightTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[NSDateComponents alloc] init];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1];
    XCTAssertTrue([date1 isEqualToDate:expectedDate1]);
    
    NSDateComponents *expectedDateComponents2 = [[NSDateComponents alloc] init];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2];
    XCTAssertTrue([date2 isEqualToDate:expectedDate2]);
}

- (void)testDateAtMidnightTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1]);
    
    NSDateComponents *expectedDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2]);
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1]);
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2]);
}

- (void)testDateAtHourMinuteSecondTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[NSDateComponents alloc] init];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    [expectedDateComponents1 setHour:14];
    [expectedDateComponents1 setMinute:27];
    [expectedDateComponents1 setSecond:36];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1];
    XCTAssertTrue([date1 isEqualToDate:expectedDate1]);
    
    NSDateComponents *expectedDateComponents2 = [[NSDateComponents alloc] init];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    [expectedDateComponents2 setHour:14];
    [expectedDateComponents2 setMinute:27];
    [expectedDateComponents2 setSecond:36];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2];
    XCTAssertTrue([date2 isEqualToDate:expectedDate2]);
}

- (void)testDateAtHourMinuteSecondTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    [expectedDateComponentsZurich1 setHour:14];
    [expectedDateComponentsZurich1 setMinute:27];
    [expectedDateComponentsZurich1 setSecond:36];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1]);
    
    NSDateComponents *expectedDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    [expectedDateComponentsZurich2 setHour:14];
    [expectedDateComponentsZurich2 setMinute:27];
    [expectedDateComponentsZurich2 setSecond:36];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2]);
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    [expectedDateComponentsTahiti1 setHour:14];
    [expectedDateComponentsTahiti1 setMinute:27];
    [expectedDateComponentsTahiti1 setSecond:36];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1]);
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    [expectedDateComponentsTahiti2 setHour:14];
    [expectedDateComponentsTahiti2 setMinute:27];
    [expectedDateComponentsTahiti2 setSecond:36];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2]);
}

- (void)testCompareDaysBetweenDateAndDate
{
    NSDateComponents *otherDateComponents1 = [[NSDateComponents alloc] init];
    [otherDateComponents1 setYear:2012];
    [otherDateComponents1 setMonth:1];
    [otherDateComponents1 setDay:1];
    [otherDateComponents1 setHour:15];
    NSDate *otherDate1 = [self.calendar dateFromComponents:otherDateComponents1];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDate1] == NSOrderedSame);
    
    NSDateComponents *otherDateComponents2 = [[NSDateComponents alloc] init];
    [otherDateComponents2 setYear:2012];
    [otherDateComponents2 setMonth:3];
    [otherDateComponents2 setDay:1];
    [otherDateComponents2 setHour:15];
    NSDate *otherDate2 = [self.calendar dateFromComponents:otherDateComponents2];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDate2] == NSOrderedSame);
}

- (void)testCompareDaysBetweenDateAndDateInTimeZone
{
    NSDateComponents *otherDateComponentsZurich1 = [[NSDateComponents alloc] init];
    [otherDateComponentsZurich1 setYear:2012];
    [otherDateComponentsZurich1 setMonth:1];
    [otherDateComponentsZurich1 setDay:1];
    [otherDateComponentsZurich1 setHour:15];
    NSDate *otherDateZurich1 = [self.calendar dateFromComponents:otherDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDateZurich1 inTimeZone:self.timeZoneZurich] == NSOrderedSame);
    
    NSDateComponents *otherDateComponentsZurich2 = [[NSDateComponents alloc] init];
    [otherDateComponentsZurich2 setYear:2012];
    [otherDateComponentsZurich2 setMonth:3];
    [otherDateComponentsZurich2 setDay:1];
    [otherDateComponentsZurich2 setHour:15];
    NSDate *otherDateZurich2 = [self.calendar dateFromComponents:otherDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDateZurich2 inTimeZone:self.timeZoneZurich] == NSOrderedSame);
    
    NSDateComponents *otherDateComponentsTahiti1 = [[NSDateComponents alloc] init];
    [otherDateComponentsTahiti1 setYear:2011];
    [otherDateComponentsTahiti1 setMonth:12];
    [otherDateComponentsTahiti1 setDay:31];
    [otherDateComponentsTahiti1 setHour:15];
    NSDate *otherDateTahiti1 = [self.calendar dateFromComponents:otherDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDateTahiti1 inTimeZone:self.timeZoneTahiti] == NSOrderedSame);
    
    NSDateComponents *otherDateComponentsTahiti2 = [[NSDateComponents alloc] init];
    [otherDateComponentsTahiti2 setYear:2012];
    [otherDateComponentsTahiti2 setMonth:2];
    [otherDateComponentsTahiti2 setDay:29];
    [otherDateComponentsTahiti2 setHour:15];
    NSDate *otherDateTahiti2 = [self.calendar dateFromComponents:otherDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    XCTAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDateTahiti2 inTimeZone:self.timeZoneTahiti] == NSOrderedSame);
}

@end
