require 'grape-swagger'

module ImageUploader
  module V1
    class Base < Grape::API
      version 'v1', using: :path

      mount ImageUploader::V1::Home::Uploads

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
