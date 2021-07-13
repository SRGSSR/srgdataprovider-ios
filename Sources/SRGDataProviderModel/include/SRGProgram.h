//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGCrewMember.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGPresenter.h"
#import "SRGShow.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Program information (information about what is currently on air or what will be).
 */
@interface SRGProgram : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The date at which the content starts or started.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The date at which the content ends.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  A URL page associated with the content.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

/**
 *  The show to which the content belongs.
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

/**
 *  Programs contained in the program.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGProgram *> *subprograms;

/**
 *  The URN of the media associated with the program, if any.
 */
@property (nonatomic, readonly, copy, nullable) NSString *mediaURN;

/**
 *  The genre of the program.
 */
@property (nonatomic, readonly, copy, nullable) NSString *genre;

/**
 *  The season number.
 */
@property (nonatomic, readonly, nullable) NSNumber *seasonNumber;

/**
 *  The episode number.
 */
@property (nonatomic, readonly, nullable) NSNumber *episodeNumber;

/**
 *  The number of episodes.
 */
@property (nonatomic, readonly, nullable) NSNumber *numberOfEpisodes;

/**
 *  The production year.
 */
@property (nonatomic, readonly, nullable) NSNumber *productionYear;

/**
 *  The production country (displayable name).
 */
@property (nonatomic, readonly, copy, nullable) NSString *productionCountry;

/**
 *  The age rating.
 */
@property (nonatomic, readonly) SRGBlockingReason ageRating;

/**
 *  The original title.
 */
@property (nonatomic, readonly, copy, nullable) NSString *originalTitle;

/**
 *  Crew members.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGCrewMember *> *crewMembers;

/**
 *  `YES` iff the program is a rebroadcast.
 */
@property (nonatomic, readonly) BOOL isRebroadcast;

/**
 *  A description of the rebroadcast.
 */
@property (nonatomic, readonly, copy, nullable) NSString *rebroadcastDescription;

/**
 *  `YES` iff subtitles are available.
 */
@property (nonatomic, readonly) BOOL subtitlesAvailable;

/**
 *  `YES` iff alternate audio is available.
 */
@property (nonatomic, readonly) BOOL alternateAudioAvailable;

/**
 *  `YES` iff sign language is available.
 */
@property (nonatomic, readonly) BOOL signLanguageAvailable;

/**
 *  `YES` iff audio description is available.
 */
@property (nonatomic, readonly) BOOL audioDescriptionAvailable;

/**
 *  `YES` iff Dolby Digital is available.
 */
@property (nonatomic, readonly) BOOL dolbyDigitalAvailable;

@end

NS_ASSUME_NONNULL_END
