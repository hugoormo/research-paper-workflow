# Operational Procedure: Reusable AI-Assisted Paper Workflow (Direct LaTeX + Optional Word)

## 1. Purpose
This procedure defines a repeatable workflow for writing technical research papers in VS Code with:
- direct LaTeX authoring as the primary method,
- bilingual delivery (English/German),
- centralized BibTeX bibliography reuse,
- optional Word output when required by conferences or journals,
- compatibility with Git-based version control and AI-assisted editing.

## 2. Scope
Use this workflow for any repository where you need one or more papers with:
- structured scientific writing,
- strict formatting templates,
- reproducible build and review process,
- low-friction daily authoring in VS Code.

## 3. Standard Folder Layout
Use this folder layout inside any target repository:

```text
/.vscode/
  settings.json
  tasks.json
/bibliography/
  references.bib
/docs/paper-latex/
  paper_author_en.tex
  paper_author_de.tex
  paper_template_en.tex
  paper_template_de.tex
  sciencepg-template/
  OPERATIONAL_PROCEDURE.md
```

Guideline:
- Keep publisher template source files unchanged in `sciencepg-template/`.
- Write daily in `paper_author_en.tex` and `paper_author_de.tex`.
- Use `paper_template_*.tex` only for final submission formatting.
- Keep bibliography centralized in `bibliography/references.bib`.
- Keep all generated LaTeX outputs in `docs/paper-latex/build` (never beside manuscript sources).

## 4. One-Time Setup Per Repository
1. Copy `.vscode`, `bibliography`, and `docs/paper-latex` into the target repository.
2. Keep both language author files from day one (`paper_author_en.tex`, `paper_author_de.tex`) to avoid drift.
3. Install VS Code extensions:
  - `james-yu.latex-workshop`
  - `streetsidesoftware.code-spell-checker`
  - `adamvoss.vscode-languagetool` (+ optional EN/DE language packs)
4. Install local tooling:
  - TeX distribution (MacTeX/TinyTeX/TeX Live/MiKTeX)
  - Pandoc (optional DOCX export)
5. Verify toolchain once:
  - `xelatex`, `latexmk`, `bibtex`, `pandoc`
6. Add LaTeX build artifacts to `.gitignore`.
7. Set output routing as a fixed standard:
  - LaTeX Workshop: `latex-workshop.latex.outDir = %DIR%/build`
  - latexmk task args: `-outdir=build -auxdir=build`

## 5. Writing Workflow (Operational Cycle)
1. Draft and revise content directly in `paper_author_en.tex` or `paper_author_de.tex`.
2. Keep EN and DE in parallel once structure stabilizes.
3. Use AI for:
   - structure checks,
   - language improvements,
   - consistency checks between EN and DE versions,
   - citation and terminology consistency.
4. Add citations during writing from `bibliography/references.bib`.
5. Build PDF locally after each major section update (LaTeX Workshop or VS Code task).
6. At finalization, move content into `paper_template_en.tex` / `paper_template_de.tex` for publisher-specific formatting.
7. Commit only source changes and intentional assets (no temporary build noise).

## 6. Quality Gates Before Submission
Run these checks before publishing:
1. Build passes without LaTeX errors.
2. References and citations are complete.
3. Figure/table captions are present and referenced in text.
4. EN and DE versions have aligned section logic.
5. Template metadata (author, DOI placeholder, journal line) is updated.
6. Bibliography is generated through BibTeX (no inline `\bibitem` in manuscript files).

## 7. Word Conversion Reliability
Short answer: conversion is useful, but not fully lossless for complex journal templates.

### 7.1 Reliability expectation
- High reliability for plain article content (headings, paragraphs, lists, simple tables): good.
- Medium reliability for complex LaTeX layout (custom classes, multicolumn layout, advanced floats): mixed.
- Lower reliability for publisher-specific style macros and fine typography: manual cleanup usually required.

### 7.2 Recommended conversion command
Use the repository script for one-command export:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/export-paper-docx.ps1 -PaperBaseName "paper_FiBO_SysMLv2" -Language both
```

Direct Pandoc call is still possible:

```powershell
pandoc docs/paper-latex/paper_<topic>_en.tex -o docs/paper-latex/export/paper_<topic>_en.docx
```

If needed, add bibliography and CSL options in a second step.

### 7.3 Practical rule
- Write semantically clean LaTeX (clear sections, standard environments).
- Treat DOCX as a delivery format, not the master source.
- Always reserve time for final manual DOCX cleanup.

## 8. VS Code One-Click Build Model
Use repository tasks for consistent local execution:
1. Build EN author paper
2. Build DE author paper
3. Clean LaTeX artifacts

This avoids ad-hoc command drift across repositories and team members.

## 9. Reuse Strategy Across Repositories
You asked whether portable folder is enough or a dedicated repository is better.

### Option A: Portable folder copied manually
Pros:
- Fast to start.
- No extra repository maintenance.

Cons:
- Workflow updates must be copied manually to each repo.
- Version drift between repositories is likely.

### Option B: Dedicated template repository (recommended)
Pros:
- Single source of truth for workflow and templates.
- Versioned releases for stable reuse.
- Easier team onboarding and governance.

Cons:
- One additional repository to maintain.

### Best practice (hybrid)
Use a dedicated repository as the canonical source, and consume it in projects as:
- a copied release bundle (ZIP), or
- a Git submodule/subtree (if you want synchronized updates).

## 10. Recommended Operating Model
For your multi-paper, multi-repository, bilingual use case:
1. Create a dedicated repository, e.g. `research-paper-workflow`.
2. Store template files, SOP, and optional helper scripts there.
3. Tag versions (`v1.0.0`, `v1.1.0`) when stable.
4. In each research repository, import a tagged version as a portable folder.
5. Upgrade only when needed, not continuously.

This gives portability plus controlled evolution.

## 11. Minimal Governance Rules
1. Master source is LaTeX.
2. EN and DE are maintained in parallel.
3. Word export is generated, never hand-maintained as primary source.
4. No direct edits to publisher template originals; only to derived manuscript files.
5. Bibliography is centralized in `bibliography/references.bib`.
6. Every major update must compile before merge.
7. Generated artifacts must be redirected to `docs/paper-latex/build`.

## 12. Upgrading Existing Instantiations
When upgrading repositories that already contain paper files:
1. Add `bibliography/references.bib` (or create a symlink to a shared source).
2. Replace inline `\bibitem` blocks with:
  - `\bibliographystyle{plainnat}`
  - `\bibliography{<relative-path>/references}`
3. Add `.vscode/settings.json` and `.vscode/tasks.json`.
4. Add author templates and keep publisher templates as final-stage files.
5. Run a clean local compile for EN and DE.
6. Normalize local build output location to `docs/paper-latex/build` and remove root-level LaTeX artifacts.

## 13. Optional Next Improvements
- Add CI job to compile PDFs on manual dispatch (release remains tag-triggered).
- Add terminology map file for EN/DE consistency (domain-specific glossary).

## 14. Included Utility Files
- DOCX export utility: `scripts/export-paper-docx.ps1`
- Pre-submission QA list: `docs/paper-latex/SUBMISSION_CHECKLIST.md`
