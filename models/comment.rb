class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	has_many   :likes

	def self.add(params)
		comment = Comment.new
		comment.user_id = params[:user_id].to_i
		comment.post_id = params[:post_id].to_i
		comment.body = params[:body][0..254]
		comment.save

		Post.find_by_id(comment.post_id).comments << comment
	end

	def self.time_ago_in_words(time)
		case time.round
			when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then time.to_i.to_s + ' seconds ago' 
      when 60..119 then 'a minute ago'
      when 120..3599 then (time/(60)).to_i.to_s + ' minutes ago'
      when 3600..7199 then 'an hour ago'
      when 7200..86399 then (time/(60*60)).to_i.to_s + ' hours ago' 
      when 86400..172799 then 'a day ago'
      when 172800..1209599 then (time/(60*60*24)).to_i.to_s + ' days ago'
      when 1209600..2419199 then 'a week ago'
      when 2419200..2678399 then (time/(60*60*24*7)).to_i.to_s + ' weeks ago'
      when 2678400..5356799 then 'a month ago'
      when 5356800..32140799 then (time/(60*60*24*31)).to_i.to_s + ' month ago'
      when 32140800..64281599 then 'a year ago'
      else (time/(60*60*24*365)).to_i.to_s + ' years ago'
		end
	end

	def self.time_passed(comment_id)
		time = (Time.now - self.find_by_id(comment_id).created_at).abs
		self.time_ago_in_words(time)
	end

	def self.delete_comment(id)
		comment = self.find(id)
		comment.likes.destroy
		comment.destroy
	end

	# check if a user like a comment: if user like a comment return "unlike" as its option else return "like"
	def self.like_status(comment, user_id)
		return comment.likes.find_by_user_id(user_id).nil? ? "Like" : "Unlike"
	end
end