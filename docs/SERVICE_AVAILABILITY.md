Service availability
====================

Integration Layer services are not available for all business units. The following document describes the availability of all services supported by the SRG Data Provider library, depending on the business unit which a data provider has been created with.

The maximum page size for all services supporting pagination is 100. The default page size is defined by the Integration Layer and is 10. A special _unlimited_ page size is available for some requests to return all entries at once.

#### Remark

Services are currently only available for SRG SSR vendors (SRF, RTS, RSI, RTR and SWI), not for regional vendors (TVO, Canal Alpha).

## TV services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Scheduled livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Editorial medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Latest medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Most popular medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Soon expiring medias | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Trending medias | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Latest episodes | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Videos with tags | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |

### Topics

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Topics | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination| Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Show search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

#### Remark

For SWI, shows represent content categories (Business, Culture, etc.) and search returns only exact word matches.

## Radio services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Livestreams by channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Livestreams for content providers | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |

#### Remark

Regional livestreams only exist for SRF, otherwise only main livestreams are available.

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Latest medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Most popular medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Latest episodes | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Latest videos | ❌ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Show search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

### Songs

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Recent songs | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Current song on air | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |

## Live center services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Videos | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

## Search services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Media search | ✅ | ✅ | ✅ | ✅ | ✅ (1) | ✅ | ❌ |
| Show search | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Most searched shows | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Videos with tags | ✅ | ❌ | ❌ | ⚠️ (2) | ❌ | ✅ | ❌ |

(1) At the moment, SWI only supports a search term but no settings. If settings are applied the request will fail with an error.
(2) RTR only supports `fullLengthExcluded = NO`.

## Recommendation services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Recommended medias | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |

## Module services

Modules are collection of medias related to a specific context (e.g. an event).

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Module list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

## General services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Service message | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

## Popularity services

These services can be used to increase popularity indicators.

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Increase social count for a subdivision | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Increase social count for media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Increase show view count from search results | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

## URN services

These services provide a way to access content from any business unit from any data provider.

| Request | Pagination | Unlimited page size |
|:-- |:--:|:--:|
| Single media by URN | ❌ | N/A |
| List of medias by URNs | ✅ | ✅ but ⚠️ |
| Latest medias by topic URN | ✅ | ❌ |
| Most popular medias by topic URN | ✅ | ❌ |
| Media composition by URN | ❌ | N/A |
| Single show by URN | ❌ | N/A |
| List of shows by URNs | ✅ | ✅ but ⚠️ |
| Latest episodes for show with URN | ✅ | ❌ |
| Latest medias by module URN | ✅ | ❌ |

⚠️ Pagination is supported, but with a limit of 50. Attempting to request larger page sizes will fail.

## Image scaling services

A ⚠️ means that a service is supported, but might not return an image with the exact requested dimension.

| Request | SRF | RTS | RSI | RTR | SWI |
|:-- |:--:|:--:|:--:|:--:|:--:|
| Video image with width | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| Video image with height | ✅ | ✅ | ❌| ✅ | ⚠️ |
| Audio image with width | ✅ | ✅ | ⚠️ | ✅ | N/A |
| Audio image with height | ⚠️ | ✅ | ❌ | ⚠️ | N/A |

### Remark

Scale image URL services are BUs dependant
