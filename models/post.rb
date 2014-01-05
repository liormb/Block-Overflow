class Post < ActiveRecord::Base
	require 'will_paginate'
	require 'will_paginate/active_record'
	
	belongs_to :user
	has_many   :comments
	has_many   :likes

	# adding post
	def self.add(params)
		post = Post.new
		post.title   = params[:title]
		post.body    = params[:body]
		post.user_id = params[:user_id].to_i
		post.save

		User.find_by_id(post.user_id).posts << post
	end

	# updating post
	def self.update(params)
		post = Post.find(params[:post_id])
		post.title   = params[:title]
		post.body    = params[:body]
		post.save
	end

	# total comments per post
	def self.how_many_comments(id)
		comments = self.find_by_id(id).comments.count
		s = (comments && comments > 1) ? "s" : ""
		comments == 0 ? "No comments" : "#{comments} comment#{s}"
	end

	# deleting all post data (post, comments, post's likes & comment's likes) 
	def self.delete_post(post_id)
		post = self.find(post_id)
		post.likes.delete_all
		post.comments.each { |comment| Like.where('comment_id = ?', comment.post_id).delete_all }
		post.comments.destroy
		post.destroy
	end

	# searching in posts for the user key words and returning matching results
	# if user didn't make a search it will return all posts
	def self.search(params={})
		result = {}
		if params.has_key?('search') && !params[:search].empty?
			result[:key_words] = params[:search].split(",").join(" ").split
			result[:posts] = result[:key_words].map { |word|
				Post.find_by_sql("SELECT * FROM posts WHERE title LIKE '%#{word}%' OR body LIKE '%#{word}%';")
			}.uniq.flatten
		else
			result[:posts] = Post.all
		end
		result[:posts] = result[:posts].sort{|x,y| y.created_at <=> x.created_at }
		return result
	end

	# check if a user like a post: if user like a post return "unlike" as its option else return "like"
	def self.like_status(post, user_id)
		return post.likes.find_by_user_id(user_id).nil? ? "Like" : "Unlike"
	end

	# return the most popular posts id's
	# calculate by number of likes each post has
	def self.popular_posts(num=4)
		sorted_posts = Post.all.map {|post| [post.likes.count, post.id]}.sort {|a,b| b[0] <=> a[0] }
		return sorted_posts.empty? ? [] : sorted_posts.map {|post_id| post_id[1]}[0..(num-1)]
	end

	# return the most updated posts by the updated_at field
	def self.updated_posts(num=4)
		sorted_posts = Post.all.map {|post| [post.updated_at, post.id]}.sort {|a,b| b[0] <=> a[0]}
		return sorted_posts.empty? ? [] : sorted_posts.map {|post_id| post_id[1]}[0..(num-1)]
	end

	# return the most active posts id's
	# calculate by the total of comments AND likes each post has
	def self.active_posts(num=4)
		likes_array = Post.all.map {|post| [post.likes.count, post.id] }
		sorted_posts = likes_array.map {|value| [value[0] + Post.find(value[1]).comments.count, value[1]]}.sort {|a,b| b[0] <=> a[0] }
		return sorted_posts.empty? ? [] : sorted_posts.map {|post_id| post_id[1]}[0..(num-1)]
	end

	# get the created_at / updated_at date in format mm/dd/yy
	def self.full_date(id, get_by="created_at")
		time = get_by == "created_at" ? self.find(id).created_at : self.find(id).updated_at
		return "#{time.month}/#{time.day}/#{time.year}"
	end
end