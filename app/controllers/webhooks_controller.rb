class WebhooksController < ApplicationController

  # POST /webhooks/receive
  def receive
    push = JSON.parse(params[:payload])

    pname = push.fetch('repository', {})['name']
    p = Project.where(repo: pname).take

    unless p
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
