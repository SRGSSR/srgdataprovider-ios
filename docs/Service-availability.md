Service availability
====================

Integration Layer services are not available for all business units. The following document describes the availability of all services supported by the SRG Data Provider library, depending on the business unit which a data provider has been created with.

The maximum page size for all services supporting pagination is 100. The default page size is 10. A special _unlimited_ page size is available for some requests to return all entries at once.

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

For SWI, shows represent content categories (Business, Culture, etc.), and search returns only exact word matches.

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

## Online services

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | N/A | ❌ | ✅ | ❌ | ✅ | ❌ |

## Live center services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Videos | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

## Media search services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Video search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Audio search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

## Module services

Modules are collection of medias related to a specific context (e.g. an event).

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Module list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

## Popularity services

These services can be used to increase popularity indicators.

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Increase social count for a subdivision | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Increase social count for media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

## URN services

These services provide a way to access content from any business unit from any data provider.

| Request | Pagination | Unlimited page size | Remarks |
|:-- |:--:|:--:|:--:|
| Single media by URN | ❌ | N/A | - |
| List of medias by URNs | ✅ | ❌ | For the request to succeed, URNs must all have the same type (only videos or only audios), and must belong to the same business unit |
| Latest medias by topic URN | ✅ | ❌ | - |
| Most popular medias by topic URN | ✅ | ❌ | - |
| Media composition by URN | ❌ | N/A | - |
| Show by URN | ❌ | N/A | - |
| Latest episodes for show with URN | ✅ | ❌ | - |
| Latest medias by module URN | ✅ | ❌ | - |

## Tokenization services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| URL tokenization | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

### Remark

The URL tokenization service is in common to all BUs.

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
