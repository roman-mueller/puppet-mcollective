## 2015-02-03 - Version 1.0.5

- Fix assignment of variables to empty strings (GH #48)
- Get rid of unnecessary spaceship operators (GH #49)
- Add more puppet-lint plugins
- Various unit tests improvements
- Fix scoping issues in templates (GH #50)

## 2010-10-30 - Version 1.0.2

- Remove puppet 2.7 support in travis matrix

## 2010-10-20 - Version 1.0.1

- Linting
- Setup automatic Forge releases

## 2014-09-23 - Version 0.8.1

- Use metadata.json instead of Modulefile
- node_identity default to $::clientcert instead of $::fqdn
- Add support for RHEL7

## 2014-07-29 - Version 0.8.0

- Add $node_identity
- Add mcollective::client::discovery::puppetdb

## 2014-07-02 - Version 0.7.0

- Add $mcollective::node_ensure_service
- Fix unit tests
- Use ruby 2.1.2 instead of 2.1.1
