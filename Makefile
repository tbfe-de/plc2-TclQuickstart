TO_READ=\
	presentation-toread.html
DOTDOT_ZIP=\
	../TclQuickstart.zip
DOTDOT_TGZ=\
	../TclQuickstart.tgz

all: $(TO_READ)
	@echo "all printable input updated."

presentation-toread.html: presentation.html
	ex $(@:-toread.html=.html) +'f $@' +'%s/^--\n\n//' +'%s/\n\n--$$//' +wq!

$(DOTDOT_ZIP): $(TO_READ)
	rm -f $@
	zip -r $@ *
$(DOTDOT_TGZ): $(TO_READ)
	rm -f $@
	tar cvzf $@ *

