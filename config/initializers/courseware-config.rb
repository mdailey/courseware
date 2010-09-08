
# Configuration file for courseware application

# Site prefix
if ENV['RAILS_ENV'] == 'production'
  SITE_PREFIX = 'http://www2.cs.ait.ac.th/~mdailey'
else
  SITE_PREFIX = 'http://localhost:3000'
end

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
SITE_URL = 'http://www2.cs.ait.ac.th/~mdailey/courses'
ADMIN_EMAIL = 'mdailey@ait.ac.th'

ActionMailer::Base.smtp_settings = {
  :address  => "mail.cs.ait.ac.th",
  :port  => 25,
  :domain  => "cs.ait.ac.th"
}

# Javascript to tag on to the end of the page

if ENV['RAILS_ENV'] == 'production'
  LAYOUT_JAVASCRIPT = %Q(<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-5968281-1");
pageTracker._trackPageview();
</script>)
else
  LAYOUT_JAVASCRIPT = ''
end

