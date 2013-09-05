class Build < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project_id

  def command
    "script/cibuild"
  end

  def run
    Builder.build(self, Integrity.config.directory, Logger.new(STDOUT))
  end
end
