//
//  STPPushProvisioningContext.h
//  Stripe
//
//  Created by Jack Flintermann on 9/27/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import "STPEphemeralKeyProvider.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^STPPushProvisioningRequestConfigurationBlock)(PKAddPaymentPassRequestConfiguration * __nullable configuration, NSError * __nullable error);

@interface STPPushProvisioningContext : NSObject<PKAddPaymentPassViewControllerDelegate>

- (instancetype)initWithKeyProvider:(id<STPIssuingCardEphemeralKeyProvider>)keyProvider;
- (void)generateRequestConfiguration:(nullable STPPushProvisioningRequestConfigurationBlock)completion;

@end

NS_ASSUME_NONNULL_END
