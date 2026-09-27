# Art

Print-ready art for the book: covers, chapter art and illustrations. Everything here is stored with Git LFS (see "Art and Git LFS" in the main README).

- Export at 300 ppi at the size the image is printed. Full-page art and covers need the bleed too (0.125 in on each outer edge by default).
- Use `\includegraphics{art/<name>}` without the extension; the template picks `.pdf`, `.png` or `.jpg`.
- Keep layered sources (`.psd`, `.kra`, `.xcf`) in `art/source/`. That folder is not committed unless you choose to (see the README).
- Record the artist and license of every image; the credits page needs them.
