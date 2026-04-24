# research-paper-workflow

Reusable workflow for technical research papers in VS Code using:
- LaTeX as source of truth,
- bilingual EN/DE manuscript maintenance,
- optional DOCX export via Pandoc,
- AI-assisted review and consistency checks.

## Repository Structure

```text
/docs/paper-latex/
  OPERATIONAL_PROCEDURE.md
  SUBMISSION_CHECKLIST.md
  paper_template_en.tex
  paper_template_de.tex
  sciencepg-template/
/scripts/
  export-paper-docx.ps1
```

## Quick Start

1. Copy this folder structure into any target research repository.
2. Rename template files to your paper topic:
   - `paper_<topic>_en.tex`
   - `paper_<topic>_de.tex`
3. Install dependencies:
   - LaTeX distribution (TeX Live or MiKTeX)
   - Pandoc
4. Export DOCX (optional):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/export-paper-docx.ps1 -PaperBaseName "paper_<topic>" -Language both
```

## Workflow Documents

- Procedure: `docs/paper-latex/OPERATIONAL_PROCEDURE.md`
- QA checklist: `docs/paper-latex/SUBMISSION_CHECKLIST.md`

## CI Build

GitHub Actions workflow `paper-build.yml` runs on version tag push (`v*`) and manual dispatch.

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
- Treat DOCX as generated output for submission systems that require Word.
- Maintain EN/DE versions in parallel to prevent structural drift.
- Workflows are configured to opt JavaScript actions into Node.js 24.
