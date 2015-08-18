Alfred::App.controllers :health do

  get :index do
    content_type:'json'
    { product_version: Version.current, customizer: "#{Alfred::App.customizer.class.to_s}" }.to_json
  end


end
