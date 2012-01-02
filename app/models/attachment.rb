class Attachment < ActiveRecord::Base
  belongs_to :message

  class FileUploader < CarrierWave::Uploader::Base
    # Include RMagick or ImageScience support:
    include CarrierWave::RMagick
    # include CarrierWave::ImageScience

    # Choose what kind of storage to use for this uploader:
    # storage :file
    storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    # Process files as they are uploaded:
    # process :scale => [200, 300]
    #
    # def scale(width, height)
    #   # do something
    # end
    
    process :convert => :png

    # Create different versions of your uploaded files:
    version :thumb do
      process :resize_to_fill => [300, 300]
    end
    
    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_white_list
      %w(jpg jpeg gif png)
    end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    # def filename
    #   "something.jpg" if original_filename
    # end
  end
  
  mount_uploader :file, FileUploader
  
  def thumb
    file.thumb.url
  end
  
  def url
    file.url
  end
  
  def serializable_hash(options = nil)
    super((options || {}).merge(
      :except  => [:file],
      :methods => [:thumb, :url]
    ))
  end
end