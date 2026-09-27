# Find the template in vendor/dnd-template without installing it, so
# `latexmk book.tex` (and editors that run latexmk) work from this folder.
ensure_path('TEXINPUTS', './vendor/dnd-template');

# XeLaTeX, for Solbera's fonts; `make ENGINE=...` overrides this
$pdf_mode = 5;
