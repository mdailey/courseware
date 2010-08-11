
# Configuration file for courseware application

# Name of the icon to use in the browser for yor site instead of favicon.ico
ICON_IMAGE = 'aiticon.ico'

# Owner
OWNER_NAME = 'Matthew Dailey'
OWNER_URL = 'http://www.cs.ait.ac.th/~mdailey'
AUTHORSHIP_YEAR = 2004

# Institute info.  Logo should be an image in public/images/.
DEPARTMENT_NAME = 'Computer Science and Information Management'
DEPARTMENT_URL = 'http://www.cs.ait.ac.th'
INSTITUTE_URL = 'http://www.ait.ac.th'
INSTITUTE_LOGO = 'ait-globe.gif'

# Place where static HTML files are placed for inclusion
if ENV['RAILS_ENV'] == 'production'
  STATIC_FILE_PATH = '/home/fidji/mdailey/static'
else
  STATIC_FILE_PATH = '/home/mdailey/static'
end

# Place where book images are stored
if ENV['RAILS_ENV'] == 'production'
  BOOK_IMAGE_URL_PREFIX = '/~mdailey/class/readings'
else
  BOOK_IMAGE_URL_PREFIX = '/images/readings'
end

# ActionMailer constants
SITE_URL = 'localhost:3000'
ADMIN_EMAIL = 'mdailey@ait.ac.th'

