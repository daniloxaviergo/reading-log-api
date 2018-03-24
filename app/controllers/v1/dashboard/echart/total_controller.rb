class V1::Dashboard::Echart::TotalController < ApplicationController
  def index
    render json: { controller: 'Echart::TotalController' }
  end
end