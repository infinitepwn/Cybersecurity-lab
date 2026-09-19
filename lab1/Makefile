LATEXMK ?= latexmk

SOURCE := report.tex
BUILD_DIR := build
DIST_DIR := dist
PDF := $(DIST_DIR)/report.pdf

.PHONY: all pdf clean distclean

all: pdf

pdf: $(PDF)

$(PDF): $(SOURCE) lab1report.cls references.bib \
	content/task1.tex \
	content/task2.tex \
	content/task3.tex \
	content/append/JLY/task2.tex \
	content/append/JLY/task3.tex
	mkdir -p $(BUILD_DIR) $(DIST_DIR)
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error \
		-outdir=$(BUILD_DIR) $(SOURCE)
	cp $(BUILD_DIR)/report.pdf $(PDF)

clean:
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -rf $(DIST_DIR)