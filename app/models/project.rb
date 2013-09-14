class Project < ActiveRecord::Base
  has_many :builds

  def workspace_path
    Rails.root.join("workspace", "project-#{self.id}-#{self.repo.gsub(/\//, '-')}")
  end

  def ci_command
    case
    when has_file?('dciy.toml')
      instructions = TOML.load_file(workspace_file 'dciy.toml')
      instructions['dciy']['commands']['cibuild']
    when has_file?('script/cibuild')
      'script/cibuild'
    else
      raise CantFindBuildFile.new
    end
  end

  def repo_uri
    "https://github.com/#{repo}"
  end

  def has_file? filename
    File.exist?(workspace_file filename)
  end

  def workspace_file filename
    File.join(workspace_path, filename)
  end
end

class CantFindBuildFile < RuntimeError ; end
