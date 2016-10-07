Getting started
===============

At its core, the SRG Data Provider library reduces to a single data provider class, `SRGDataProvider`, which you instantiate for a business unit and a web service base URL, for example:

```objective-c
NSURL *serviceURL = ...;
SRGDataProvider *dataProvider = [[SRGDataProvider alloc] initWithServiceURL:serviceURL businessUnitIdentifier:SRGDataProviderBusinessUnitIdentifierRTS];
```

You can have several data providers in an application, for example if you want to gather data from different business units. In general, though, most applications should only need a single data provider. To make it easier to access this instance widely in your application, the `SRGDataProvider` class provides class methods to set it as shared instance:

```objective-c
[SRGDataProvider setCurrentDataProvider:dataProvider];
```

and to retrieve it from anywhere, for example when creating a request:

```objective-c
SRGRequest *request = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:...];
```

For simplicity, this getting started guide assumes that a shared data provider has been set. If you cannot use the shared instance, store the data providers you instantiated somewhere and provide access to them in some way.

## Requesting data

To request data, use the methods available from the `SRGDataProvider (Services)` category. For example, to get the list of editorially picked videos from the shared data provider, simply call:

```objective-c
SRGRequest *request = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
    if (error) {
    	// Deal with the error
    	return;
    }
    
    // Proceed further, e.g. display the medias
}];
[request resume];
```

All request methods return an `SRGRequest` object, which can be used to manage their lifecycle. Note that a request is not started initially, you must call `-resume` to start it when required. You can also `-cancel` requests before they finish. This is especially useful when you manage requests at the view controller level and you want to cancel the request when the view controller gets dismissed.

When a request ends, the corresponding completion block is called, with the returned data or error information. Note that the completion block of a cancelled request will not be called.

### Remark

The library was not designed to be thread-safe. Though data retrieval occurs asynchronously, requests are expected to be started from the main thread. Accordingly, completion blocks are guaranteed to be executed on the main thread as well.

## Grouping requests

You often need to perform related requests as a single batch. To make this process as straightforward as possible, the SRG data provider library supplies an `SRGRequestQueue` utility class.

A request queue is group of requests which is considered to be running when at least one request in it is running. When toggling between running and non-running states, the queue calls an optional block, which makes it possible to treat the queue as if it were a request itself.

Requests can be added at any time to an existing queue, whose state will be immediately updated accordingly. If errors are encountered along the way, requests can report errors to the queue, so that these errors can be consolidated and reported once.

### Creating a request queue

Creating a request queue is easy:

```objective-c
SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
	if (finished) {
		// Called when the queue changes from runnning to non-running states
	}
	else {
		// Called when the queue changes from non-running to running state
	}
}];
```

An optional state change block can be provided. This state change block can be used to update the user interface appropriately, e.g. to display a spinner while the queue is running, or to reload a table of results once the queue finishes.

Once you have a queue, you can add requests to it at any time. In general, requests will be added in parallel or in cascade. 

### Parallel requests

When a request does not depend on the result of another request (e.g. requesting editorial and trending videos at the same time), you can instantiate both requests at the same level and add them to a common queue by calling `-addRequest:resume:`:

```objective-c
SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
	if (finished) {
		// Proceed with the results, e.g. use self.editorialVideos and self.trendingVideos to 
		// reload a table or collection view. If errors have been reported to the queue, they 
		// will be available here
	}
	else {
		// For example, display a spinning wheel
	}
}];

SRGRequest *editorialRequest = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
	// Report errors to the queue
	[requestQueue reportError:error];
	
	// Do something with the results, e.g. store them for later retrieval
	self.editorialVideos = medias;
}];
[requestQueue addRequest:editorialRequest resume:YES];

SRGRequest *trendingRequest = [[SRGDataProvider currentDataProvider] trendingVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
	// Report errors to the queue
	[requestQueue reportError:error];
	
	// Do something with the results, e.g. store them for later retrieval
	self.trendingVideos = medias;
}];
[requestQueue addRequest:trendingRequest resume:YES];
```

