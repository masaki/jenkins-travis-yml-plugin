# ![logomakr_5059hu](https://cloud.githubusercontent.com/assets/3071208/20248819/1e3637aa-a9ec-11e6-89b7-6c9c403af3c7.png)

This plugin has been done to be able to have certain level of compatibility in between Jenkinsm travis and other YML based build services.

## Use
Install by navigating and selecting `Manage Jenkins` -> `Manage Plugins` -> `Travis YML Plugin`

Add to your workspace on the root folder a .travis.yml, this plugin accepst the next phases of lifecicle:

1. before_install
2. install
3. before_script
4. script
5. after_success 
6. after_failure
7. before_deploy
8. deploy
9. after_deploy
10. after_script

## Development

If you want to help on the development of this plugin you will need `Jruby` and the next prerequisites:
```
gem install bundler
```

For development and to see this plugin in a test Jenkins server:
```
$ bundle install
$ jpi server
```
after that open a pull request to add your changes.

If you have any further request open an issue on the main repository or contact the sustainers:
- @kanekotic
- @masaki

## Logo
People graphic by <a href="http://www.flaticon.com/authors/freepik">Freepik</a> from <a href="http://www.flaticon.com/">Flaticon</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a>. Made with <a href="http://logomakr.com" title="Logo Maker">Logo Maker</a>