# #!/usr/bin/env zsh

typeset -A files
files[before/runner.dart]=before
files[after/runner.dart]=after

for file in ${(k)files}
do
  output=${files[$file]}
  echo "Processing: $file"
  # note: best themes to use are: seti, synthwave '84, night owl, vscode
  carbon-now $file -p my-preset --save-as screenshots/$output && echo "Output: $output"
done