help: ## Print this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean: ## Delete service directory
	rm -fr $(name)

setup: ## clone name repository
	git clone git@github.com:hmrc/$(name).git

report: ## dependencies report
	cd $(name) && sbt dependencyUpdatesReport && cat target/dependency-updates.txt

upgrade: ## more agresive bump version
	cd $(name) && grep -l $(groupid).*$(artifactid) *.sbt project/*.scala | xargs sed -i "s/\"$(actualversion)\"/\"$(version)\"/"

upgrade2: ## upgrade version
ifdef varversion
		cd $(name) && grep -l $(groupid).*$(artifactid) *.sbt project/*.scala | xargs sed -i "s/% $(varversion)/% \"$(version)\"/"
else ifdef actualversion
	cd $(name) && grep -l $(groupid).*$(artifactid) *.sbt project/*.scala | xargs sed -i "s/% \"$(actualversion)\"/% \"$(version)\"/"
endif

test: ## run sbt tests
	cd $(name) && sbt clean test

check: ## match for dependency as group id and artifactid
	grep $(groupid).*$(artifactid) $(name)/*.sbt $(name)/project/*.scala
