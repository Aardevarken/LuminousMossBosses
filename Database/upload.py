import os

def save_upload(fieldName, fieldStorage):
  assert fieldStorage.has_key(fieldName)
  fileitem = fieldStorage[fieldName]
  assert fileitem.file
  filepath = os.path.join('/work/pics/pending/uploads', fileitem.filename)
  fout = file(filepath, 'wb')
  while 1:
    chunk = fileitem.file.read(100000)
    if not chunk:
      break
    fout.write(chunk)
    fout.close()
  return filepath
