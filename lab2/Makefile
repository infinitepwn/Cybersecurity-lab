LATEXMK ?= latexmk

SOURCE := report.tex
BUILD_DIR := build
DIST_DIR := dist
PDF := $(DIST_DIR)/report.pdf

# Track all included chapter files and local figures so edits rebuild the PDF.
CONTENT_TEX := $(wildcard content/*.tex content/*/*.tex content/*/*/*.tex)
FIGURES := $(wildcard figures/*.png)

.PHONY: all pdf clean distclean

all: pdf

pdf: $(PDF)

$(PDF): $(SOURCE) lab1report.cls references.bib $(CONTENT_TEX) $(FIGURES)
	mkdir -p $(BUILD_DIR) $(DIST_DIR)
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error \
		-outdir=$(BUILD_DIR) $(SOURCE)
	cp $(BUILD_DIR)/report.pdf $(PDF)

clean:
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -rf $(DIST_DIR)
