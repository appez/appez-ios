
/**
 * SmartEventProcessor.java: Responsible for rendering of WEB-EVENTs. Uses
 * services of SmartServiceRouter to get allocation of desired service as per
 * the demand of WEB-EVENTs. In case of APP-EVENT it just passes notification
 * back to SmartConnector using SmartEventListener.It implements
 * SmartServiceListener to get processing updates of active SmartService.
 */

#import <Foundation/Foundation.h>
#import "SmartEventDelegate.h"
#import "SmartEvent.h"
#import "SmartServiceRouter.h"
#import "SmartServiceDelegate.h"
#import "AppUtils.h"


@interface SmartEventProcessor : NSObject <SmartServiceDelegate>
{
    @private id<SmartEventDelegate> smartEventDelegate ;
    BOOL isBusy;
}

@property(nonatomic,strong) SmartServiceRouter     *smartServiceRouter;

-(instancetype)initSmartEventProcessorWithDelegate:(id<SmartEventDelegate>)delegate;

/**
 * Processes SmartEvent received from SmartConnector. In case of WEB-EVENT
 * it delegates responsibility to SmartServiceRouter. In case of APP-EVENT
 * it send back notification to SmartConnector
 * 
 * @param context
 *            : Current application context
 * @param smartEvent
 *            : SmartEvent to be processed
 */

-(void)processSmartEvent:(SmartEvent*)smartEvent;
@end
