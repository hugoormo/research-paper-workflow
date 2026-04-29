# Bibliography Synchronization Guide

**This document enforces the bibliography management strategy for all papers instantiated from `research-paper-workflow`.**

## Overview

The `research-paper-workflow` master repository contains a canonical bibliography at `docs/paper-latex/references.bib`. When you instantiate this workflow into a child repository (e.g., a specific paper project), you **copy** the bibliography rather than using a git submodule.

This approach:
- ✅ Simplifies setup (no submodule complexity)
- ✅ Works across multiple machines (macOS, Windows) without sync issues
- ✅ Allows independent iteration within child repos
- ✅ Requires disciplined synchronization to prevent divergence

## Rules for Child Repositories

Every child repository (paper project) must follow these rules:

### 1. Initial Setup
- Copy `docs/paper-latex/references.bib` from master repo into your `docs/paper-latex/` folder.
- Your local copy is **independent** from the master; it's NOT a submodule or symlink.
- Include `docs/paper-latex/references.bib` in your child repo's version control.

### 2. Daily Work
- Add bibliography entries freely to your local `docs/paper-latex/references.bib` as needed.
- Build and test locally; no coordination needed.
- Commit your local bibliography changes with your paper changes.

### 3. Synchronization Discipline
You are responsible for keeping your bibliography in sync. Follow this workflow:

#### **Before You Start Work on a New Paper:**
```bash
# In your child repository, pull the latest master bibliography
cd master-workflow-repo
git pull origin main

# Copy the latest bibliography into your paper repo
cp docs/paper-latex/references.bib /path/to/paper-repo/docs/paper-latex/
```

#### **When You've Added Entries to the Bibliography:**
1. Finish your paper work in the child repo.
2. Create a feature branch for the new bibliography entries:
   ```bash
   cd master-workflow-repo
   git checkout -b feat/add-references-<topic>
   ```
3. Copy your child repo's bibliography into the master:
   ```bash
   cp /path/to/paper-repo/docs/paper-latex/references.bib docs/paper-latex/
   ```
4. Review the diff:
   ```bash
   git diff docs/paper-latex/references.bib
   ```
5. Commit and push:
   ```bash
   git add docs/paper-latex/references.bib
   git commit -m "Add bibliography entries from <paper-topic>"
   git push origin feat/add-references-<topic>
   ```
6. Create a pull request against `main` in the master workflow repo.
7. Once merged, pull the master repo in all your child repos:
   ```bash
   cd paper-repo
   git pull origin-master-workflow main  # or however you track it
   cp master-repo/docs/paper-latex/references.bib docs/paper-latex/
   ```

### 4. Conflict Prevention
- **Do not edit the same reference key differently** across child repos before syncing.
- **Do not manually merge bibliography changes** without understanding BibTeX format.
- If you discover divergence, the rule is: **master wins** (pull from master and discard local additions until you can merge them back).
- To check for divergence: `diff docs/paper-latex/references.bib /path/to/master-repo/docs/paper-latex/references.bib`

### 5. Multi-Machine Workflow
If you work on macOS and Windows:
1. Before switching machines, **push your child repo changes**.
2. On the new machine, **pull the latest bibliography from master**.
3. Copy it into your child repo: `cp master/docs/paper-latex/references.bib child/docs/paper-latex/`
4. Continue work.

This prevents the "which machine has the latest entries?" problem.

## Master Repository Responsibilities

The master `research-paper-workflow` repo maintains these standards:

1. **Canonical source**: `docs/paper-latex/references.bib` is the single source of truth.
2. **Quality gates**: Review all incoming bibliography PRs for:
   - Valid BibTeX syntax (run `bibtex` locally to verify)
   - No duplicate keys
   - Consistent citation style and field names
   - Clear, unique keys (e.g., `AuthorYear` or `AuthorYearTitle`)
3. **Changelog**: Consider maintaining a brief summary of major additions per version/tag.

## Troubleshooting

### "My bibliography is out of sync with master"
**Solution:**
```bash
# Pull latest master
cd master-repo && git pull origin main

# Copy master bibliography to child
cp master-repo/docs/paper-latex/references.bib child-repo/docs/paper-latex/

# Commit in child repo
cd child-repo
git add docs/paper-latex/references.bib
git commit -m "Sync bibliography with master"
```

### "I added entries in two different child repos and now there are conflicts"
**Solution:**
1. Identify the unique entries in each repo.
2. Manually merge them into a single `references.bib`.
3. Test with BibTeX: `bibtex test` (create a minimal `.tex` file that calls `\bibliography{references}`).
4. Commit the merged version.
5. Push back to master for other repos to pull.

### "I accidentally committed my local bibliography to master"
**Don't panic.** It likely contains the same entries anyway. Check:
```bash
diff master-repo/docs/paper-latex/references.bib my-local-copy/docs/paper-latex/references.bib
```
If identical, no action needed. If different, follow the merge procedure above.

## Best Practices

1. **Sync frequently**: Pull from master at the start of each new paper or major milestone.
2. **Batch updates**: Add multiple bibliography entries in one child repo, then push them all to master at once.
3. **Use unique keys**: Adopt a consistent naming scheme (e.g., `SmithEtAl2020Machine` for multi-author, `Jones1995` for single).
4. **Test locally**: After adding entries, always run `latexmk` or `bibtex` to ensure valid syntax.
5. **Document additions**: In your PR to master, describe what the new entries are for (journal focus, topic area, etc.).

## Summary

| Aspect | Master Repo | Child Repo |
|--------|------------|-----------|
| **Bibliography ownership** | Canonical source | Local copy |
| **Add entries** | Via PR from child repos | Freely, then push back |
| **Synchronization** | Accept PRs; merge carefully | Pull regularly; push additions |
| **Multi-machine** | N/A | Pull from master on each machine |
| **Conflict resolution** | Merge PRs manually | Pull master, never force-push |

---

**Last updated:** April 2026  
**Applies to:** All repositories instantiated from `research-paper-workflow` on or after adoption of this guide.
