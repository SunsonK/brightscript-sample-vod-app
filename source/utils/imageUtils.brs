function reformatImageUri(imageUri as String) as String
    return imageUri.replace("{&resize}", "&resize=300px:*")
end function