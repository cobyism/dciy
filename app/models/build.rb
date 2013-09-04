class Build < ActiveRecord::Base
  validates_presence_of :project_id
end
