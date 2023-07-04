# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/ccin2p3/puppet-syslog_ng/tree/v4.0.0) (2023-07-04)

[Full Changelog](https://github.com/ccin2p3/puppet-syslog_ng/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop Debian 9 \(EOL\) [\#39](https://github.com/ccin2p3/puppet-syslog_ng/pull/39) ([smortex](https://github.com/smortex))
- Drop Puppet 6 \(EOL\) [\#38](https://github.com/ccin2p3/puppet-syslog_ng/pull/38) ([smortex](https://github.com/smortex))
- Drop support of RedHat 6 / Ubuntu 16.04 \(EOL\) [\#29](https://github.com/ccin2p3/puppet-syslog_ng/pull/29) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Add support for Puppet 8 [\#40](https://github.com/ccin2p3/puppet-syslog_ng/pull/40) ([smortex](https://github.com/smortex))
- Relax dependencies version requirements [\#37](https://github.com/ccin2p3/puppet-syslog_ng/pull/37) ([smortex](https://github.com/smortex))
- Rework documentation [\#33](https://github.com/ccin2p3/puppet-syslog_ng/pull/33) ([smortex](https://github.com/smortex))
- Add support for AlmaLinux [\#31](https://github.com/ccin2p3/puppet-syslog_ng/pull/31) ([smortex](https://github.com/smortex))
- Add support for Rocky [\#30](https://github.com/ccin2p3/puppet-syslog_ng/pull/30) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix dependencies version bounds [\#34](https://github.com/ccin2p3/puppet-syslog_ng/pull/34) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Modernize functions [\#32](https://github.com/ccin2p3/puppet-syslog_ng/pull/32) ([smortex](https://github.com/smortex))
- Fix acceptance tests of expected to fail tests [\#27](https://github.com/ccin2p3/puppet-syslog_ng/pull/27) ([smortex](https://github.com/smortex))

## [v3.0.0](https://github.com/ccin2p3/puppet-syslog_ng/tree/v3.0.0) (2022-03-03)

[Full Changelog](https://github.com/ccin2p3/puppet-syslog_ng/compare/v2.2.1...v3.0.0)

**Breaking changes:**

- Drop support for Debian 8 \(EOL\) [\#19](https://github.com/ccin2p3/puppet-syslog_ng/pull/19) ([smortex](https://github.com/smortex))
- Drop support for Puppet 5 \(EOL\) [\#16](https://github.com/ccin2p3/puppet-syslog_ng/pull/16) ([smortex](https://github.com/smortex))
- Drop support for OS which have reached EOL [\#10](https://github.com/ccin2p3/puppet-syslog_ng/pull/10) ([smortex](https://github.com/smortex))
- Drop support for Puppet 4 \(EOL\) [\#8](https://github.com/ccin2p3/puppet-syslog_ng/pull/8) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Add support for current CentOS releases [\#21](https://github.com/ccin2p3/puppet-syslog_ng/pull/21) ([smortex](https://github.com/smortex))
- Add data types everywhere [\#20](https://github.com/ccin2p3/puppet-syslog_ng/pull/20) ([smortex](https://github.com/smortex))
- Set upper bounds for dependencies [\#14](https://github.com/ccin2p3/puppet-syslog_ng/pull/14) ([smortex](https://github.com/smortex))
- Add support for recent OS [\#11](https://github.com/ccin2p3/puppet-syslog_ng/pull/11) ([smortex](https://github.com/smortex))
- Add support for Puppet 6 and 7 [\#9](https://github.com/ccin2p3/puppet-syslog_ng/pull/9) ([smortex](https://github.com/smortex))
- Switch to GitHub actions [\#7](https://github.com/ccin2p3/puppet-syslog_ng/pull/7) ([smortex](https://github.com/smortex))

**Closed issues:**

- Tune rubocop Style/TrailingCommaInArguments [\#25](https://github.com/ccin2p3/puppet-syslog_ng/issues/25)
- Tune rubocop Style/WordArray [\#24](https://github.com/ccin2p3/puppet-syslog_ng/issues/24)
- Bring back smoke tests [\#23](https://github.com/ccin2p3/puppet-syslog_ng/issues/23)
- Available module on forge is outdated [\#5](https://github.com/ccin2p3/puppet-syslog_ng/issues/5)

**Merged pull requests:**

- Integrate smoke tests as integration tests [\#26](https://github.com/ccin2p3/puppet-syslog_ng/pull/26) ([smortex](https://github.com/smortex))
- Fix module metadata [\#18](https://github.com/ccin2p3/puppet-syslog_ng/pull/18) ([smortex](https://github.com/smortex))
- Add basic acceptance tests [\#17](https://github.com/ccin2p3/puppet-syslog_ng/pull/17) ([smortex](https://github.com/smortex))
- Switch to the new official syslog-ng repo [\#12](https://github.com/ccin2p3/puppet-syslog_ng/pull/12) ([smortex](https://github.com/smortex))
- Remove notice messages [\#6](https://github.com/ccin2p3/puppet-syslog_ng/pull/6) ([smortex](https://github.com/smortex))

## [v2.2.1](https://github.com/ccin2p3/puppet-syslog_ng/tree/v2.2.1) (2020-09-22)

* Add support for SLES
* Add repo management for Debian

## [v2.1.0](https://github.com/ccin2p3/puppet-syslog_ng/tree/v2.1.0) (2018-09-06)

* add structured fact
* fix bug where reload was triggered when service wasn't running
* add datatype

## [v2.0.0](https://github.com/ccin2p3/puppet-syslog_ng/tree/v2.0.0) (2018-03-20)

* Drop support for puppet < 4.9.1
* First official release from ccin2p3 (was ihrwein before)
* Add module data in favor of params.pp



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
