Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  api vendor_string: 'grocery-api', default_version: 1 do
    version 1 do
      cache as: 'v1' do

      end
    end
  end
end
