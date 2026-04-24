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
6. Update README and operational docs so they match the actual trigger behavior.
7. Avoid introducing unrelated changes.

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
- Treat DOCX as generated output for submission systems that require Word.
- Maintain EN/DE versions in parallel to prevent structural drift.
- Workflows are configured to opt JavaScript actions into Node.js 24.
