class ApplicationController < ActionController::Base
  include SimplestAuth::Controller
  protect_from_forgery
end
