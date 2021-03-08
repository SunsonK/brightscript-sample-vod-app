sub init()
    m.top.functionName = "getFeed"
    m.port = createObject("roMessagePort")
end sub

' sub getFeed()
'     urlTransfer = createObject("roUrlTransfer")
'     ' urlTransfer.setUrl("http://c4.arm.accedo.tv/develop/matt/feed.json")
'     urlTransfer.setUrl("https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=3f5462d853a29d823ad748c326510f73")
'     m.top.response = urlTransfer.getToString()
' end sub

function getFeed()
    requestApi = sendApi(m.port, "GET", "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=3f5462d853a29d823ad748c326510f73")
 
    while true
        msg = wait(0, m.port)
 
        if type(msg) = "roUrlEvent" then
            if msg.getSourceIdentity() = requestApi.getIdentity() then
                m.top.response = parseJson(msg.getString())
                exit while
            end if
        end if
    end while
end function

function sendApi(port, method, url, headers = {} as object, body = invalid)
    request = createObject("roUrlTransfer")
    request.setUrl(url)
    request.setRequest(method)
    request.setMessagePort(port)
 
    request.setCertificatesFile("common:/certs/ca-bundle.crt")
    request.initClientCertificates()
 
    ' @example - {contentType: ["Content-Type", "application/json"]}
    for each header in headers
        request.addHeader(headers[header][0], headers[header][1])
    end for
 
    if method = "GET" then
        request.asyncGetToString()
    else
        request.asyncPostFromString(body)
    end if
 
    return request
end function