Service availability
====================

Integration Layer services are not available for all business units. The following document describes the availability of all services supported by the SRG Data Provider library, depending on the business unit which a data provider has been created with.

If not specified, the maximum page size is 100. The default page size is 10.

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
| Single media | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| List of medias | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |

### Topics

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Topics | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Latest medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Most popular medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Shows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ✅ |
| Single show | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

#### Remark

For SWI, shows represent content categories (Business, Culture, etc.).

### Media composition

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | N/A | N/A |

### Search

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Media search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |
| Show Search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 100 | ❌ |

#### Remark

SWI currently only returns results for full-word matches.

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
| Single media | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| List of medias | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Shows | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ✅ |
| Single show | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | N/A | N/A |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

### Media composition

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Media composition | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |N/A | N/A |

### Search

| Request | SRF | RTS | RSI | RTR | SWI | Pagination | Maximum page size | Unlimited page size |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Media search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |
| Show Search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | 100 | ❌ |

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
