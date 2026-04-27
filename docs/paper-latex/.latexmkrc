# Resolve shared bibliography from template papers on all OSes.
# latexmk invokes bibtex from docs/paper-latex/build, so keep BIBINPUTS explicit.
my $sep = ($^O eq 'MSWin32') ? ';' : ':';
$ENV{BIBINPUTS} = "../../bibliography${sep}" . ($ENV{BIBINPUTS} // '');
