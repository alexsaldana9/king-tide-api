module TestUtils
  def test_image(filename='test_image_1.jpg', content_type='image/jpeg')
    return Rack::Test::UploadedFile.new("spec/fixtures/files/#{filename}", content_type)
  end
end