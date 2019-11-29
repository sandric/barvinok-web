# frozen_string_literal: true

module KeyboardsHelpers
  FIXTURES_DIRECTORY = Rails.root.join('spec/fixtures/barvinok_git')
  GIT_DIRECTORY = Rails.root.join('tmp/fixtures/barvinok_git')

  FIRST_KEYBOARD_NAME = 'test-kbd-1'
  FIRST_KEYBOARD_BRANCH_NAMES = ['branch-1', 'master'].freeze

  SECOND_KEYBOARD_NAME = 'test-kbd-2'
  SECOND_KEYBOARD_BRANCH_NAMES = ['master'].freeze

  STUB_COMMIT_PARAMS = {
    layout: '{"layout-stub": 0}',
    code: 'code-stub',
    svg: '<svg></svg>',
    button_defaults: '{"button-defaults-stub": 0}'
  }

  extend self

  def add_fixture(name)
    FileUtils.copy_entry("#{FIXTURES_DIRECTORY}/#{name}","#{GIT_DIRECTORY}/#{name}")
  end

  def select_fixture(name)
    open("#{GIT_DIRECTORY}/.current-keyboard", 'w') { |f| f << name }
  end

  def add_and_select_fixture(name)
    add_fixture(name)
    select_fixture(name)
  end

  def clear_fixtures
    FileUtils.rm_rf("#{GIT_DIRECTORY}/.")
    FileUtils.touch("#{GIT_DIRECTORY}/.current-keyboard")
  end

  def list_fixtures
    Dir.entries(Settings.instance.git_path).select do |f|
      File.directory?(File.join(Settings.instance.git_path, f)) &&
        !['.', '..'].include?(f)
    end
  end

  def current_fixture_name
    File.read("#{Settings.instance.git_path}/.current-keyboard").rstrip
  end

  def commits_names(keyboard, branch)
    Keyboard.new(keyboard, GIT_DIRECTORY).commits_names(branch)
  end

  def commits_hashes(keyboard, branch)
    Keyboard.new(keyboard, GIT_DIRECTORY).commits_hashes(branch)
  end

  def commits_hashes_compact(keyboard, branch)
    Keyboard
      .new(keyboard, GIT_DIRECTORY)
      .commits_hashes(branch)
      .map { |h| h[0..5] }
  end

  def branches_names(keyboard)
    Keyboard.new(keyboard, GIT_DIRECTORY).branches_names
  end

  def commits_options(page)
    script = "[...document.querySelectorAll('#commits-select-wrapper .choices__item--selectable')].map(c => c.innerText.trim())"
    page.evaluate_script(script).drop(1)
  end

  def branches_options(page)
    script = "[...document.querySelectorAll('#branches-select-wrapper .choices__item--selectable')].map(c => c.innerText.trim())"
    page.evaluate_script(script).drop(1)
  end

  def keyboards_options(page)
    script = "[...document.querySelectorAll('#keyboards-select-wrapper .choices__item--selectable')].map(c => c.innerText.trim())"
    page.evaluate_script(script).drop(1)
  end

  def selected_commit_option(page)
    script = "document.querySelector('#commits-select-wrapper .choices__item--selectable').innerText"
    page.evaluate_script(script)
  end

  def selected_commit_hash_option(page)
    script = "document.querySelector('#commits-select-wrapper .choices__item--selectable').dataset['value']"
    page.evaluate_script(script)
  end

  def selected_commit_hash_option_compact(page)
    selected_commit_hash_option(page)[0..5]
  end

  def selected_branch_option(page)
    script = "document.querySelector('#branches-select-wrapper .choices__item--selectable').innerText"
    page.evaluate_script(script)
  end

  def selected_keyboard_option(page)
    script = "document.querySelector('#keyboards-select-wrapper .choices__item--selectable').innerText"
    page.evaluate_script(script)
  end
end
