class MyCodeRay

	include CodeRay

	# Setting the valid tags
	def self.valid_tags
		["ruby","html","css","haml","java","js","json","php","python","sass","sql","xml","yaml","c","c++","diff"]
	end

	# 1. replacing valid tags to <code>'s tags
	# 2. striping the code and converting it to CodeRay
	def self.coderay_prep(str, tag="ruby", pointer="code")
		open_tag  = "<" + tag + ">"
		close_tag = open_tag.sub("<","</")
		open_pointer  = "<" + pointer + "=" + tag + ">"
		close_pointer = "</" + pointer + ">"

		istart = str.index(open_tag)
		return str.strip if istart.nil?
		
		str = str.sub(open_tag, open_pointer)
		iend = str.index(close_tag)
		code = !iend.nil? ? str[(istart + open_pointer.length + 1)..(iend - 1)] : str[(istart + open_pointer.length + 1)..(str.length)]
		code_strip = code.strip
		str = str.sub(code, code_strip)
		str = str.sub(code_strip, CodeRay.scan(code_strip, tag.to_sym).div(:line_numbers => :table))

		if iend.nil?
			str.insert(str.length, close_pointer)
			return str
		end

		str = str.sub(close_tag, close_pointer)
		iend >= (str.length - 1) ? str.strip : self.coderay_prep(str,tag,pointer)
	end

	# Adding <pre> tags to uncoded text and striping it
	def self.xmp_tags(str, tag="pre", pointer="code", pos=0)
		open_tag  = "<" + tag + ">"
		close_tag = open_tag.sub("<","</")
		open_pointer  = "<" + pointer + "="
		close_pointer = "</" + pointer + ">"

		istart = str.index(open_pointer, pos)

		if istart.nil?
			text = str[pos...(str.length)]
			str.insert(str.length, close_tag) if text.strip != ""
			str.insert(pos, open_tag) if text.strip != ""
			str = str.sub(text, text.strip)
			return str
		elsif istart > 0
			text = str[pos..(istart-1)]
			str.insert(istart, close_tag) if text.strip != ""
			str.insert(pos, open_tag) if text.strip != ""
			str = str.sub(text, text.strip)
		end

		pos = str.index(close_pointer, pos) + close_pointer.length
		pos >= str.length ? str : self.xmp_tags(str,tag,pointer,pos)
	end

	# Removing openning and closing <code> tags from coderay_prep method
	def self.removing_code_tags(str, pointer="code")
		placeholder = "text"
		track_tag = "<" + pointer + "="
		change_html_tags = "<h4 class='table-caption'>" + placeholder + "</h4><div class='first'><div class='second'>"
		close_html_tags  = "</div></div>"
		open_pointer  = "<" + pointer + "="
		close_pointer = "</" + pointer + ">"

		istart = str.index(track_tag)
		return str if istart.nil?

		while !istart.nil?
			iend = str.index(">", istart)
			string = str[istart..iend]
			tag = str[(str.index("=", istart) + 1)..(iend - 1)]
			str = str.sub(string, change_html_tags.sub(placeholder, tag.upcase))
			istart = str.index(track_tag)
		end

		str = str.gsub(close_pointer, close_html_tags)
		return str
	end

	# prepering the user's input to be presented 
	def self.prep(str)
		post = str
		self.valid_tags.each { |tag| post = self.coderay_prep(post,tag) }
		self.removing_code_tags(self.xmp_tags(post))
	end
end