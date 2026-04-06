The rmarkdown workflow is _removing_ a file extension, which is presumably related to why tex gets confused downstream.

But tex does normally find things, and it's not solved by moving the associated pdf. Probably it is making unwarranted directory assumptions?
