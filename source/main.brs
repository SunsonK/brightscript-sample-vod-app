sub main(args as Dynamic)
    Screen = createObject("roSGScreen")
    m.Port = createObject("roMessagePort")
    Screen.setMessagePort(m.Port)

    m.Global = Screen.getGlobalNode()
    m.Global.addFields({"stack": []})

    MainScene = Screen.createScene("MainScene")
    MainScene.deeplinkArgs = args
    Screen.show()

    while(true)
        msg = wait(0, m.Port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent" then
            if msg.isScreenClosed() then 
                return
            end if
        end if
    end while
end sub