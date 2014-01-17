class WebhooksController < ApplicationController

  protect_from_forgery with: :null_session

  # POST /webhooks/receive
  def receive
    push = JSON.parse(params[:payload])
    p = Project.where(id: params[:project_id]).take

    unless p
      # Raise a 404 manually so we don't get a helpful HTML response body.
      head :not_found
      return
    end

    bname = push['ref']
    bname.gsub!(%r{^refs/heads/}, '') if bname
    b = p.builds.create! branch: bname

    BuildWorker.perform_async(b.id)

    head :created
  end
end
