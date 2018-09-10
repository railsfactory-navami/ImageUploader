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
      Dir.mkdir("#{Rails.root}/public/" + 'images') unless File.directory?("#{Rails.root}/public/images")
      ext = File.extname(params[:image][:filename])
      if %w( .jpg .jpeg .png).include? ext.downcase
        new_file = File.open("#{Rails.root}/public/images/#{file_name}", "wb") { |f| f.write(params[:image][:tempfile].read) }
        if (FastImage.size("#{Rails.root}/public/images/#{file_name}")[0].between?(350,5000))
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

    desc 'List out all the Images'
    params do
    end

    get '/list' do
      images_list = Dir.glob("public/images/**/*").map { |word| word.gsub('public', '') }
      present :Count, Dir.glob(File.join("#{Rails.root}/public/images", '**', '*')).select { |file| File.file?(file) }.count
      present :images_url, images_list
    end

  end

