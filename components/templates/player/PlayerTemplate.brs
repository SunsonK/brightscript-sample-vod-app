sub init()
    m.Video = m.top.findNode("video")
    m.Video.observeField("state", "onPlayerStateChange")

    m.VIDEO_HAS_FOCUS = false
end sub

sub onPageArgs()
    ' Would evaluate the page args here and load the desired content..

    VideoContent = createObject("roSGNode", "ContentNode")
    VideoContent.url = "http://amssamples.streaming.mediaservices.windows.net/683f7e47-bd83-4427-b0a3-26a6c4547782/BigBuckBunny.ism/manifest"
    m.Video.content = VideoContent
    m.Video.control = "play"
end sub

sub onPlayerStateChange()
    state = m.Video.state

    if state = "playing" and not m.VIDEO_HAS_FOCUS then
        m.Video.setFocus(true)
        m.VIDEO_HAS_FOCUS = true
    else if state = "finished" or state = "error" then
        goBack()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press and key = "back" then
        goBack()
        handled = true
    end if

    return handled
end function

sub goBack()
    StckManager = StackManager()
    StckManager.pop()
end sub


