
# Author: gabe
# Update: 2015-11-18
# shell command(shift-!): make pdf & make read
# shell command: make clean
# M-x insert-a-tab-for-makefile to insert a tab

# for test

SRC = $(wildcard *.Rmd)


# define a template
latex_template=/Users/gabe/.emacs.d/beamer_template.tex

# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#  For each word in 'name' replace 'string1' with 'string2'
#



PDFS=$(SRC:.Rmd=.pdf)
HTML=$(SRC:.Rmd=.html)
HD=$(SRC:.Rmd=-handout.pdf)

#
# target:  dependency1 dependency2 ...
#     	 command

# create a hddir directory
hdd=hddir

$(hdd): 
	mkdir -p $(hdd)
	cp *.bib $(hdd)

# make commands
all: clean $(PDFS) $(HTML) hd clean

pdf: $(PDFS)

html: $(HTML)

hd: $(hdd) $(hdd)/$(HD)



# rules-----
%.pdf: %.Rmd
	Rscript -e "rmarkdown::render('$<','beamer_presentation')"
	mv $@ $(addsuffix -beamer.pdf,$(basename $@))

$(hdd)/%-handout.pdf: %.Rmd
	cp $< $(hdd)/$(addsuffix -handout.Rmd,$(basename $<))
	perl -pi -w -e 's/----//g;' $(hdd)/$(addsuffix -handout.Rmd,$(basename $<))
	Rscript -e "rmarkdown::render('$(hdd)/$(addsuffix -handout.Rmd,$(basename $<))','pdf_document')"
	mv $(hdd)/$(addsuffix -handout.pdf,$(basename $<)) $(addsuffix -handout.pdf,$(basename $<))


%.html: %.Rmd
	Rscript -e "rmarkdown::render('$<','ioslides_presentation')"
	mv $@ $(addsuffix -ioslides.html,$(basename $@))


# other make commands
read: $(PDFS)
	open $< &

read-html: $(HTML)
	open $<

clean:
	rm -rf *.log *.out *.nav *.aux *.toc *.snm *.bbl *.blg *.tex *.vrb *~ hddir

distclean: clean
	rm -rf *.pdf *.html
