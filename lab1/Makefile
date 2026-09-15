LATEXMK ?= latexmk

SOURCE := report.tex
BUILD_DIR := build
DIST_DIR := dist
PDF := $(DIST_DIR)/report.pdf

.PHONY: all pdf clean distclean

all: pdf

pdf: $(PDF)

$(PDF): $(SOURCE) lab1report.cls references.bib content/task1.tex content/task2.tex content/task3.tex content/append/JLY/task2.tex content/append/JLY/task3.tex
	powershell -NoProfile -Command "New-Item -ItemType Directory -Force -Path '$(BUILD_DIR)','$(DIST_DIR)' | Out-Null"
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error -outdir=$(BUILD_DIR) $(SOURCE)
	powershell -NoProfile -Command "Copy-Item -LiteralPath '$(BUILD_DIR)/report.pdf' -Destination '$(PDF)' -Force"

clean:
	powershell -NoProfile -Command "if (Test-Path -LiteralPath '$(BUILD_DIR)') { Remove-Item -LiteralPath '$(BUILD_DIR)' -Recurse -Force }"

distclean: clean
	powershell -NoProfile -Command "if (Test-Path -LiteralPath '$(DIST_DIR)') { Remove-Item -LiteralPath '$(DIST_DIR)' -Recurse -Force }"