When adding requests, you can have them automatically started by setting the `resume` parameter to `YES`. If you set it to `NO`, you can still start the queue later by calling `-resume` on it.

Each individual request completion block might receive an error. To propagate such errors to the queue, both completion block implementations above call `-reportError:` on the queue. You do not need to check whether the error to be reported is `nil` or not (if error is `nil`, no error will be reported to the queue). Once the queue completes, the consolidated error information, built from all errors reported to the queue when it was running, will be available.

### Cascading requests

When a request depends on the result of another request, you can still use requests to bind the requests together. For example, if you want to retrieve the media composition corresponding to the first editorial video, you must nest requests since getting the media composition requires knowledge of the first media identifier:

```objective-c
SRGRequestQueue *requestQueue = [[SRGRequestQueue alloc] initWithStateChangeBlock:^(BOOL finished, NSError * _Nullable error) {
	// ...
}];

SRGRequest *editorialRequest = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
	if (error) {
		[requestQueue reportError:error];
		return;
	}
		
	SRGMedia *firstMedia = medias.firstObject;
	SRGRequest *mediaCompositionRequest = [[SRGDataProvider currentDataProvider] mediaCompositionForVideoWithUid:firstMedia.uid completionBlock:^(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error) {
		if (error) {
			[requestQueue reportError:error];
			return;
		}
		
		// Do something with the composition
	}];
	[requestQueue addRequest:mediaCompositionRequest resume:YES];
}];
[requestQueue addRequest:editorialRequest resume:YES];
```

## Pagination

Pagination is a way to retrieve results in pages of constrained size, e.g. 20 items at most per page. All requests which provide a `nextPage` parameter in their completion block support pagination.

When contacting a service supporting pagination but without specifying a page size, results are still returned in page since the server works with a default page size. This default page size can be overridden by clients when they perform their requests.

### Setting the page size

When creating a request, call the `-withPageSize:` to override the page size value:

```objective-c
SRGRequest *request = [[[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:...] withPageSize:10];
```

Then start the request as usual.

### Getting more pages of content

When another page of content is available, the request completion block returns a non-`nil` value as `nextPage`, which you can use to generate the corresponding query from the original request.

Usually, you do not want to perform the request for the next page immediately from the first request completion block, but wait until an appropriate time, e.g. when the user has scrolled through the results of the first page. One way is to store the next page information:

```objective-c
self.request = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
	// Deal with objects and errors
	// ...
	
	self.nextPage = nextPage;	
}];
```

and to use it later when needed:

```objective-c
- (void)loadMore
{
	if (self.nextPage) {
		self.request = [self.request atPage:self.nextPage];
		[self.request resume];
	}
}
```

Another possibility would be not to store the page information, but rather to generate the new request directly:

```objective-c
self.request = [[SRGDataProvider currentDataProvider] editorialVideosWithCompletionBlock:^(NSArray<SRGMedia *> * _Nullable medias, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
	// Deal with objects and errors
	// ...
	
	if (nextPage) {
		self.request = [self.request atPage:nextPage];
	}	
	else {
		self.request = nil;
	}
}];
```

to call it later:

```objective-c
- (void)loadMore
{
    [self.request resume];
}
```

It is not possible to create page objects directly, i.e. there is no way to ask for the `N`th page of content. The reason is that services do not support random access for pages, but merely work in a linked list fashion. To go through the list of available pages, you must therefore start from the first page and follow the links to next pages as returned by the server.

## Token

To play media URLs received in `SRGMediaComposition` objects, you need to retrieve a token, otherwise you will receive an unauthorized error. A special class method is provided on `SRGDataProvider` for this very special purpose:

```objective-c
NSURL *mediaURL = ...;   // For example retrieved from an `SRGMediaComposition`
[[SRGDataProvider tokenizeURL:mediaURL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
    // Play the URL with a media player
}] resume];
```
