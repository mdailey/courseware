
require 'active_record'

namespace :migrate do

  desc "Copy assignment files to generic document files"
  task :assignment_files => :environment do |t|
    assignments = Assignment.find(:all)
    assignments.each do |a|
      if a.document_file and a.assignment_file
        a.document_file.delete
        a.document_file = nil
      end
      a.document_file = DocumentFile.new unless a.document_file
      if a.assignment_file
        a.document_file.data = a.assignment_file.file_data
      end
      a.save
    end
  end

  desc "Remove assignment files to generic document files"
  task :remove_assignment_files => :environment do |t|
    assignments = Assignment.find(:all)
    assignments.each do |a|
      if a.assignment_file
        a.assignment_file.delete
        a.assignment_file = nil
      end
      a.save
    end
  end
end
