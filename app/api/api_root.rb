class ApiRoot < Grape::API
  mount V1::Root
end
