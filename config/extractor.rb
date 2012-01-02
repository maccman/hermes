module Extractor extend self
  def extract_handle(str)
    Twitter::Extractor.extract_reply_screen_name(str)
  end
  
  def extract_email(str)
    email = Mail::Address.new(str)
    email.domain && email.address
  end
  
  def parse(str)
    str.split(",").map do |seg| 
      extract_handle(seg) || extract_email(seg)
    end.compact
  end
end