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

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Editorial medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Soon expiring medias | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Trending medias | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Latest episodes | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

### Topics

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Topics | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Latest medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Most popular medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination| Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Shows with specific identifiers | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Single show | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Show search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

#### Remark

For SWI, shows represent content categories (Business, Culture, etc.), and search returns only exact word matches.

## Radio services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |

#### Remark

Regional livestreams only exist for SRF, otherwise only main livestreams are available.

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Latest medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Most popular medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Latest episodes | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Shows with specific identifiers | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Single show | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
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

## Video services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Single video | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| List of videos | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Video media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Video search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

## Audio services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Single audio | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| List of audios | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Audio media composition | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A |
| Audio search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |

## Common services

These services provide a way to access content from any business unit from any data provider.

| Request | Remarks |
|:-- |:--:|
| Single media by URN | - |
| List of medias by URNs | For the request to succeed, URNs must all have the same type (only videos or only audios), and must belong to the same business unit |
| Media composition by URN | - |
| Show by URN | - |
| Latest episodes for show with URN | - |

## Module services

Modules are collection of medias related to a specific context (e.g. an event).

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Module list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |
| Latest medias for a module | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

## Tokenization services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| URL tokenization | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A |

### Remark

The URL tokenization service is in common to all BUs.
