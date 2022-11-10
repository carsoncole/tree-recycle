json.extract! admin_route, :id, :name, :address, :city, :state, :distance, :created_at, :updated_at
json.url admin_route_url(admin_route, format: :json)
