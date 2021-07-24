#[
    Author: Roger Johnston, Twitter: @VV_X_7
    License: Apache License 2.0

    References:
        - Original code by krisppurg, GitHub: https://github.com/krisppurg/dimscord
]#

import httpclient, asyncdispatch
import ../objects, ../constants
import tables, times, strutils

var
    fatalErr = true
    invalid_requests = 0

proc `<=`(x, y: HttpCode): bool =
    result = x.int <= y.int

proc request*(api: RestAPI, meth, endpoint: string, pl = "";
            mp: MultipartData = nil): Future[string] {.async.} =
    if endpoint notin api.endpoints:
        api.endpoints[endpoint] = RequestStatus()

    var
        data: string
        error = ""

    let r = api.endpoints[endpoint]
    while r.processing:
        poll()

    proc doreq() {.async.} =
        let
            client = newAsyncHttpClient(libagent)
            url = api.url & ":" & api.port & endpoint

        var resp: AsyncResponse

        client.headers["Authorization"] = api.token
        client.headers["Content-Type"] = "application/json"
        client.headers["Content-Length"] = $pl.len

        try:
            if mp == nil:
                resp = await client.request(url, meth, pl)
            else:
                resp = await client.post(url, pl, mp)
        except:
            r.processing = false
            raise newException(Exception, getCurrentExceptionMsg())

        let
            status = resp.code
            fin = "[" & $status.int & "] "

        if status >= Http300:
            error = fin & "Client error."

            if status != Http429: r.processing = false

            if status.is4xx:
                if resp.headers["content-type"] == "application/json":
                    let body = resp.body

                    if not (await withTimeout(body, 60_000)):
                        raise newException(RestError,
                            "Body took too long to parse.")
                    else:
                        data = await body

                case status:
                of Http400:
                    error = fin & "Bad request."
                of Http401:
                    error = fin & "Invalid authorization."
                    invalid_requests += 1
                of Http403:
                    error = fin & "Missing permissions/access."
                    invalid_requests += 1
                of Http404:
                    error = fin & "Not found."
                of Http429:
                    fatalErr = false

                    invalid_requests += 1

                    error = fin & "You are being rate-limited."

                    let retry = 2
                    await sleepAsync retry

                    await doreq()
                else:
                    error = fin & "Unknown error"

            if status.is5xx:
                error = fin & "Internal Server Error."
                if status == Http503:
                    error = fin & "Service Unavailable."
                elif status == Http504:
                    error = fin & "Gateway timed out."
                
                echo await resp.body

            if fatalErr:
                raise newException(RestError, error)
            else:
                echo error

        if status.is2xx:
            if resp.headers["Content-Type"] == "application/json; charset=utf-8":
                log("Awaiting for body to be parsed")
                let body = resp.body

                if not (await withTimeout(body, 60_000)):
                    raise newException(RestError,
                        "Body took too long to parse.")
                else:
                    data = await body
            else:
                data = ""

            if invalid_requests > 0: invalid_requests -= 250

        r.processing = false
    try:
        r.processing = true
        await doreq()
        log("Request has finished.")

        result = data
    except:
        var err = getCurrentExceptionMsg()

        if error != "":
            err = error

        if fatalErr:
            raise newException(RestError, err)
