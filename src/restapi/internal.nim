
#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0
]#

import asyncdispatch, jsony, requests
import ../objects

proc getInternalSettings*(api: RestApi): Future[InternalSettings] {.async.} =
    ## Returns internal configuration data.
    ## 
    result = (await api.request("GET", "/internal/config/settings")).fromJson(InternalSettings)

proc updateInternalSettings*(api: RestApi, data: InternalSettings): Future[string] {.async.} =
    ## Updates the internal configuration data.
    ## 
    result = await api.request("POST", "/internal/config/settings", data.toJson())

proc getInternalGlobalRedirectors*(api: RestApi): Future[Redirector] {.async.} =
    ## Returns internal global redirectors.
    ## 
    result = (await api.request("GET", "/internal/global/redirectors")).fromJson(Redirector)

proc getInternalGlobalFacts*(api: RestApi): Future[seq[seq[Fact]]] {.async.} =
    ## Returns internal global redirectors.
    ## 
    result = (await api.request("GET", "/internal/global/facts")).fromJson(seq[seq[Fact]])

