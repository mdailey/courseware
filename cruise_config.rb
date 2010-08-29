
# Project-specific configuration for CruiseControl.rb

Project.configure do |project|
  
  # Email for notifications about broken and fixed builds
  project.email_notifier.emails = ['mdailey@ait.ac.th']

  # Set email 'from' field
  project.email_notifier.from = 'mdailey@ait.ac.th'

  # Add metric_fu report to the build
  project.rake_task = 'build:metrics'

  # How often to ping Subversion for new revisions
  project.scheduler.polling_interval = 30.seconds

end
