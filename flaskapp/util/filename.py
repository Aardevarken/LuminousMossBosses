def createUniqueFileName(filename, device):
    string = filename.split('_')
    if string[0] == device and string[1].isdigit():
        string[1] = str(int(string[1]) + 1)

        return "_".join(string)
    else:
        return device + "_0_" + filename
