# research-paper-workflow

Reusable workflow for technical research papers in VS Code using:
- LaTeX as source of truth,
- bilingual EN/DE manuscript maintenance,
- centralized BibTeX bibliography (copied and synchronized across all papers),
- optional DOCX export via Pandoc,
- AI-assisted review and consistency checks.

## Repository Structure

```text
/bibliography/
  references.bib          ← master BibTeX database (canonical source)
/.vscode/
  settings.json           ← LaTeX Workshop recipe/autobuild defaults
  tasks.json              ← one-click EN/DE build + clean tasks
/docs/paper-latex/
  OPERATIONAL_PROCEDURE.md
  SUBMISSION_CHECKLIST.md
  paper_author_en.tex
  paper_author_de.tex
  publisher_templates/
    README.md             ← placeholder for instantiation-only publisher assets
  build/                  ← generated LaTeX artifacts and PDFs (ignored)
/scripts/
  export-paper-docx.ps1
/BIBLIOGRAPHY_SYNCHRONIZATION.md ← rules for keeping children repos in sync with master
```

Publisher-specific submission templates are intentionally not bundled in this repository. Add them only inside downstream instantiations under `docs/paper-latex/publisher_templates/`.

## Quick Start

1. Copy this folder structure into any target research repository.
2. **Copy** `bibliography/references.bib` into your target repo (do not use git submodules).
3. Start from the lightweight author templates for daily writing:
  - `docs/paper-latex/paper_author_en.tex`
  - `docs/paper-latex/paper_author_de.tex`
