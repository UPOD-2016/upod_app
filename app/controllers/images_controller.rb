class ImagesController < ApplicationController
  def create
    file = params['attachment']['file']
    hashed_image = Image.md5_from_file(file)
    image = Image.find_by(body_secure_token: hashed_image)
    image = Image.create_from_file(file) if image.nil?
    render json: image.as_json, status: 200
  end
end
