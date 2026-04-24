# Operational Procedure: Reusable AI-Assisted Paper Workflow (LaTeX + Optional Word)

## 1. Purpose
This procedure defines a repeatable workflow for writing technical research papers in VS Code with:
- LaTeX as the publication format,
- bilingual delivery (English/German),
- optional Word output when required by conferences or journals,
- compatibility with Git-based version control and AI-assisted editing.

## 2. Scope
Use this workflow for any repository where you need one or more papers with:
- structured scientific writing,
- strict formatting templates,
- reproducible build and review process.

## 3. Standard Folder Layout
Use this folder layout inside any target repository:

```text
/docs/paper-latex/
  paper_<topic>_en.tex
  paper_<topic>_de.tex
  sciencepg-template/
    LaTeX-Manuscript_Template.tex
    SciencePGLOGO.pdf
    ...
  OPERATIONAL_PROCEDURE.md
  build/
  export/
```

Guideline:
- Keep publisher template source files unchanged in `sciencepg-template/`.
- Keep your editable manuscript files at `/docs/paper-latex/` root.
- Put generated artifacts only in `build/` and `export/`.

## 4. One-Time Setup Per Repository
1. Copy the portable paper folder (`docs/paper-latex`) into the target repository.
2. Keep both language files from day one (`*_en.tex`, `*_de.tex`) to avoid translation drift later.
3. Install VS Code extension `LaTeX Workshop`.
4. Install local tooling:
   - TeX distribution (TeX Live or MiKTeX)
   - Pandoc (for optional Word export)
5. Add LaTeX build artifacts to `.gitignore`.

## 5. Writing Workflow (Operational Cycle)
1. Draft and revise content in `paper_<topic>_en.tex`.
2. Mirror and adapt meaning (not literal wording) in `paper_<topic>_de.tex`.
3. Use AI for:
   - structure checks,
   - language improvements,
   - consistency checks between EN and DE versions,
   - citation and terminology consistency.
4. Build PDF locally after each major section update.
5. Commit only source changes and intentional assets (no temporary build noise).

## 6. Quality Gates Before Submission
Run these checks before publishing:
1. Build passes without LaTeX errors.
2. References and citations are complete.
3. Figure/table captions are present and referenced in text.
4. EN and DE versions have aligned section logic.
5. Template metadata (author, DOI placeholder, journal line) is updated.

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

## 8. Reuse Strategy Across Repositories
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

## 9. Recommended Operating Model
For your multi-paper, multi-repository, bilingual use case:
1. Create a dedicated repository, e.g. `research-paper-workflow`.
2. Store template files, SOP, and optional helper scripts there.
3. Tag versions (`v1.0.0`, `v1.1.0`) when stable.
4. In each research repository, import a tagged version as a portable folder.
5. Upgrade only when needed, not continuously.

This gives portability plus controlled evolution.

## 10. Minimal Governance Rules
1. Master source is LaTeX.
2. EN and DE are maintained in parallel.
3. Word export is generated, never hand-maintained as primary source.
4. No direct edits to publisher template originals; only to derived manuscript files.
5. Every major update must compile before merge.

## 11. Optional Next Improvements
- Add CI job to compile PDFs on manual dispatch (release remains tag-triggered).
- Add terminology map file for EN/DE consistency (domain-specific glossary).

## 12. Included Utility Files
- DOCX export utility: `scripts/export-paper-docx.ps1`
- Pre-submission QA list: `docs/paper-latex/SUBMISSION_CHECKLIST.md`
