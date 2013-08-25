# Load environment variables from .env
require 'dotenv'
Dotenv.load

Camping.goes :DCIY

module DCIY
  set :views, File.dirname(__FILE__) + '/views'
end

module DCIY::Models
  class Project < Base; end
  class Build < Base; end

  class BasicFields < V 1.0
    def self.up
      create_table Project.table_name do |t|
        t.string :owner
        t.string :repo
        t.timestamps
      end
    end

    def self.down
      drop_table Project.table_name
    end
  end

end

module DCIY::Controllers
  class Index
    def get
      @projects = Project.find(:all)
      render :index
    end
  end

  class Projects
    def get
      render :projects
    end
  end

  class ProjectXX
    def get(owner, repo)
      @project = Project.find_by_owner_and_repo(owner, repo)
      render :project
    end
  end

  class NewProject < R '/projects/new'
    def get
      render :new_project
    end

    def post
      @project = Project.new
      @project.owner = @input.owner
      @project.repo = @input.repo
      @project.save
      redirect ProjectXX, @project.owner, @project.repo
    end
  end

  class DeleteProjectXX
    def get(owner, repo)
      @project = Project.find_by_owner_and_repo(owner, repo)
      @project.destroy!
      redirect Index
    end
  end

end

# Set up the database
def DCIY.create
  DCIY::Models.create_schema
end
