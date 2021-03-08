function StackManager() as Object

    return {
        _id: "stack",

        _get: function() as Object
            return getGlobalAA().global.getField(m._id)
        end function,

        _set: sub(stack as Object)
            gaa = getGlobalAA()
            gaa.global.setField(m._id, stack)
        end sub,

        push: sub(template as Object)
            stack = m._get()
            stack.push(template)
            m._set(stack)
        end sub,

        pop: function() as Object
            stack = m._get()
            popped = stack.pop()
            m._set(stack)
            return popped
        end function,

        peek: function() as Object
            stack = m._get()
            return stack.peek()
        end function
    }
end function