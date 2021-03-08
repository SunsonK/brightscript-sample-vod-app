function isEmptyString(value as Dynamic) as Boolean
    ret = true

    if value <> invalid and isString(value) then
        if len(value.trim()) > 0 then
            ret = false
        end if
    end if

    return ret
end function

function foundInString(str as String, subStr as String) as Boolean
    return str.inStr(subStr) <> -1
end function