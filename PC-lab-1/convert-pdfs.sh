#!/usr/bin/env bash
set -euo pipefail


# ======================== convert and filter pdf files ========================

echo $PWD
mkdir txts

# convert all pdfs to text
# for file in pdf/*.pdf; do pdftotext "$file"; done

# more readible form, needs to put in a separate file and executed (bash fileaname.sh)
# for file in pdf/*.pdf
#     do pdftotext "$file"
# done

# move all the txt files to a different folder
# mv pdf/*.txt txt/

# pdfs too large to upload, unzip already converted txts
unzip txt.zip

# search for patterns: with matches highlighted
grep -i --color "causal" txt/*.txt

# with line number
grep -in "causal" txt/*.txt
# only count of matches
grep -ic "causal" txt/*.txt

# only matching files, only count of matches
grep -ilc "causal" txt/*.txt

# extend pattern with regex
grep -ilc -E "(causal|missing data)" txt/*.txt

# look at first and last
grep -ilc -E "(causal|missing data)" txt/*.txt | head -n 10
grep -ilc -E "(causal|missing data)" txt/*.txt | tail -n 10

# pipe all non-matches (-L) to rm for deletion, careful with rm!
grep -Z -L -E "(causal|missing data)" txt/*.txt | xargs -0 rm
