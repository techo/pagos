class GeographiesController < ApplicationController
  def index
    @geographies = PiloteHelper.get_geographies
  end
end
