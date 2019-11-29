# frozen_string_literal: true

# :nodoc:
class SettingsController < ApplicationController
  def edit
    @settings_form = SettingsForm.from_model(Settings.instance)
  end

  def update
    @settings_form = SettingsForm.from_params(params)

    if @settings_form.save
      redirect_to edit_settings_path
    else
      render :edit
    end
  end
end
