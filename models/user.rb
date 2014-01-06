class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
	has_many :likes

	# check if user exists and password is currect
	def self.login(params)
		exists = false
		username = params[:username]
		password = params[:password]
		User.all.each { |user| exists = true if user.username == username && user.password == password }
		return exists
	end

	# create new user
	def self.create_new_user(params)
		user = User.new
		user.first_name = params[:first_name].capitalize.strip
		user.last_name  = params[:last_name].capitalize.strip
		user.username   = params[:username].strip
		user.password   = params[:password]

		if !params[:image].nil?
			user.image = '/uploads/' + user.username + '.' + params['image'][:type].match(/\/(.*)$/).captures.first
			# File.open('public' + user.image, "wb") do |f|
			File.open(user.image, "wb") do |f|
		    f.write open(params['image'][:tempfile]).read
		  end
		end

		user.save
	end

	# validate user inputs and register
	def self.register(params)
		if params[:first_name].nil? ||
			 params[:last_name].nil?  || 
			 params[:username].nil?   || 
			 params[:password].nil?   ||
			 params[:password] != params[:conform_password] ||
			 !User.find_by_username(params[:username]).nil? ||
		 	   validation = false
		 else
		 		 # File.size(params[:image][:tempfile]) > 100000 # check for file size
		 	   validation = true
		 	   self.create_new_user(params)
		 end
		return validation
	end

	# return a user full name
	def self.fullname(id)
		return "Anonymous" if id.nil? || self.find_by_id(id).nil?
		self.find_by_id(id).first_name.capitalize + " " + self.find_by_id(id).last_name.capitalize
	end

	# check if user exists (not nil). If it doesn't return full name of the user that created the post/comment
	# if user exists, check if this user wrote that post/comment: yes-> return "You" else return full name
	def self.created_by(user, owner_user_id)
		fullname = self.fullname(owner_user_id)
		return fullname if user.nil?
		user = self.find(user.id)
		return user.id == owner_user_id ? "You" : fullname
	end

	# check if there is a user's image store in the databse
	# if yes, return its path else return the placeholder path
	def self.image(owner_user_id)
		url = self.find(owner_user_id).image
		return url.nil? ? '/images/image_placeholder.jpg' : url
	end
end