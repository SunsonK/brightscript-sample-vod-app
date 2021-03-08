sub init()
    m.PinPadPopupTitle = m.top.findNode("pinPadPopupTitle")
    m.PinPadPopupTitle.text = "Pin Settings"

    m.PinPadPopupInstructions = m.top.findNode("pinPadPopupInstructions")
    instructionOne = "Using your remote controller, please press up / down to specify a single digit of your pin." 
    instructionTwo = "When happy press right and do this for each digit of your pin."
    instructionThree = "Finally, select confirm to store your pin."
    m.PinPadPopupInstructions.text = instructionOne + chr(10) + instructionTwo + chr(10) + instructionThree

    createPinButtons()
    createConfirmButton()
end sub

sub createPinButtons()
    defaultPinButtonProperties = {
        width: 54,
        height: 96,
        color: "#000000",
        focusedColor: "#ECECEC",
        labelColor: "#ECECEC",
        labelFocusedColor: "#000000",
        labelText: "0",
        labelSize: 27
    }

    m.PinButtonOne = m.top.findNode("pinButtonOne")
    m.PinButtonOne.properties = defaultPinButtonProperties

    m.PinButtonTwo = m.top.findNode("pinButtonTwo")
    m.PinButtonTwo.properties = defaultPinButtonProperties

    m.PinButtonThree = m.top.findNode("pinButtonThree")
    m.PinButtonThree.properties = defaultPinButtonProperties

    m.PinButtonFour = m.top.findNode("pinButtonFour")
    m.PinButtonFour.properties = defaultPinButtonProperties

    m.PinButtonOne.focus = true
    m.FocusedPinButton = m.PinButtonOne
    m.FocusedPinButton.focus = true
end sub

sub createConfirmButton()
    m.ConfirmButton = m.top.findNode("confirmButton")
    m.ConfirmButton.observeField("selected", "onConfirmButtonSelected")
    m.ConfirmButton.properties = {
        width: 249,
        height: 75,
        color: "#000000",
        focusedColor: "#ECECEC",
        labelColor: "#ECECEC",
        labelFocusedColor: "#000000",
        labelText: "Confirm"
    }
end sub

sub onConfirmButtonSelected()
    m.enteredPin = m.PinButtonOne.text + m.PinButtonTwo.text + m.PinButtonThree.text + m.PinButtonFour.text

    if isValidPin(m.enteredPin) then
        if m.top.type = "enable" then
            storePin()
        else
            comparePin()
        end if
    end if
end sub

sub storePin()
    m.RegistryTask = createObject("roSGNode", "RegistryTask")
    m.RegistryTask.request = {
        type: "write",
        key: "pin",
        value: m.enteredPin
    }
    m.RegistryTask.observeField("response", "onPinStored")
    m.RegistryTask.control = "run"
end sub

sub onPinStored(message as Object)
    success = message.getData()

    if success = "true" then
        m.top.close = {pinSuccessfullyEntered: true}
    else
        showErrorMessage()
    end if
end sub

sub comparePin()
    m.RegistryTask = createObject("roSGNode", "RegistryTask")
    m.RegistryTask.request = {
        type: "read",
        key: "pin"
    }
    m.RegistryTask.observeField("response", "onPinRead")
    m.RegistryTask.control = "run"
end sub

sub onPinRead(message as Object)
    storedPin = message.getData()
    
    if m.enteredPin = storedPin then
        if m.top.type = "disable" then
            deletePin()
        else
            m.top.close = {pinSuccessfullyEntered: true}
        end if
    else
        showErrorMessage()
    end if
end sub

sub deletePin()
    m.RegistryTask = createObject("roSGNode", "RegistryTask")
    m.RegistryTask.request = {
        type: "delete",
        key: "pin"
    }
    m.RegistryTask.observeField("response", "onPinDeleted")
    m.RegistryTask.control = "run"
end sub

sub onPinDeleted(message as Object)
    success = message.getData()

    if success = "true" then
        m.top.close = {pinSuccessfullyEntered: true}
    else
        showErrorMessage()
    end if
end sub

function isValidPin(pin as String)
    return Len(pin.trim()) = 4
end function

sub showErrorMessage()
    m.ErrorMessage = m.top.findNode("errorMessage")
    m.ErrorMessage.visible = true
    m.ErrorMessageTimer = createObject("roSGNode", "Timer")
    m.ErrorMessageTimer.observeField("fire", "onErrorMessageTimerFinished")
    m.ErrorMessageTimer.setFields({
        duration: 5,
        repeat: "false",
        control: "start"
    })
end sub

sub onErrorMessageTimerFinished()
    m.ErrorMessage.visible = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press then
        if key = "up" then
            handled = handleKeyUp()
        else if key = "down" then
            handled = handleKeyDown()
        else if key = "right" then
            handled = handleKeyRight()
        else if key = "left" then
            handled = handleKeyLeft()
        else if key = "back" then
            m.top.close = {pinSuccessfullyEntered: false}
            handled = true
        end if
    end if

    return handled
end function

function handleKeyUp() as Boolean
    handled = false

    if m.FocusedPinButton <> invalid then
        value = m.FocusedPinButton.text.toInt()

        if value < 9 then
            value++
            m.FocusedPinButton.text = value.toStr()
        end if
    end if

    return handled
end function

function handleKeyDown() as Boolean
    handled = false

    if m.FocusedPinButton <> invalid then
        value = m.FocusedPinButton.text.toInt()

        if value > 0 then
            value--
            m.FocusedPinButton.text = value.toStr()
        end if
    end if

    return handled
end function

function handleKeyRight() as Boolean
    handled = false

    if m.PinButtonOne.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonTwo
        m.FocusedPinButton.focus = true

        handled = true
    else if m.PinButtonTwo.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonThree
        m.FocusedPinButton.focus = true

        handled = true
    else if m.PinButtonThree.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonFour
        m.FocusedPinButton.focus = true

        handled = true
    else if m.PinButtonFour.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = invalid
        m.ConfirmButton.focus = true

        handled = true
    end if

    return handled
end function

function handleKeyLeft() as Boolean
    handled = false

    if m.PinButtonTwo.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonOne
        m.FocusedPinButton.focus = true

        handled = true
    else if m.PinButtonThree.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonTwo
        m.FocusedPinButton.focus = true

        handled = true
    else if m.PinButtonFour.focus then
        m.FocusedPinButton.focus = false
        m.FocusedPinButton = m.PinButtonThree
        m.FocusedPinButton.focus = true

        handled = true
    else if m.ConfirmButton.focus then
        m.ConfirmButton.focus = false
        m.FocusedPinButton = m.PinButtonFour
        m.FocusedPinButton.focus = true

        handled = true
    end if

    return handled
end function
