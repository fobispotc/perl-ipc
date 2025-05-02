

.PHONY: idntest

idntest:
	@echo "building idntest..."
	@cd goidn && go build -o ../scripts/idntest ./cmd/*go

perldeps:
	@echo installing perl dependencies 
	@cpanm -n --installdeps .

run: 
	@echo "running idntest..."
	@PERL5LIB=./lib ./scripts/to_ascii.pl