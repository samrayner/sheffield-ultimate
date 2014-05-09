class EventsController < ApplicationController
  def feed
    open("http://dl.dropbox.com/s/5r7ht992dpexnyk/events.json") { |io| render json: io.read }
  end
end
