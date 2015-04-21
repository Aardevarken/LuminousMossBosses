def checkValuesExist(*values):
    return all(value is not None for value in values)

def checkEmptyStrings(*values):
    return all(value != "" for value in values)

def getSQLNoneValue(value):
    return value if value is None else value[0]
