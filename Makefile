.PHONY: all screen print printer-friendly cover preflight fonts template clean

# The book and its print cover
BOOK ?= book.tex
COVER ?= cover.tex

# xelatex (default, for Solbera's fonts), lualatex or pdflatex
ENGINE ?= xelatex

# Print settings; check your print service's requirements
BLEED ?= 0.125in
SPINE ?= 0.25in
CMYK ?=
PAGE_MULTIPLE ?= 1

# More class options for every edition, e.g. OPTIONS="img=draft"
OPTIONS ?=

TEMPLATE = vendor/dnd-template
FONTS = fonts/solbera/Bookinsanity.otf

BUILD = texlua $(TEMPLATE)/bin/build --engine=$(ENGINE) --bleed=$(BLEED) \
	--spine=$(SPINE) --page-multiple=$(PAGE_MULTIPLE) --cover=$(COVER) \
	$(if $(CMYK),--cmyk) $(if $(OPTIONS),--options=$(OPTIONS))

# Every edition: book-screen.pdf, book-print.pdf, book-printer-friendly.pdf
# and book-cover.pdf
all: template $(FONTS)
	$(BUILD) all $(BOOK)

screen print printer-friendly cover: template $(FONTS)
	$(BUILD) $@ $(BOOK)

# Build every edition and check each PDF before uploading it
preflight: template $(FONTS)
	$(BUILD) --preflight all $(BOOK)

# Download Solbera's fonts (CC BY-SA 4.0) into fonts/solbera
fonts: $(FONTS)

$(FONTS):
	sh $(TEMPLATE)/bin/get-solbera-fonts fonts/solbera

# Fetch the template if the repository was cloned without --recurse-submodules
template:
	@test -f $(TEMPLATE)/bin/build || git submodule update --init

clean:
	rm -f $(foreach e,screen print printer-friendly cover,\
	  $(foreach x,pdf log aux toc out fls fdb_latexmk idx ind ilg lom loh xdv,\
	    $(basename $(BOOK))-$(e).$(x))) chapters/*.aux
