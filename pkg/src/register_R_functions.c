#include <R.h>
#include <Rinternals.h>
#include <stdlib.h>
#include <R_ext/Rdynload.h>


extern SEXP c_jarosimilarity(SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"c_jarosimilarity", (DL_FUNC) &c_jarosimilarity, 5},
    {NULL, NULL, 0}
};

void R_init_jarosimilarity(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}