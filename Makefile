rsync:
	rsync -Crltvz --delete \
		--exclude="Makefile" \
		--exclude="*~" \
		--exclude=".svn" \
		--exclude=".*" \
		. blg59@lion.cs.cornell.edu:cucs/web/people/blg59 # ok?

