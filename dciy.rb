Camping.goes :DCIY

module DCIY
  set :views, File.dirname(__FILE__) + '/views'
end

module DCIY::Models
  class Project < Base; end
  class Build < Base; end
end

module DCIY::Controllers
  class Index
    def get
      render :index
    end
  end
end
