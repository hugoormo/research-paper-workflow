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

GitHub Actions workflow `paper-build.yml` runs on push, PR, and manual dispatch.

- Builds PDF for all `docs/paper-latex/*.tex` files.
- Exports DOCX for all `docs/paper-latex/*.tex` files.
- Publishes artifacts as:
  - `papers-pdf`
  - `papers-docx`

## Notes

- Keep LaTeX as the master source.
- Treat DOCX as generated output for submission systems that require Word.
- Maintain EN/DE versions in parallel to prevent structural drift.

## Known CI Warnings

You may see a GitHub Actions warning related to Node.js 20 deprecation during the platform transition period.

- Cause: Some official actions (for example `actions/upload-artifact@v5`) may still run on Node.js 20 internally until a Node.js 24-native action release is published.
- Impact: This is typically a warning only and does not indicate failed paper builds by itself.
- Recommendation: Keep action versions up to date and periodically check for newer major versions of the affected actions.
