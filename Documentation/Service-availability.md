Service availability
====================

Integration Layer services are not available for all business units. The following document describes the availability of all services supported by the SRG Data Provider library, depending on the business unit which a data provider has been created with.

If not specified, the maximum page size is 100.

## TV services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Editorial medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Soon expiring medias | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| Trending medias | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (maximum page size = 50) |
| Latest episodes | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Single media | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| List of medias | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Topics

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Topics | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Latest medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Most popular medias by topic | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Shows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Single show | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#### Remark

For SWI, shows represent content categories (Business, Culture, etc.).

### Media composition

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Media composition | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Search

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Media search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Show Search | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

#### Remark

SWI currently only returns results for full-word matches.

## Radio services

### Channels and livestreams

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Channels | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Single channel | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Livestreams | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

#### Remark

Regional livestreams only exist for SRF, otherwise only main livestreams are available.

### Media and episode retrieval

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Latest medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Most popular medias | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Latest episodes | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ |
| Episodes by date | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Single media | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| List of medias | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Shows

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Shows | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Single show | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Latest episodes for a show | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |

### Media composition

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Media composition | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Search

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Media search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Show Search | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |

## Module services

Modules are collection of medias related to a specific context (e.g. an event).

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| Module list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Latest medias for a module | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Tokenization services

| Request | SRF | RTS | RSI | RTR | SWI | Pagination |
|:-- |:--:|:--:|:--:|:--:|:--:|:--:|
| URL tokenization | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |


### Remark

The URL tokenization service is in common to all BUs.
