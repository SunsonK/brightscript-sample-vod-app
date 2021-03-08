sub init()
    m.ButtonContainer = m.top.findNode("buttonContainer")
    m.ButtonLabel = m.top.findNode("buttonLabel")
    ' m.ButtonLabelFont = m.ButtonLabel.findNode("buttonLabelFont")
    print "here"
end sub

sub onPropertiesChange(message as Object)
    properties = message.getData()

    if properties.width <> invalid then
        m.ButtonContainer.width = properties.width
    end if

    if properties.height <> invalid then
        m.ButtonContainer.height = properties.height
    end if

    if properties.color <> invalid then
        m.ButtonContainer.color = properties.color
    end if

    if properties.opacity <> invalid then
        m.ButtonContainer.opacity = properties.opacity
    end if

    if properties.labelColor <> invalid then
        m.ButtonLabel.color = properties.labelColor
    end if

    if properties.labelText <> invalid then
        m.top.text = properties.labelText
    end if

    ' if properties.labelSize <> invalid then
    '     m.ButtonLabelFont.size = properties.labelSize
    ' end if

    ' positionLabel()
end sub

sub positionLabel()
    containerBounding = m.ButtonContainer.boundingRect()
    labelBounding = m.ButtonLabel.boundingRect()

    labelPositionX = (containerBounding.width - labelBounding.width) / 2
    labelPositionY = (containerBounding.height - labelBounding.height) / 2
    m.ButtonLabel.translation = [labelPositionX, labelPositionY]
end sub

sub onFocusChange(message as Object)
    print "onFocusChange"
    focus = message.getData()
    properties = m.top.properties

    if focus then
        m.top.setFocus(true)
        m.ButtonContainer.color = properties.focusedColor
        m.ButtonLabel.color = properties.labelFocusedColor
    else
        m.top.setFocus(false)
        m.ButtonContainer.color = properties.color
        m.ButtonLabel.color = properties.labelColor
    end if
end sub

sub onKeyEvent(key as String, press as Boolean) as boolean
    print "onKeyEvent"; "Button"
    handled = false
    if press and key = "OK" and m.top.hasFocus() then
        m.top.selected = true
        handled = true
    end if

    return handled
end sub
