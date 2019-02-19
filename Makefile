help: ## Print this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean: ## Delete service directory
	rm -fr $(name)

setup: ## clone name repository
	git clone git@github.com:hmrc/$(name).git

report: ## dependencies report
	cd $(name) && sbt dependencyUpdatesReport && cat target/dependency-updates.txt

upgrade: ## upgrade versions
	cd $(name) && grep -l -s $(groupid).*$(artifactid) *.sbt project/*.scala | xargs sed -i "s/\"$(actualversion)\"/\"$(version)\"/"

strict-upgrade: ## upgrade with stricter match for very rare edge cases
	cd $(name) && grep -l -s com.fasterxml.jackson.core.*jackson-core *.sbt project/*.scala | xargs sed -i -E "s/(\"$(groupid)\")[ ]+([%]{1,2})[ ]+(\"$(artifactid)\").*\"$(actualversion)\"/\1 \2 \3 % \"$(version)\"/"

test: ## run sbt tests
	cd $(name) && sbt clean test

check: ## match for dependency as group id and artifactid
	grep -s $(groupid).*$(artifactid) $(name)/*.sbt $(name)/project/*.scala
