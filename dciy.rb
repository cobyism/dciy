Camping.goes :DCIY

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

module DCIY::Views
  def index
    h1 "Boom!"
  end
end
