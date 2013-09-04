json.array!(@projects) do |project|
  json.extract! project, :repo
  json.url project_url(project, format: :json)
end
