# latexmk configuration for the PFE report.
# Engine: pdflatex (matches .vscode/settings.json recipe).
$pdf_mode = 1;

# --- Glossaries / glossaries-extra support ---------------------------------
# latexmk does not know how to build glossaries on its own. Without these
# custom dependencies the generated .gls / .gls-abr files are seen as
# "changed by user" on every pass, so pdflatex is rerun until latexmk gives
# up with "Maximum runs of pdflatex reached" / "needed too many passes".
#
# Each rule tells latexmk: this glossary output is produced from that glossary
# input by running `makeglossaries`. `makeglossaries main` reads main.aux and
# processes every glossary at once (main, acronyms, and the custom 'abr' one).
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');         # acronyms (default)
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');         # main glossary
add_cus_dep('glo-abr', 'gls-abr', 0, 'run_makeglossaries'); # custom 'abr' glossary

sub run_makeglossaries {
    my ($base, $path) = fileparse($_[0]);
    pushd $path;
    my $ret = system('makeglossaries', $base);
    popd;
    return $ret;
}

# Let `latexmk -c` / `-C` clean the glossary and biblatex side files too.
push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'glo-abr', 'gls-abr', 'glg-abr';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' run.xml %R-blx.bib %R.bbl-SAVE-ERROR';
