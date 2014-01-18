#BlockOverflow
By [Lior Elrom](http://liormb.com/).

##A Sinatra open sourse social blog application


####Allows a user to post plain text mixed with programming code in many formats.
####BlockOverflow is a social application that allow a user to be social by adding comments and likes to other users posts and comments.

####With BlockOverflow you can write code in many computer's languages:
#####C, C++, Clojure, CSS, Delphi, diff, ERB, Go, Groovy, HAML, HTML, Java, JavaScript, JSON, Lua, PHP, Python, Ruby, Sass, SQL, Taskpaper, XML and YAML

####BlockOverflow allows you to mix any desired code with plain text.

BlockOverflow is combind from 5 models:
* [User](https://github.com/liormb/BlockOverflow/blob/master/models/user.rb): authenticate new and existing user
* [Post](https://github.com/liormb/BlockOverflow/blob/master/models/post.rb): handeling the user's posts
* [Comment](https://github.com/liormb/BlockOverflow/blob/master/models/comment.rb): managing a post's comments placted by  users
* [Like](https://github.com/liormb/BlockOverflow/blob/master/models/like.rb): allowing users to like a post or a comment


##Features
####BlockOverflow is using few features like [Will_Paginate](https://github.com/mislav/will_paginate) that allows to paginate between the pages and [CodeRay](http://coderay.rubychan.de) that gives a different colors and few other features to the code.


##Screenshots

![Example2](/public/images/image2.png)
#####Post whatever you like and share it with others

![Example3](/public/images/image3.png)
#####Add comments to your post or other user's posts

![Example3](/public/images/image4.png)
#####Search for words, code and whatever you like (spaces or commas between the words)

![Example3](/public/images/image5.png)
#####Add new public posts and share it with other users


##Explore BlockOverflow at:
BlockOverflow: http://blogjunky.herokuapp.com

###Other interesting projects:
NewStand: http://newstand.herokuapp.com/
