if ActiveRecord::Base.connection_config[:adapter] === "sqlite3"
  Groupdate.time_zone = false
end