# D&D 5e LaTeX book starter

A starting point for one book or adventure made with the [D&D 5e LaTeX template](https://github.com/risadams/DND-5e-LaTeX-Template). Each book lives in its own repository and pins a version of the template, so template updates never surprise a book you are finishing, and the book's art never bloats the template.

`make` turns [`book.tex`](book.tex) into every edition you need to publish:

| File | Edition | For |
| ---- | ------- | --- |
| `book-screen.pdf` | screen | reading on screen and PDF sales: covers, links, bookmarks |
| `book-print.pdf` | print | the print-on-demand interior: bleed, no covers |
| `book-printer-friendly.pdf` | printer-friendly | home printing: light backgrounds and fills |
| `book-cover.pdf` | cover | the print cover spread: back, spine, front |

## Start a book

1. On GitHub, click **Use this template** and create the book's repository.
2. Clone it with the template included, and build the sample book:

   ```sh
   git lfs install        # once per computer, before you add art
   git clone --recurse-submodules https://github.com/<you>/<your-book>.git
   cd <your-book>
   make
   ```

The first `make` downloads Solbera's fonts into `fonts/`. If you cloned without `--recurse-submodules`, `make` fetches the template for you.

You need a TeX distribution (TeX Live 2023 or later, or MiKTeX) with `latexmk`, plus `make`, `curl` and Poppler (`pdfinfo`, `pdffonts`, `pdfimages`) for the checks. On Windows, run `make` from Git Bash. Without `make`, call the template's build script directly:

```sh
texlua vendor/dnd-template/bin/build --engine=xelatex all book.tex
```

## Write

| Path | What goes there |
| ---- | --------------- |
| [`book.tex`](book.tex) | class options, title and metadata, front matter, the list of chapters, back matter |
| [`chapters/`](chapters) | one file per chapter, listed in `book.tex` with `\include` |
| [`cover.tex`](cover.tex) | the print cover spread |
| [`art/`](art), [`maps/`](maps) | print-ready art and maps (Git LFS) |
| `vendor/dnd-template/` | the template, as a git submodule; don't edit it here |

The sample book follows the order of the core books: cover, credits and legal page, contents, chapters, appendices, back cover. Replace the placeholder text, title, credits and art. The samples use the template's own placeholder art from `vendor/dnd-template/examples/art`.

To build only the chapters you are working on, uncomment `\includeonly` in `book.tex` and list them. Page numbers and references to the other chapters are kept from the last full build.

Editors that run `latexmk` (VS Code with LaTeX Workshop, TeXstudio set to latexmk) can build `book.tex` directly: [`latexmkrc`](latexmkrc) points TeX at the template and selects XeLaTeX.

See the [template's README](vendor/dnd-template/README.md) for every command and option, and its example books in `vendor/dnd-template/examples` for stat blocks, spells, class tables, maps and more.

## Build

| Command | Builds |
| ------- | ------ |
| `make` | every edition |
| `make screen` (or `print`, `printer-friendly`, `cover`) | one edition |
| `make preflight` | every edition, then checks each PDF: fonts embedded, images at 300 ppi, bleed, no errors or broken references |
| `make clean` | removes the built files |

Settings go on the command line, e.g. `make print CMYK=1`:

| Setting | Default | |
| ------- | ------- | - |
| `ENGINE` | `xelatex` | `xelatex` or `lualatex` for Solbera's fonts; `pdflatex` if you drop `fonts=solbera` |
| `BLEED` | `0.125in` | bleed for the print interior and cover |
| `SPINE` | `0.25in` | spine width; take it from your print service's cover calculator |
| `CMYK` | off | `CMYK=1` converts print and cover colors to CMYK |
| `PAGE_MULTIPLE` | `1` | number the print interior's page count must be a multiple of, e.g. `4` |
| `OPTIONS` | | more class options for every edition, e.g. `OPTIONS=img=draft` |

Every push builds and checks all editions on GitHub Actions ([`.github/workflows/build.yml`](.github/workflows/build.yml)). Download them from the run's **Artifacts**.

## Art and Git LFS

Print art is large: a full-page image at 300 ppi is often 10 to 50 MB. Committed directly, every version stays in the history forever and clones get slow. This repository stores art with [Git LFS](https://git-lfs.com/) instead: git keeps a small pointer file, and the image downloads only for the commit you check out.

[`.gitattributes`](.gitattributes) sends these to LFS: `png`, `jpg`, `jpeg`, `tif`, `tiff` and `webp` files anywhere, and PDFs in `art/` and `maps/`. Check that a file went to LFS with `git lfs ls-files`.

**Commit exported art, keep layered sources elsewhere.** `art/source/` and `maps/source/` are ignored. Keep `.psd`, `.kra`, `.xcf` and `.dungeondraft_map` files there, backed up to cloud storage, and commit only the exported, print-ready files. Layered sources are several times larger and would use up the LFS quota quickly. To commit them anyway, delete those two lines from `.gitignore`; `.gitattributes` already sends them to LFS.

**Quotas.** As of 2026-09-27, GitHub Free and Pro include 10 GiB of LFS storage and 10 GiB of download bandwidth a month, and bill per GiB beyond that ([GitHub docs](https://docs.github.com/en/billing/concepts/product-billing/git-lfs)). Every version of every image counts toward storage, and downloads by GitHub Actions count toward bandwidth. The workflow caches the art between runs, so a push that changes no art downloads none. Check your usage under **Settings → Billing and plans**.

**Template repositories can't include LFS files**, so this starter has no art of its own. In your book's repository, add art freely.

## Update the template

The template is pinned to one commit, so a book only changes when you update it:

```sh
git submodule update --remote vendor/dnd-template
make preflight
git add vendor/dnd-template
git commit -m "Update the template"
```

Read the template's [CHANGELOG](vendor/dnd-template/CHANGELOG.md) first, and compare a few pages before and after. To go back, check out the previous commit inside `vendor/dnd-template` and commit that.

## Publish

1. Fill in the credits page: every artist, the cartographer, and the license of each piece of art. The template adds the SRD and font attributions for you.
2. Run `make preflight` with your print service's settings, e.g. `make preflight CMYK=1 PAGE_MULTIPLE=4 SPINE=0.31in`, and fix anything it reports.
3. Upload `book-screen.pdf` as the PDF product, and `book-print.pdf` with `book-cover.pdf` for print on demand. Offer `book-printer-friendly.pdf` as an extra download.
4. Tag the release (`git tag v1.0`), so you can rebuild exactly what you sold.

Built PDFs are ignored by git; attach them to a GitHub release to keep them.

## License

Solbera's fonts are licensed [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/): you may sell books typeset with them, but not the fonts themselves. The template is MIT licensed. Your book is yours to license as you like.
