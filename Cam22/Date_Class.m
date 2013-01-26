//
//  Date_Class.m
//  moisture calculator iPad
//
//  Created by Jeffry Bobb on 6/18/12.
//
//

#import "Date_Class.h"

@implementation Date_Class






-(NSString *)Todays_Date{
   
    NSDateFormatter *dateFormat =[[NSDateFormatter alloc]init];
    [dateFormat setTimeStyle:NSDateFormatterLongStyle];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSDate *today = [NSDate date];
    NSString *dateString =[dateFormat stringFromDate:today];

    
    return dateString;
}
-(NSString *)Todays_Date_Full{
    
    NSDateFormatter *dateFormat =[[NSDateFormatter alloc]init];
    [dateFormat setTimeStyle:NSDateFormatterFullStyle];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSDate *today = [NSDate date];
    NSString *dateString =[dateFormat stringFromDate:today];
    
    
    return dateString;
}



-(NSString *)Time_Now{
    
    NSDateFormatter *dateFormat =[[NSDateFormatter alloc]init];
    [dateFormat setTimeStyle:NSDateFormatterLongStyle];
    NSDate *today = [NSDate date];
    NSString *dateString =[dateFormat stringFromDate:today];
    
    
    return dateString;
    
}
@end
