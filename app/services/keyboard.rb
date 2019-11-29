# frozen_string_literal: true

# :nodoc:
class Keyboard
  attr_reader :name,
              :path,
              :git

  def initialize(name, git_path = nil)
    git_path ||= Settings.instance.git_path

    @name = name
    @path = "#{git_path}/#{name}"
    @git = Git.open(@path, log: Logger.new('/dev/null'))
  end

  def current_branch
    @git.current_branch
  end

  def layout
    JSON.parse(File.read("#{@path}/layout.json"))
  end

  def code
    File.read("#{@path}/code.rb")
  end

  def button_defaults
    JSON.parse(File.read("#{@path}/button_defaults.json"))
  end

  def branch(branch_name)
    @git.branches[branch_name]
  end

  def commits(branch)
    branch = self.branch(branch) if branch.is_a? String

    if branch.name.starts_with?('(HEAD detached')
      @git.log
    else
      branch.gcommit.log
    end
  end

  def commits_names(branch)
    commits(branch).map(&:message)
  end

  def commits_hashes(branch)
    commits(branch).map(&:objectish)
  end

  def branches_names
    git.branches.map(&:name)
  end
end
