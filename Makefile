test: env
	swift test --enable-test-discovery --parallel

env:
	echo "WORKING_DIR=~/viper-kit/" > .env.testing
