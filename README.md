# research-paper-workflow

Reusable workflow for technical research papers in VS Code using:
- LaTeX as source of truth,
- bilingual EN/DE manuscript maintenance,
- centralized BibTeX bibliography shared across all papers,
- optional DOCX export via Pandoc,
- AI-assisted review and consistency checks.

## Repository Structure

```text
/bibliography/
  references.bib          ← central BibTeX database (shared by all papers)
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
```

Publisher-specific submission templates are intentionally not bundled in this repository. Add them only inside downstream instantiations under `docs/paper-latex/publisher_templates/`.

## Quick Start

If you consume this workflow as a git submodule in another repository, initialize it once from the host repository root:

```bash
git submodule update --init --recursive
```

1. Copy this folder structure into any target research repository.
2. Start from the lightweight author templates for daily writing:
  - `docs/paper-latex/paper_author_en.tex`
  - `docs/paper-latex/paper_author_de.tex`
3. Add your sources to `bibliography/references.bib` (see [Centralized Bibliography](#centralized-bibliography)).
4. Set up your VS Code environment (see [VS Code Setup (Direct LaTeX Authoring)](#vs-code-setup-direct-latex-authoring)).
5. Build your author paper via VS Code tasks or LaTeX Workshop recipe.
6. Export DOCX (optional):

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
6. Add `docs/paper-latex/.latexmkrc` and set `BIBINPUTS` with OS-aware separators so BibTeX resolves the shared bibliography from `build/` runs.

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
1. Build workflow must be manual-dispatch only.
2. Release workflow must run on version tags v* (and manual dispatch allowed).
3. Keep Node 24 opt-in in workflows via FORCE_JAVASCRIPT_ACTIONS_TO_NODE24=true.
4. Include required LaTeX dependencies for CI, including texlive-xetex.
5. Include the local DOCX export script and ensure it resolves paths relative to repo root (not caller working directory).
6. Prefer direct LaTeX authoring: instantiate `paper_author_en.tex` and `paper_author_de.tex` as working manuscripts.
7. If the target repo needs venue-specific submission assets, place them under `docs/paper-latex/publisher_templates/`; do not add publisher-specific files back to this shared workflow repository.
8. Wire centralized bibliography (`bibliography/references.bib`) and update `\bibliography{}` paths in each paper.
9. For already-instantiated repositories, add a `bibliography` symlink or copy, then switch inline `\bibitem` blocks to BibTeX.
10. Add `.vscode/settings.json` and `.vscode/tasks.json` for one-click local builds.
11. Enforce artifact hygiene: route local LaTeX outputs to `docs/paper-latex/build` using `latex-workshop.latex.outDir`, `-outdir`, and `-auxdir`.
12. Ensure `.gitignore` excludes LaTeX temporary files and `docs/paper-latex/build/`.
13. Keep VS Code LaTeX config cross-platform: no macOS-only `latex-workshop.latex.tools[*].env.PATH` overrides.
14. Configure `.vscode/tasks.json` with cross-platform `latexmk` commands and add TinyTeX PATH only under `osx.options.env`.
15. Add `docs/paper-latex/.latexmkrc` with OS-aware `BIBINPUTS` and keep paper files at `\bibliography{references}`.
16. Update README and operational docs so they match the actual trigger behavior.
17. Avoid introducing unrelated changes.

Execution requirements:
1. Implement directly in files (not just propose).
2. Run a validation pass for workflow/script syntax.
3. Show a concise summary of changed files and exact trigger logic.
4. Commit changes with a clear message and push to main only after my confirmation.

Optional add-on:
If this repo uses Markdown manuscripts rather than LaTeX sources, adapt scripts/workflows accordingly and document that adaptation explicitly.
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

**Build requirement:** The LaTeX build must run `bibtex` (or `biber`) after the first `pdflatex` pass:

```bash
pdflatex paper.tex
bibtex paper
pdflatex paper.tex
pdflatex paper.tex
```

CI workflows must include this sequence and have `texlive-bibtex-extra` installed.

## Workflow Documents

- Procedure: `docs/paper-latex/OPERATIONAL_PROCEDURE.md`
- QA checklist: `docs/paper-latex/SUBMISSION_CHECKLIST.md`

## CI Build

GitHub Actions workflow `paper-build.yml` runs on manual dispatch.

- Builds PDF for all `docs/paper-latex/*.tex` files.
- Exports DOCX for all `docs/paper-latex/*.tex` files.
- Publishes artifacts as:
  - `papers-pdf`
  - `papers-docx`

## Release Build

GitHub Actions workflow `paper-release.yml` runs on tag push (`v*`) and can also be run manually.

- Builds PDF and DOCX outputs from all `docs/paper-latex/*.tex` files.
- Packages outputs into release zip assets:
  - `papers-pdf-<tag>.zip`
  - `papers-docx-<tag>.zip`
- Creates or updates the GitHub Release for the tag and uploads the assets.

## Notes

- Keep LaTeX as the master source.
- Prefer direct authoring in LaTeX (`paper_author_*.tex`) over Markdown-to-LaTeX conversion.
- Treat DOCX as generated output for submission systems that require Word.
- Maintain EN/DE versions in parallel to prevent structural drift.
- Add all sources to `bibliography/references.bib`; never hardcode `\bibitem` entries in individual papers.
- Keep this repository publisher-neutral; add venue-specific templates only inside downstream instantiations under `docs/paper-latex/publisher_templates/`.
- Workflows are configured to opt JavaScript actions into Node.js 24.
