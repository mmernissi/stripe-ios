//
//  STPIssuingCard.h
//  StripeiOS
//
//  Created by Jack Flintermann on 11/18/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPAPIResponseDecodable.h"
#import "STPCardBrand.h"

NS_ASSUME_NONNULL_BEGIN

@interface STPIssuingCard : NSObject<STPAPIResponseDecodable>
@property (nonatomic, readonly) NSString *cardId;
@property (nonatomic, readonly) NSString *last4;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) STPCardBrand brand;

+ (instancetype)cardWithCardId:(NSString *)cardId
                         last4:(NSString *)last4
                          name:(NSString *)name
                         brand:(STPCardBrand)brand;
@end

NS_ASSUME_NONNULL_END
