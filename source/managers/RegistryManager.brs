function RegistryManager(section as String) as Object
    return {
        _instance: createObject("roRegistrySection", section),

        read: function(key as String)
            return m._instance.read(key)
        end function,

        write: function(key as String, value as String)
            writeTransaction = m._instance.write(key, value)
            flushTransaction = m._instance.flush()

            return writeTransaction and flushTransaction
        end function,

        delete: function(key as String)
            return m._instance.delete(key)
        end function
    }
end function