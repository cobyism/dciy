class Project < ActiveRecord::Base
  has_many :builds
end
