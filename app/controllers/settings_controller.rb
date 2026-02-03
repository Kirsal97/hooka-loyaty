class SettingsController < ApplicationController
  def index
    @reward_threshold = Setting.find_or_initialize_by(key: "reward_threshold")
    @lounge_name = Setting.find_or_initialize_by(key: "lounge_name")
  end

  def update
    @setting = Setting.find_or_initialize_by(key: params[:key])
    if params[:key] == "reward_threshold"
      value = params[:value].to_i
      if params[:value].blank? || value < 1
        return redirect_to settings_path, alert: "Threshold must be at least 1"
      end
    end

    @setting.value = params[:value]
    @setting.description = params[:description]

    if @setting.save
      Rails.cache.delete("setting:#{@setting.key}")
      redirect_to settings_path, notice: "Setting updated"
    else
      redirect_to settings_path, alert: "Failed to update setting"
    end
  end
end
