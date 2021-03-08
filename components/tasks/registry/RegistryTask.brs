sub init()
    m.top.functionName = "onRegistryRequest"
end sub

sub onRegistryRequest()
    request = m.top.request
    RgstManager = RegistryManager(request.key)

    if request.type = "read" then
        value = RgstManager.read(request.key)
        m.top.response = value
    else if request.type = "write" then
        success = RgstManager.write(request.key, request.value)
        m.top.response = success.toStr()
    else if request.type = "delete" then
        success = RgstManager.delete(request.key)
        m.top.response = success.toStr()
    end if
end sub