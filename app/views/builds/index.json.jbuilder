json.array!(@builds) do |build|
  json.extract! build, :project_id, :started_at, :completed_at, :successful, :output
  json.url build_url(build, format: :json)
end
