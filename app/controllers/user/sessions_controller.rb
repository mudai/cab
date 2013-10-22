class User::SessionsController < ApplicationController
  def new
    @auth_form = User::AuthenticationForm.new
  end

  def create
    @auth_form = User::AuthenticationForm.new(login_params)
    if @auth_form.submit

    else
    end
  end

  private
  # ちゃんと書く
  def login_params
    params
  end
end
