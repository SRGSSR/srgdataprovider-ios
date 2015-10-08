//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#import "RTSAnalyticsPageViewDataSource.h"

#if __has_include("RTSAnalyticsMediaPlayer.h")
#define RTSAnalyticsMediaPlayerIncluded
#import "RTSAnalyticsMediaPlayer.h"
#endif

/**
 * SRG/SSR Business units
 */
typedef enum {
	/**
	 *  Business unit for Schweizer Radio und Fernsehen (SRF)
	 *
	 *  - Comscore value   : "sfr"
	 *  - Netmetrix domain : "sfr"
	 */
	SSRBusinessUnitSRF,
	
	/**
	 *  Business unit for Radio Télévision Suisse (RTS)
	 *
	 *  - Comscore value   : "rts"
	 *  - Netmetrix domain : "rts"
	 */
	SSRBusinessUnitRTS,
	
	/**
	 *  Business unit for Radiotelevisione svizzera (RSI)
	 *
	 *  - Comscore value   : "rsi"
	 *  - Netmetrix domain : "rtsi"
	 */
	SSRBusinessUnitRSI,
	
	/**
	 *  Business unit for Radiotelevisiun Svizra Rumantscha (RTR)
	 *
	 *  - Comscore value   : "rtr"
	 *  - Netmetrix domain : "rtr"
	 */
	SSRBusinessUnitRTR,
	
	/**
	 *  Business unit for Swissinfo (SWI)
	 *
	 *  - Comscore value   : "swi"
	 *  - Netmetrix domain : "swissinf"
	 */
	SSRBusinessUnitSWI
	
} SSRBusinessUnit;


/**
 *  RTSAnalyticsTracker is used to track view events and stream measurements for SRG/SSR apps.
 *
 *  Analytics Tracker takes care of sending Comscore and Netmetrix page view events and Streamsense stream measurements.
 */
@interface RTSAnalyticsTracker : NSObject

/**
 *  ---------------------------------------
 *  @name Initializing an Analytics Tracker
 *  ---------------------------------------
 */

/**
 *  Singleton instance of the tracker.
 *
 *  @return Tracker's Instance
 */
+ (instancetype)sharedTracker;

/**
 *  Start tracking page events and streams
 *
 *  @param businessUnit  the SRG/SSR business unit for statistics measurements
 *  @param dataSource    the data source to be provided for stream tracking. This parameter is mandatory if using the `RTSAnalytics\MediaPlayer` submodule
 *  @param prod          the value to inform the library that the stats must be sent for production measurement.
 *
 *  @discussion the tracker uses values set in application Info.plist to track Comscore, Streamsense and Netmetrix measurement.
 *  Add an Info.plist dictionary named `RTSAnalytics` with 2 keypairs :
 *              ComscoreVirtualSite    : string - mandatory
 *              NetmetrixAppID         : string - NetmetrixAppID MUST be set ONLY for application in production.
 *
 *  The application MUST call `-startTrackingForBusinessUnit:...` methods ONLY in `-application:didFinishLaunchingWithOptions:`.
 */
#ifdef RTSAnalyticsMediaPlayerIncluded
- (void)startTrackingForBusinessUnit:(SSRBusinessUnit)businessUnit
                     mediaDataSource:(id<RTSAnalyticsMediaPlayerDataSource>)dataSource
                       forProduction:(BOOL)prod OS_NONNULL2;
#else
- (void)startTrackingForBusinessUnit:(SSRBusinessUnit)businessUnit
                       forProduction:(BOOL)prod;
#endif

/**
 *  --------------------
 *  @name Tracker Object
 *  --------------------
 */

/**
 *  The ComScore virtual site to be used for sending stats.
 */
@property (nonatomic, strong) NSString *comscoreVSite;

/**
 *  The NetMetrix application name to be used for view event tracking.
 */
@property (nonatomic, strong) NSString *netmetrixAppId;

