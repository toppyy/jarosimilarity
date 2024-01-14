# jarosimilarity

An (unpublished) R-package *jarosimilarity*. The package does fuzzy matching between (multi-)sets of strings using the [Jaro-similarity](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) algorithm.

## Implementation

The idea is to take the implementation of Jaro-Winkler from the stringdist-package as a starting point. The first step is strip away as much of the code as possible (stringdist supports multiple fuzzymatching algorithms so the code is more complicated). 

Differences to stringdist-package:
- Can only compare ASCII-strings
- Uses char pointers instead of unsigned integers to represent characters
- Does not return the jaro-similarity between strings. Returns matches (jaro similarity above threshold-parameter)
- Can return matches between two sets (returns a vector of integers where odd indexes are references to set1 and even to set2)

Optimisations added:
1. Exit early if the number of matches is slow (no need to calc transpositions)
2. Re-use memory instead of calling `malloc` for each comparison

+ other minor optimisations