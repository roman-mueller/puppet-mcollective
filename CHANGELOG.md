## 2015-05-13 - Release 2.0.7

Add puppet-lint-file_source_rights-check gem

## 2015-05-13 - Release 2.0.6

Fix Gemfile

## 2015-05-12 - Release 2.0.5

Fix relationship for anchor

## 2015-05-12 - Release 2.0.4

Don't pin beaker

## 2015-04-27 - Release 2.0.3

Add nodeset ubuntu-12.04-x86_64-openstack

## 2015-04-17 - Release 2.0.2

- Fetch fixtures from puppet forge

## 2015-04-15 - Release 2.0.1

- Use file() function instead of fileserver (way faster)

## 2015-04-08 - Release 2.0.0

- Restart mcollective when plugins are updated
- Remove mcollective::node::refresh (breaking change)

## 2015-04-03 - Release 1.1.1

- Use anchors in top classes

## 2015-04-02 - Release 1.1.0

- Add defaults to main class parameters
- Update acceptance tests boxes

## 2015-03-24 - Release 1.0.7

- Various spec improvements

## 2015-03-13 - Release 1.0.6

- Remove PATH from facts updating cron entry
- Various unit tests improvements

## 2015-02-03 - Release 1.0.5

- Fix assignment of variables to empty strings (GH #48)
- Get rid of unnecessary spaceship operators (GH #49)
- Add more puppet-lint plugins
- Various unit tests improvements
- Fix scoping issues in templates (GH #50)

## 2010-10-30 - Release 1.0.2

- Remove puppet 2.7 support in travis matrix

## 2010-10-20 - Release 1.0.1

- Linting
- Setup automatic Forge releases

## 2014-09-23 - Release 0.8.1

- Use metadata.json instead of Modulefile
- node_identity default to $::clientcert instead of $::fqdn
- Add support for RHEL7

## 2014-07-29 - Release 0.8.0

- Add $node_identity
- Add mcollective::client::discovery::puppetdb

## 2014-07-02 - Release 0.7.0

- Add $mcollective::node_ensure_service
- Fix unit tests
- Use ruby 2.1.2 instead of 2.1.1
