doc: 
	R -s -e "pkgload::load_all('pkg');roxygen2::roxygenize('pkg')"

pkg: doc
	R CMD build pkg

install: pkg
	R CMD INSTALL *.tar.gz

check: doc
	R CMD build pkg
	R CMD check *.tar.gz

cran: doc
	R CMD build pkg
	R CMD check --as-cran *.tar.gz

test: install doc
	Rscript ./pkg/inst/test/test_jaro_similarity.R

perf-test:
	Rscript ./perf_test/performance_tests.R

clean: 
	rm -rf jarosimilarity.Rcheck
	rm -f *.tar.gz
	rm -f pkg/src/*.o
	rm -f pkg/src/*.so
