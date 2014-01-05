require 'sinatra/activerecord/rake'
require 'bundler/setup'
Bundler.require(:default)

ActiveRecord::Base.logger = Logger.new(STDOUT)

require_relative './config'
require_relative './models/user'
require_relative './models/post'
require_relative './models/comment'
require_relative './models/like'

namespace :db do 
  desc "Clear the block_overstock database"
  task :clear do
  	#User.delete_all
  	Post.delete_all
  	Comment.delete_all
  	Like.delete_all
  end
end