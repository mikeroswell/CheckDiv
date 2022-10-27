## This is CheckDiv; the checkplots MS repo

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

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

## <C-F3>Rmd_files/checkplots_MS.Rmd Rmd_files/checkplots_MS.Rmd

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

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
