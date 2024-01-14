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

test: doc
	R -s -e "tinytest::build_install_test('pkg')"

clean:
	rm -rf jarosimilarity.Rcheck
	rm -f *.tar.gz
