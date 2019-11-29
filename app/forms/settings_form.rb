class SettingsForm < Rectify::Form
  attribute :git_path, String
  attribute :git_user_name, String
  attribute :git_first_name, String
  attribute :git_last_name, String
  attribute :git_ssh, String

  validates :git_path, presence: true
  validates :git_user_name, presence: true

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    Settings.update(to_h.except(:id))
  end
end
