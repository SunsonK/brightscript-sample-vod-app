sub init()
    m.StckManager = StackManager()
    m.global.observeField("stack", "onStackChange")
end sub

sub handleDeeplinkArgs()
    m.StckManager.push({
        id: "HomeTemplate",
        meta: {}
    })

    deeplinkArgs = m.top.deeplinkArgs
    hasContentId = deeplinkArgs <> invalid and deeplinkArgs.contentId <> invalid

    if hasContentId then
        m.StckManager.push({
            id: "PlayerTemplate",
            meta: deeplinkArgs
        })
    end if
end sub

sub createTemplate(args as Object)
    m.ActiveTemplate = createObject("roSGNode", args.id)
    m.ActiveTemplate.pageArgs = args
    m.top.appendChild(m.ActiveTemplate)
end sub

sub removeTemplate()
    if m.ActiveTemplate <> invalid then
        m.top.removeChild(m.ActiveTemplate)
        m.ActiveTemplate = invalid
    end if
end sub

sub onStackChange()
    removeTemplate()

    args = m.StckManager.peek()
    createTemplate(args)
end sub