Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  api vendor_string: 'transfer-money-api', default_version: 1 do
    version 1 do
      cache as: 'v1' do
        resources :carts, only: %i[create show add_product] do
          post :add_product, on: :collection
        end

        resources :products, only: %i[index]
      end
    end
  end
end
