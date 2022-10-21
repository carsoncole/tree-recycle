json.extract! reservation, :id, :name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
