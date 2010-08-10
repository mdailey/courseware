module ReadingsHelper
  
  def bibinfo( reading )
    if reading.authors and reading.title and reading.year
      bibinfo = reading.authors + ', <i>'
      if reading.sales_info_url
        bibinfo += '<a href="' + reading.sales_info_url + '">' + reading.title + '</a>'
      end
      bibinfo += '</i>'
      if reading.edition and reading.edition.length > 0
        bibinfo += ', ' + reading.edition + ' ed. '
      else
        bibinfo += '. '
      end
      if reading.publisher and reading.publisher.length > 0
        bibinfo += ' ' + reading.publisher + ', '
      end
      bibinfo += reading.year.to_s + '. '
      if reading.note and reading.note.length > 0
        bibinfo += reading.note
      end
      bibinfo
    else
      reading.bibinfo
    end
  end
  
  def sort_string( reading )
    if reading.authors
      reading.authors
    elsif reading.bibinfo
      reading.bibinfo
    else
      reading.title
    end
  end
  
  def sorted_readings(readings)
    readings.sort {|r1,r2| sort_string(r1.reading) <=> sort_string(r2.reading)}
  end
  
end
