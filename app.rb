require 'bundler/setup'
Bundler.require(:default)

require "open-uri"
require 'will_paginate/array'

require_relative './config'
require_relative './models/mycoderay'
require_relative './models/user'
require_relative './models/post'
require_relative './models/comment'
require_relative './models/like'

enable :sessions

# do for each page
before do
	@user = User.find_by_username(session[:username]) if session[:username]
	@aside = erb :aside, :layout => false
end

# main page
get '/' do
  search_posts = Post.search(params)
  @posts = search_posts[:posts].paginate(:page => params[:page], :per_page => 4)
  @key_words = search_posts[:key_words] if search_posts[:key_words]
  erb :index
end

# login
get '/users/login' do
	@login_page = erb :login, :layout => false
	@posts = Post.all.sort{|x,y| y.created_at <=> x.created_at }.paginate(:page => params[:page], :per_page => 4)
	erb :index
end

post '/users/login' do
	session[:username] = params[:username] if User.login(params)
	redirect "/"
end

# register new user
get '/users/register' do
	@register_page = erb :register, :layout => false
	@posts = Post.all.sort{|x,y| y.created_at <=> x.created_at }.paginate(:page => params[:page], :per_page => 4)
	erb :index
end

post '/users/register' do
	session[:username] = params[:username] if User.register(params)
	redirect "/"
end

# logout
get '/users/logout' do
	session[:username] = nil
	redirect "/"
end

# add new post
get "/post/add" do
	erb :add_post
end

post "/posts/add" do
	Post.add(params)
	redirect "/"
end

# view existing post (post_id)
get "/posts/view/:post_id" do
	@post = Post.find_by_id(params[:post_id])
	erb :view_post
end

# edit a post
get "/posts/edit/:post_id" do
	@post = Post.find(params[:post_id])
	erb :edit_post
end

post "/posts/edit/:post_id" do
	Post.update(params)
	redirect "/"
end

# delete a post
get "/posts/delete/:post_id" do
	Post.delete_post(params[:post_id])
	redirect "/"
end

# add a comment to a post
post '/comments/add' do
	Comment.add(params)
	redirect "/posts/view/#{params[:post_id]}"
end

# delete a comment
get "/comments/delete/:comment_id" do
	post_id = Comment.find(params[:comment_id]).post_id
	Comment.delete_comment(params[:comment_id])
	redirect "/posts/view/#{post_id}"
end

# like a post or comment
post '/likes/add' do
	Like.add(params)
	redirect "/posts/view/#{params[:post_id]}"
end