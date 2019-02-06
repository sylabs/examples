import os
from IPython.lib import passwd

c = c  # pylint:disable=undefined-variable
c.NotebookApp.ip = '0.0.0.0'  # https://github.com/jupyter/notebook/issues/3946
c.NotebookApp.port = int(os.getenv('PORT', 8888))
c.NotebookApp.open_browser = False

# sets a password if PASSWORD is set in the environment
if 'PASSWORD' in os.environ:
  password = os.environ['PASSWORD']
  if password:
    c.NotebookApp.password = passwd(password)
  else:
    c.NotebookApp.password = ''
    c.NotebookApp.token = ''
  del os.environ['PASSWORD']
