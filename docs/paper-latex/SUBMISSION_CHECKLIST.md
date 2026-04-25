# Submission Checklist (EN/DE Workflow)

## Scope
Use this checklist before submitting either PDF or DOCX versions.

Authoring model:
- Daily writing in `paper_author_en.tex` / `paper_author_de.tex`
- Final venue formatting in `paper_template_en.tex` / `paper_template_de.tex`

## Source Integrity
- [ ] English author source compiles: paper_author_en.tex
- [ ] German author source compiles: paper_author_de.tex
- [ ] If submission-ready, final template files compile: paper_template_en.tex / paper_template_de.tex
- [ ] No unresolved references or citation warnings remain
- [ ] Bibliography is generated via BibTeX from bibliography/references.bib
- [ ] No inline `\bibitem` blocks remain in manuscript files
- [ ] All figures and tables are present and referenced in text

## Metadata Completeness
- [ ] Title, author, affiliation, and corresponding email are updated
- [ ] Journal/conference line is correct for the target venue
- [ ] Date and citation placeholder lines are updated
- [ ] Keywords are aligned with the final abstract

## Bilingual Consistency
- [ ] Section structure is aligned between EN and DE versions
- [ ] Domain terminology is consistent across both versions
- [ ] Acronyms are expanded on first use in both versions
- [ ] Claims, results, and conclusions are equivalent in meaning

## Reproducibility and Versioning
- [ ] VS Code task build passes for EN and DE (or equivalent latexmk commands)
- [ ] Build artifacts are not committed accidentally
- [ ] Source changes are committed with clear message
- [ ] References and data sources are traceable
- [ ] Release/tag planned for submission snapshot

## Word Delivery (If Required)
- [ ] DOCX generated from LaTeX source using the export script
- [ ] DOCX reviewed for template/layout issues
- [ ] Equation, table, and caption formatting verified in Word
- [ ] Final manual cleanup completed for submission platform

## Final Gate
- [ ] Last read-through completed
- [ ] Submission package matches venue requirements
- [ ] Final files archived in a versioned folder or release
