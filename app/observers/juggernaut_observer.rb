class JuggernautObserver < ActiveRecord::Observer
  observe :message
    
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
      if record.respond_to?(:same_user?)
        return if record.same_user?
      end
      
      Juggernaut.publish(
        "/observer/#{record.user_id}", 
        type: type, id: record.id, 
        model: record.class.name, record: record
      )
    rescue
    end
end
