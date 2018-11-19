//
//  STPIssuingCard.m
//  StripeiOS
//
//  Created by Jack Flintermann on 11/18/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import "STPIssuingCard.h"
#import "NSDictionary+Stripe.h"
#import "STPCard.h"

@interface STPIssuingCard()
@property (nonatomic, readwrite) NSString *cardId;
@property (nonatomic, readwrite) NSString *last4;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) STPCardBrand brand;
@property (nonatomic, readwrite, copy) NSDictionary *allResponseFields;
@end

@implementation STPIssuingCard

+ (instancetype)cardWithCardId:(NSString *)cardId
                         last4:(NSString *)last4
                          name:(NSString *)name
                         brand:(STPCardBrand)brand {
    STPIssuingCard *card = [[STPIssuingCard alloc] init];
    card.cardId = cardId;
    card.last4 = last4;
    card.name = name;
    card.brand = brand;
    return card;
}

#pragma mark  - STPAPIResponseDecodable

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *dict = [response stp_dictionaryByRemovingNulls];
    if (!dict) {
        return nil;
    }
    
    // required fields
    NSString *cardId = [dict stp_stringForKey:@"id"];
    NSString *last4 = [dict stp_stringForKey:@"last4"];
    NSString *name = [dict stp_stringForKey:@"name"];
    NSString *brand = [dict stp_stringForKey:@"brand"];
    STPCardBrand brandEnum = [STPCard brandFromString:brand];
    
    if (!cardId || !last4 || !name) {
        return nil;
    }
    
    STPIssuingCard *card = [self cardWithCardId:cardId last4:last4 name:name brand:brandEnum];
    
    card.allResponseFields = dict;
    
    return card;
}


#pragma mark - Equality

- (BOOL)isEqual:(STPIssuingCard *)card {
    return [self isEqualToCard:card];
}

- (NSUInteger)hash {
    return [self.cardId hash];
}

- (BOOL)isEqualToCard:(STPIssuingCard *)card {
    if (self == card) {
        return YES;
    }
    
    if (!card || ![card isKindOfClass:self.class]) {
        return NO;
    }
    
    return [self.cardId isEqualToString:card.cardId];
}

@end
