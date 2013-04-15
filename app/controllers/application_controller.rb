class ApplicationController < ActionController::Base
  protect_from_forgery
  #helper一般只用于视图中 不过可以通过include语句将它包含进ApplicationControll     er 使得它能用于
  include SessionsHelper
end
