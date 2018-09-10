class ImageUploader::V1::Home::Uploads < Grape::API
  include ImageUploader::V1::Defaults
  require 'fastimage'

  resource :uploads do
    desc "upload Image"
    params do
      requires :image, type: File , desc: "Image File"
    end

    post http_codes: [
        [200, 'Ok'],
        [201, 'Created'],
        [422, 'Unprocessable Entity']
    ] do
      file_name = "#{params[:image][:filename]}_#{Time.now.to_i}"
      Dir.mkdir('/home/' + 'images') unless File.directory?('/home/images')
      ext = File.extname(params[:image][:filename])
      binding.pry
      if %w( .jpg .jpeg .png).include? ext.downcase
        new_file = File.open("/home/images/#{file_name}", "wb") { |f| f.write(params[:image][:tempfile].read) }
        if (FastImage.size("/home/images/#{file_name}")[0].between?(350,5000))
          is_image_uploaded = true 
        else
          warning = "Files minimum of 350x350 and a maximum of 5000x5000 size"
        end
      end
      if is_image_uploaded
        status 201
        present :message, "Image Uploaded successfully"
      else
        status 422
        present :message, "Image Format Not Supporting. #{warning}"
      end
      end
    end
  end

