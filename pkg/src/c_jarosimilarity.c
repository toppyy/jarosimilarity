#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
#include <math.h>
#ifdef _OPENMP
#include <omp.h>
#endif

#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))
#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))

double _jarosimilarity(
       const char *a 
     , int x
     , const char *b
     , int y
     , char *work
     , double threshold
  ){


    // edge case
    if ( x == 0 && y == 0 ) return 0;

    char *wrk = (char *) work;
    char *matcha = wrk, *matchb = wrk + x;  
    char left, right;


    // number of matches
    int m = 0;
    // max transposition distance
    int M = MAX(MAX(x,y)/2 - 1,0);

    // store the match indices. Indices are stored as i+1 because 0 is used as 'no match'
    for ( int i = 0; i < x; ++i){

        left = MAX(0,i-M);
        right = MIN(y,i+M);
        for ( int j = left; j <= right; j++){
            if ((a[i] == b[j]) && (matchb[j]==0)){
                matcha[i] = i+1;
                matchb[j] = j+1;
                m += 1;
                break;
            }
        }
    }

    // Solve how many matches we need at least to go above the threshold if we assume that t = 0.
    // jarosimilarity being (x/m + y/m + (m-t)/m) * (1/3)
    // 
    // Given a threshold 0.9, we can simplify it to this and solve m
    
    int  min_m =  ceil(  ( ((threshold * 3) - 1) * (x*y) ) / (y+x) );

    if ( m < min_m ){
        return 0.0;
    }

    // copy matches so they're easy to compare for transposition counting
    int j = 0;
    for (int i=0; i < x; ++i){
        if (matcha[i]){ 
        matcha[j] = a[matcha[i]-1];
        ++j;
        }
    }
    j = 0;
    for (int i=0; i < y; ++i){
        if (matchb[i]){ 
        matchb[j] = b[matchb[i]-1];
        ++j;
        }
    }

    // count 'transpositions', the Jaro way.
    double t = 0.0;
    for ( int k=0; k<m; ++k){
        if (matcha[k] != matchb[k]) t += 0.5;
    }

    double d;

    d =  (1.0/3.0)*(m/((double) x) + m/((double) y) + (m-t)/m);

    return d;
}


SEXP empty_int_vector(void) {
    SEXP result = PROTECT(allocVector(INTSXP, 0));
    UNPROTECT(1);
    return result;
}

SEXP c_jarosimilarity(SEXP a, SEXP b, SEXP p_threshold, SEXP p_max_len, SEXP p_nthreads) {

    double threshold = Rf_asReal(p_threshold);
    int nthreads = Rf_asInteger(p_nthreads);
    int max_len = Rf_asInteger(p_max_len);


    int a_len = LENGTH(a);
    int b_len = LENGTH(b);

    if ((a_len < 1) | (b_len < 1)) {
        return empty_int_vector();
    }

    // Allocate space for expected number of matches * 2
    int max_matches = a_len * b_len;
    int matches_expected = max_matches * 0.002;

    if (matches_expected < 10) {
        // For very small use cases. It really does not matter.
        matches_expected = 10;
    }
    
    int matches_expected_per_thread = (matches_expected * 2) / nthreads; 
    int* matches[nthreads];
    int* match_array_size   = calloc(nthreads, sizeof(int));


    for (int i = 0; i < nthreads; i++) {
        matches[i] = calloc(matches_expected_per_thread, sizeof(int));
        if (matches[i] == NULL) {
            // TODO: handle error 
            return empty_int_vector();
        }
        match_array_size[i] = matches_expected_per_thread;
    }


    int* match_counts   = calloc(nthreads, sizeof(int));
    int work_size       = max_len * 2;

    // Start parallel
    #ifdef _OPENMP 
    #pragma omp parallel num_threads(nthreads)
    #endif
    {


        // Use calloc so work is initialized to zero
        char *work = (char *) calloc(work_size, sizeof(char));
        double res = 0.0;

        int th_id = 0;
        int matches_added = 0;
        int failed = 0;

        #ifdef _OPENMP
        th_id = omp_get_thread_num();
        #pragma omp for
        #endif
        for (int i = 0; i < a_len; i += 1) {
            const char* a_ptr1 = R_CHAR(STRING_ELT(a,i));
            
            int str_len_a1 = strlen(a_ptr1);

            for (int j = 0; j < b_len; j += 1) {
                const char* b_ptr1 = R_CHAR(STRING_ELT(b,j));

                int str_len_b1 = strlen(b_ptr1);

                // a1 vs. b1
                res = _jarosimilarity(a_ptr1, str_len_a1, b_ptr1, str_len_b1, work, threshold);
                memset(work, 0, work_size);

                if (res >= threshold) {
                    matches[th_id][matches_added]       = i;
                    matches[th_id][matches_added + 1]   = j;
                    matches_added += 2;

                    if (matches_added + 4 >= match_array_size[th_id] ) {
                        // Need to allocate more memory for results array    

                        int new_size = match_array_size[th_id] * 2;
                        match_array_size[th_id] = new_size;

                        matches[th_id] = (int *) realloc(matches[th_id], new_size * sizeof(int));

                        if (matches[th_id] == NULL) {
                            matches_added = 0; 
                            failed = 1; // TODO. Better way to handle errors. Can't return 'cause in parallel section
                            break;
                        }
                    }

                }
            }
            
        }

        match_counts[th_id] = matches_added;

        if (failed) {
            match_counts[th_id] = 0;
        }

        free(work);

    } // End parallel
    
    int matches_total = 0;
    for (int i = 0; i < nthreads; i++) {
        matches_total += match_counts[i];
    }


    SEXP result = PROTECT(allocVector(INTSXP, matches_total));
    
    int res_i = 0;
    for (int th_i = 0; th_i < nthreads; th_i++) {
        for (int i = 0; i < match_counts[th_i]; i++) {
            INTEGER(result)[res_i] = matches[th_i][i] + 1; // TODO: reuse INTEGER(result)
            res_i += 1;
        }
    }
    for (int i = 0; i < nthreads; i++) {
        free(matches[i]); 
    }
    
    UNPROTECT(1);
    return result;

}