4. Add your sources to your local `bibliography/references.bib` copy.
5. Set up your VS Code environment (see [VS Code Setup (Direct LaTeX Authoring)](#vs-code-setup-direct-latex-authoring)).
6. Build your author paper via VS Code tasks or LaTeX Workshop recipe.
7. Periodically synchronize bibliography changes back to the master repo (see [BIBLIOGRAPHY_SYNCHRONIZATION.md](BIBLIOGRAPHY_SYNCHRONIZATION.md)).
8. Export DOCX (optional):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/export-paper-docx.ps1 -PaperBaseName "paper_<topic>" -Language both
```

## VS Code Setup (Direct LaTeX Authoring)

Recommended baseline for new instantiations:

1. Install a TeX distribution (MacTeX/TinyTeX/TeX Live/MiKTeX) and Pandoc.
2. Install extensions:
  - `james-yu.latex-workshop`
  - `streetsidesoftware.code-spell-checker`
  - `adamvoss.vscode-languagetool` (+ optional language packs)
3. Include `.vscode/settings.json` with a `latexmk -xelatex` recipe and auto-build-on-save.
  - Do not hardcode OS-specific PATH entries in `latex-workshop.latex.tools[*].env`.
4. Route outputs to `docs/paper-latex/build` to keep source directories clean.
5. Include `.vscode/tasks.json` with one-click tasks:
  - Build EN author paper
  - Build DE author paper
  - Clean LaTeX artifacts
  - Use cross-platform task commands (`command: latexmk`) and add TinyTeX PATH only under `osx.options.env`.
6. Set `editor.wordWrap` to `on` in the target workspace settings for comfortable prose editing.
7. Keep LaTeX prose formatted with one sentence per line (Sentence-Per-Line) for cleaner diffs and easier review.
8. Ensure `.gitignore` excludes `docs/paper-latex/build/` and LaTeX temporary files.
9. Keep your local `bibliography/references.bib` in sync with the master repo (see [BIBLIOGRAPHY_SYNCHRONIZATION.md](BIBLIOGRAPHY_SYNCHRONIZATION.md)).

This repository already contains the reference workspace configuration.

## Instantiation Prompt (for target repositories)

Use this when you open chat in a target repository and want Copilot to instantiate this workflow with minimal back-and-forth.

```text
Please instantiate the research paper workflow from C:/Users/EORMOHU3W/GitHub_Repositories/research-paper-workflow into this repository.

Scope:
1. Copy and adapt the workflow only as needed for this repo.
2. Keep existing project files and behavior intact.
3. Configure the paper workflow for these manuscript files:
   - Papers/<your_english_paper_file>
   - Papers/<your_german_paper_file>

Required behavior:
1. Prefer direct LaTeX authoring: instantiate `paper_author_en.tex` and `paper_author_de.tex` as working manuscripts.
2. If the target repo needs venue-specific submission assets, place them under `docs/paper-latex/publisher_templates/`; do not add publisher-specific files back to this shared workflow repository.
3. Copy `bibliography/references.bib` from master into the target repo (do NOT use git submodules).
4. For already-instantiated repositories, copy bibliography from master, then switch inline `\bibitem` blocks to BibTeX references.
5. Add `.vscode/settings.json` and `.vscode/tasks.json` for one-click local builds.
6. Enforce artifact hygiene: route local LaTeX outputs to `docs/paper-latex/build` using `latex-workshop.latex.outDir`, `-outdir`, and `-auxdir`.
7. Ensure `.gitignore` excludes LaTeX temporary files and `docs/paper-latex/build/`.
8. Keep VS Code LaTeX config cross-platform: no macOS-only `latex-workshop.latex.tools[*].env.PATH` overrides.
9. Configure `.vscode/tasks.json` with cross-platform `latexmk` commands and add TinyTeX PATH only under `osx.options.env`.
10. Keep `bibliography/references.bib` as a local copy in your repo; maintain synchronization with the master repo per BIBLIOGRAPHY_SYNCHRONIZATION.md.
11. Set `editor.wordWrap` to `on` in `.vscode/settings.json` of the target workspace.
12. Format LaTeX prose using one sentence per line (Sentence-Per-Line) in author manuscripts.
13. Update README and operational docs so they match the actual build procedures.
14. Avoid introducing unrelated changes.

Execution requirements:
1. Implement directly in files (not just propose).
2. Verify LaTeX build works locally (xelatex, latexmk, bibtex).
3. Show a concise summary of changed files and local build verification.

Optional add-on:
If the target repo uses Markdown manuscripts rather than LaTeX sources, adapt the export script accordingly and document that adaptation explicitly.
```

Short form prompt you can use first:

```text
Instantiate the paper workflow from C:/Users/EORMOHU3W/GitHub_Repositories/research-paper-workflow here and follow the Instantiation Prompt checklist from that README.
```

## Centralized Bibliography

All papers share a single BibTeX file at `bibliography/references.bib`. This allows you to build a personal source library that is reusable across papers.

**Adding a source:**

```bibtex
@article{AuthorYear,
  author  = {First Last},
  title   = {Title of the Paper},
  journal = {Journal Name},
  volume  = {1},
  pages   = {1--10},
  year    = {2025}
}
```

**Citing in a paper:**

```latex
As shown by \cite{AuthorYear}, ...
```

Each paper's `.tex` file should use key-only bibliography lookup:

```latex
\bibliographystyle{plainnat}
\bibliography{references}
```

The shared path is resolved in `docs/paper-latex/.latexmkrc` via `BIBINPUTS`, which avoids path issues when `latexmk` runs with `-outdir` and `-auxdir`.

**Language behavior:**
- `paper_*_en.tex` uses `\usepackage[english]{babel}` → heading renders as "References"
- `paper_*_de.tex` uses `\usepackage[ngerman]{babel}` → heading renders as "Literaturverzeichnis"

The `.bib` file itself is language-neutral; the same file serves both.

**Build requirement:** The LaTeX build must run `bibtex` (or `biber`) after the first `pdflatex` pass. This sequence is already configured in `.vscode/tasks.json` and `.latexmkrc`:

## Documentation

- Procedure: `docs/paper-latex/OPERATIONAL_PROCEDURE.md`
- QA checklist: `docs/paper-latex/SUBMISSION_CHECKLIST.md`

## Notes

- Keep LaTeX as the master source.
- Prefer direct authoring in LaTeX (`paper_author_*.tex`) over Markdown-to-LaTeX conversion.
- Treat DOCX as generated output for submission systems that require Word.
- Maintain EN/DE versions in parallel to prevent structural drift.
- Add all sources to `bibliography/references.bib`; never hardcode `\bibitem` entries in individual papers.
- Keep this repository publisher-neutral; add venue-specific templates only inside downstream instantiations under `docs/paper-latex/publisher_templates/`.
- Build and export workflows are local-only (no CI); use VS Code tasks or direct LaTeX commands.
