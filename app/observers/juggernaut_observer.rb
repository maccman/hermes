module JuggernautObserver extend self
  def publish(type, record, options = {})
    data = {
      type: type, 
      id: record.id, 
      model: record.class.name, 
      record: record
    }
    
    Juggernaut.publish(
      "/observer/#{record.user_id}", 
      data,
      options
    )
  rescue Errno::ECONNREFUSED
  end
end
