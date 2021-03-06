deploy:
	mix edeliver build release
	mix edeliver deploy release to prod
	mix edeliver migrate
	mix edeliver start staging

update:
	mix edeliver update staging --branch=master --start-deploy
