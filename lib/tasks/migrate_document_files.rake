
require 'active_record'

namespace :migrate do

  desc "Copy handout files to generic document files"
  task :lecture_note_files => :environment do |t|
    lecture_notes = LectureNote.find(:all)
    lecture_notes.each do |a|
      if a.document_file and a.lecture_note_file
        a.document_file.delete
        a.document_file = nil
      end
      a.document_file = DocumentFile.new unless a.document_file
      if a.lecture_note_file
        a.document_file.data = a.lecture_note_file.file_data
      end
      a.save
    end
  end


end
