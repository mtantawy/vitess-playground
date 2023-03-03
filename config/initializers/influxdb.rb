# frozen_string_literal: true

client = InfluxDB2::Client.new(
  "http://influxdb:8086",
  ENV["INFLUXDB_TOKEN"],
  bucket: "vitess-playground",
  org: "mtantawy",
  precision: InfluxDB2::WritePrecision::NANOSECOND,
  use_ssl: false,
)

write_options = InfluxDB2::WriteOptions.new(
  write_type: InfluxDB2::WriteType::BATCHING,
)
write_api = client.create_write_api(write_options: write_options)

# TODO: move subscribers somewhere else
ActiveSupport::Notifications.subscribe("process_action.action_controller") do |name, started, finished, _id, data|
  hash = {
    name: name,
    tags: {
      method: "#{data[:controller]}##{data[:action]}",
      format: data[:format],
      http_method: data[:method],
      status: data[:status],
      exception: data[:exception]&.first,
    },
    fields: {
      time_in_controller: (finished - started) * 1000, # in ms
      time_in_view: (data[:view_runtime] || 0).ceil, # in ms
      time_in_db: (data[:db_runtime] || 0).ceil, # in ms
    },
    time: started,
  }

  write_api.write(data: hash)
end if Rails.env.production? # TODO: get rid of the redundant check

ActiveSupport::Notifications.subscribe("sql.active_record") do |name, started, finished, _id, data|
  hash = {
    name: name,
    tags: {
      name: data[:name],
      statement_name: data[:statement_name],
      exception: data[:exception]&.first,
    },
    fields: {
      duration: (finished - started) * 1000, # in ms
    },
    time: started,
  }

  write_api.write(data: hash)
end if Rails.env.production? # TODO: get rid of the redundant check

ActiveSupport::Notifications.subscribe("perform.active_job") do |name, started, finished, _id, data|
  hash = {
    name: name,
    tags: {
      job: data[:job].class.to_s,
    },
    fields: {
      duration: (finished - started) * 1000, # in ms
      time_in_db: (data[:db_runtime] || 0).ceil, # in ms
    },
    time: started,
  }

  write_api.write(data: hash)
end if Rails.env.production? # TODO: get rid of the redundant check
