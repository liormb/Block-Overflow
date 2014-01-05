class Like < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	belongs_to :comment

	# adding or deleting post's or comment's likes
	def self.add(params)
		# by checking if comment_id exists it know to where to attach the like to
		# either to the comment or the post 
		if params[:comment_id].nil?
			# like a post
			if Post.find_by_id(params[:post_id].to_i).likes.find_by_user_id(params[:user_id].to_i).nil?
				like = Like.new
				like.user_id = params[:user_id].to_i
				like.post_id = params[:post_id].to_i
				like.save
				Post.find_by_id(like.post_id).likes << like
			else
				Like.where("user_id = ? AND post_id = ?", params[:user_id].to_i, params[:post_id].to_i).destroy_all
			end
		else
			# like a comment
			if Comment.find_by_id(params[:comment_id].to_i).likes.find_by_user_id(params[:user_id].to_i).nil?
				like = Like.new
				like.user_id = params[:user_id].to_i
				like.comment_id = params[:comment_id].to_i
				like.save
				Comment.find_by_id(like.comment_id).likes << like
			else
				Like.where("user_id = ? AND comment_id = ?", params[:user_id].to_i, params[:comment_id].to_i).destroy_all
			end
		end
	end

end