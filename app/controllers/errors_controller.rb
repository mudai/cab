# -*- coding: utf-8 -*-
#
class ErrorsController < ApplicationController
  # レコードが無い場合にここに飛ばす
  def routing
    render_404
  end
end
