class PagesController < ApplicationController
  def home
    @title = 'home t'
  end

  def contact
    @title = 'contact t'
  end

  def about
    @title = 'about t'
  end
end
