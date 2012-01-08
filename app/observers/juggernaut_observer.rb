class JuggernautObserver < ActiveRecord::Observer
  observe :message, :conversation
    
  def after_create(record)
    publish(:create, record)
  end
  
  def after_update(record)
    publish(:update, record)
  end
  
  def after_destroy(record)
    publish(:destroy, record)
  end
  
  protected
    def publish(type, record)
      options = {
        type: type, 
        id: record.id, 
        model: record.class.name, 
        record: record
      }
      
      if record.respond_to?(:client_id)
        options[:except] = record.client_id
      end
      
      Juggernaut.publish(
        "/observer/#{record.user_id}", 
        options
      )
    rescue
    end
end
