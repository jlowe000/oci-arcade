import sys
import mimetypes
import oci
import glob

config = oci.config.from_file('~/.oci/config','DEFAULT')

os = oci.object_storage.ObjectStorageClient(config)

namespace = os.get_namespace().data
print(namespace)
bucket = 'oci-arcade'

files = glob.glob(sys.argv[1]+'/**/*.*',recursive=True)
for file in files:
  # Override Javascript types
  mimetype = mimetypes.guess_type(file)[0]
  print(file)
  print(mimetype)
  with open(file, 'rb') as f:
    response = os.put_object(namespace,bucket,file,f,content_type=mimetype)
    print(response)
