class BuildsController < ApplicationController
  before_action :set_build, only: [:show, :edit, :update, :destroy]

  # GET /builds
  # GET /builds.json
  def index
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
      @builds = @project.builds
    else
      @builds = Build.all
    end
    @builds = @builds.order("created_at DESC")
  end

  # GET /builds/1
  # GET /builds/1.json
  def show
  end

  # GET /builds/new
  def new
    build_info = { branch: "master" }

    if params[:project_id]
      @project = Project.find params[:project_id]
      build_info[:project_id] = @project
    end

    @build = Build.new build_info
  end

  # POST /builds
  # POST /builds.json
  def create
    @build = Build.new(build_params)

    respond_to do |format|
      if @build.save
        BuildWorker.perform_async(@build.id)
        format.html { redirect_to @build, notice: 'Build was successfully created.' }
        format.json { render action: 'show', status: :created, location: @build }
      else
        format.html { render action: 'new' }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /builds/1
  # DELETE /builds/1.json
  def destroy
    @build.destroy
    respond_to do |format|
      format.html { redirect_to builds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build
      @build = Build.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_params
      params.require(:build).permit(:project_id, :started_at, :completed_at, :successful, :output, :branch)
    end
end