/**
 *  The value that specify whether analytics must be sent to real servers and virtual sites.
 *
 *  If set to "NO" :
 *   - ComScore Virtual Site :     value will be "rts-app-test-v"
 *   - StreamSense Virtual Site :  value will be "rts-app-test-v"
 *   - NetMetrix :                 Netmetrix view events will NOT be sent !
 *
 *  If set to "YES :
 *   - ComScore Virtual Site :     value will be equal to `comscoreVSite` provided property
 *   - StreamSense Virtual Site :  value will be set to "{businessUnit}-v"
 */
@property (nonatomic, assign, readonly) BOOL production;

/**
 *  Return the business unit identifier
 *
 *  @param businessUnit the business unit
 *
 *  @return the corresponding identifier
 */
- (NSString *) businessUnitIdentifier:(SSRBusinessUnit)businessUnit;

/**
 *  Returns the business unit depending on its identifier
 *
 *  @param buIdentifier the identifier string like 'srf', 'rts', 'rsi', 'rtr', 'swi'
 *
 *  @return the corresponding business unit
 */
- (SSRBusinessUnit) businessUnitForIdentifier:(NSString *)buIdentifier;

/**
 *  -------------------
 *  @name View Tracking
 *  -------------------
 */

/**
 *  Track a view event with specified dataSource. 
 *  It will retrieve the page view labels dictionary from methods defined in `RTSAnalyticsPageViewDataSource` protocol.
 *
 *  @param dataSource the dataSource implementing the `RTSAnalyticsPageViewDataSource` protocol. (Mandatory)
 *
 *  @discussion the method is automatically called by view controllers conforming the `RTSAnalyticsPageViewDataSource` protocol, 
 *  @see `RTSAnalyticsPageViewDataSource`. The method can be called manually to send view events when changing page content 
 *  without presenting a new view controller:, e.g. when using UISegmentedControl, or when filtering data using the same view
 *  controller instance.
 *
 *  The methods is also automatically called when the app becomes active again. A reference of the last page view datasource is 
 *  kept by the tracker.
 */
- (void)trackPageViewForDataSource:(id<RTSAnalyticsPageViewDataSource>)dataSource;

/**
 *  Track a view event identified by its title and levels labels. 
 *  Helper method which calls `-(void)trackPageViewTitle:levels:fromPushNotification:` with no custom labels and fromPush value to `NO`
 *
 *  @param title    the page title tracked by Comscore. (Mandatory)
 *  @param levels   each levels value will be set as `srg_nX` labels and concatenated into the `category` label. (Optional)
 */
- (void)trackPageViewTitle:(NSString *)title levels:(NSArray *)levels;

/**
 *  Track a view event identified by its title, levels labels and origin (user opening the page view from a push notification or not).
 *
 *  @param title        the page title tracked by Comscore (set as `srg_title` label). (Mandatory)
 *                      The title value is "normalized" using `-(NSString *)comScoreFormattedString` from `NSString+RTSAnalyticsUtils` category.
 *                      An empty or nil title will be replaced with `Untitled` value.
 *  @param levels       a list of strings. Each level will be set as srg_nX (srg_n1, srg_n2, ...) label and will be concatenated in `category` 
 *                      label. (Optional)
 *  @param customLabels a dictionary of key values that will be set a labels when sending view events. Persistent labels can be overrided with those 
 *                      custom labels values.
 *  @param fromPush     YES, if the view controller has been opened from a push notification, NO otherwise.
 *
 *  @discussion if the levels array is nil or empty, then one level called `srg_n1` is added with default value `app`.
 *  Each level value is "normalized" using `-(NSString *)comScoreFormattedString` from `NSString+RTSAnalyticsUtils` category.
 */
- (void)trackPageViewTitle:(NSString *)title levels:(NSArray *)levels customLabels:(NSDictionary *)customLabels fromPushNotification:(BOOL)fromPush;

@end
