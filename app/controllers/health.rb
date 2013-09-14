Alfred::App.controllers :health do

  get :index do
    content_type:'json'
    { product_version: Version.current }.to_json
  end


end
