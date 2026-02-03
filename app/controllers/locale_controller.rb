class LocaleController < ApplicationController
  def update
    redirect_to request.referer || root_path
  end
end
