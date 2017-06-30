Service availability
====================

Integration Layer services are not available for all business units. The following document describes the availability of all services supported by the SRG Data Provider library, depending on the business unit which a data provider has been created with.

If not specified, the maximum page size is 100. The default page size is 10. A special _unlimited_ page size is available in some cases to return all entries at once.

## TV services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Editorial medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Soon expiring medias | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ | 100 | ❌ |
| Trending medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 50 | ❌ |
| Latest episodes | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

### Topics

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Topics | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Latest medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Most popular medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ✅ |
| Shows with specific identifiers | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Single show | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Show search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

#### Remark

For SWI, shows represent content categories (Business, Culture, etc.), and search returns only exact word matches.

## Radio services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |

#### Remark

Regional livestreams only exist for SRF, otherwise only main livestreams are available.

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Latest medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |
| Most popular medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |
| Latest episodes | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | 100 | ❌ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| All shows | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ✅ |
| Shows with specific identifiers | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Single show | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |
| Show search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

### Songs

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Recent songs | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ✅ |
| Current song on air | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |

## Live center services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Videos | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ✅ |

## Video services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Single video | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| List of videos | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Video media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Video search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

## Audio services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Single audio | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| List of audios | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Audio media composition | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |N/A | N/A |
| Audio search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

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

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Module list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Latest medias for a module | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

## Tokenization services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| URL tokenization | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |

### Remark

The URL tokenization service is in common to all BUs.
