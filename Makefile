## This is CheckDiv; the checkplots MS repo
https://mikeroswell.github.io/CheckDiv/checkplots_MS.html

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += README.md notes.md

## figures/ LICENSE Makefile README.md Rmd_files/

## Commands for setup (you can customize)
## mkdir ~/Dropbox/CheckDiv ##
## ln -s ~/Dropbox/CheckDiv drop ##

Sources += $(wildcard *.R)

## An example of how make might save and read a giant file (giantProgram.rds)
Ignore += drop
drop/giantProgram.Rout: giantProgram.R
	$(pipeR)

newProgram.Rout: drop/giantProgram.rds newProgram.R
	$(pipeR)

## This does not work because of file-reference problems! notes.md
## html seems ok for now, though
Rmd_files/checkplots_MS.pdf: Rmd_files/checkplots_MS.Rmd
	$(rmdp_r)

## This has slugplots and talks about diversity
Rmd_files/checkplots_MS.html: Rmd_files/checkplots_MS.Rmd
	$(rmdh_r)

## This is the piano plots and talks about random sampling across ties for discrete distributions
Rmd_files/checkPlot_notes.html: Rmd_files/checkPlot_notes.Rmd
	$(rmdh_r)

######################################################################

### Makestuff

Sources += Makefile

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

## Want to chain and make makestuff if it doesn't exist
## Compress this ¶ to choose default makestuff route
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/rmd.mk
-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
