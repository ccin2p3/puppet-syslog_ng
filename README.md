# syslog_ng

#### Table of Contents

<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Module Description](#module-description)
  * [Configuration syntax](#configuration-syntax)
* [Setup](#setup)
  * [Puppet Forge](#puppet-forge)
  * [Installing from source](#installing-from-source)
  * [What syslog_ng affects](#what-syslog_ng-affects)
  * [Getting started with syslog_ng](#getting-started-with-syslog_ng)
* [Usage](#usage)
  * [Facts](#facts)
  * [Classes and defined types](#classes-and-defined-types)
* [Implementation details](#implementation-details)
* [Limitations](#limitations)
* [Development](#development)
  * [Tests](#tests)
  * [Other information](#other-information)

<!-- vim-markdown-toc -->

## Overview
This module lets you generate syslog-ng configuration using puppet. It supports
all kinds of statements, such as sources, destinations, templates, and so on. After
defining them, you can combine them into a log path. This module also takes care of
installing syslog-ng, or reloading it after a configuration file change.

You can check the supported platforms in the [Limitations](#limitations) section.

## Module Description
This module integrates well with syslog-ng. It supports its configuration model
 so you can create new sources and destinations as Puppet resources. Under the
 hood they are just defined resource types.

The supported statements:
 * `options`
 * `template`
 * `rewrite`
 * `parser`
 * `filter` (partial support)
 * `source`
 * `destination`
 * `log`
 * +1: `config`, which lets you insert existing configuration snippets.

Each type is under the `syslog_ng::` namespace, so you can use them like this:
```puppet
syslog_ng::source { 's_gsoc':
    params => {
        'type' => 'tcp',
        'options' => [
            {'ip' => "'127.0.0.1'"},
            {'port' => 1999}
        }]
    }
}
```
There is a shorter form:
<a name="shorter_form"></a>
```puppet
syslog_ng::source { 's_gsoc':
    params => {
        'tcp' => [
            {'ip' => "'127.0.0.1'"},
            {'port' => 1999}
        }]
    }
}
```

### Configuration syntax
Every statement has the same layout. They can accept a `params` parameter, which
can be a hash or an array of hashes. Each hash should have a `type` and `options`
key or you can use a [shorter form](#shorter_form).

The value of the `type` represents the type of the statement, in case of a
source this can be `file`, `tcp` and so on.

The value of the `options` is an array of strings and hashes. You have to pay attention to
quotation when using strings. If you want the inner quotation to be a single quote (
in the `syslog-ng.conf`), then the outer one must be a double, like
 `"'this string'"`, which will be transformed into `'this string'`.

Similarly, you can write `'"this string"''` to get `"this string"` in the
configuration.

By using this convention, the module will generate correct configuration files.
If the `option` array is empty, you can use an empty string `''` instead.

As I mentioned, there are strings and hashes in an option. Hashes
must contain only one key. This key will identify the name of the parameter and its
value must be an array of strings. If that would contain only one item, the value can
be simply just a string.

You can find a lot of examples under the `tests` and `spec` directories. The
`default_config.pp` under  the `tests` directory contains the default configuration
 from the `syslog-ng` source, translated into Puppet types.
## Setup

### Puppet Forge
This module is published on [Puppet Forge](https://forge.puppetlabs.com/ccin2p3/syslog_ng).
It used to be under the [ihrwein](https://forge.puppetlabs.com/ihrwein/syslog_ng) namespace, but the original author kindly accepted to hand it over.

### Installing from source
You can install it following these steps:

 0. Make sure you have the required dependencies
 * ruby
 * bundler
 1. Clone the source code into a directory:
 ```
 $ git clone https://github.com/ccin2p3/puppet-syslog_ng.git
 ```
 2. Make sure you are on master branch:
 ```
 $ git checkout master
 ```
 3. Get dependencies
 ```
 $ bundle install
 ```
 4. Build a package:
 ```
 $ bundle exec puppet module build
 ```
This will create a `tar.gz` file under the `pkg` directory. Now you should be able
to install the module:
 ```
 $ bundle exec puppet module install pkg/ccin2p3-syslog_ng-VERSION.tar.gz
 ```

### What syslog_ng affects
* It setup a repository with recent syslog-ng releases (only on RedHat and
  Debian based operating systems and if `$syslog_ng::manage_repo` is set to
  `true`)
* It installs the `syslog-ng` or `syslog-ng-core` package
  * that creates the necessary directories on your system, including `/etc/syslog-ng`.
  * If another `syslog` daemon is installed, it will be removed by your package manager.
* purges the content of `/etc/syslog-ng/syslog-ng.conf`

### Getting started with syslog_ng
If you are not familiar with `syslog-ng`, I suggest you to take a look at the
[Syslog-ng Admin Guide](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html-single/index.html)  which contains all the necessary information to use this
software.

You can also get help on the [syslog-ng mailing list](syslog-ng@lists.balabit.hu).

## Usage
Just use the [classes and defined types](#Classes-and-defined-types) as you would
 use them, without Puppet.

Before the generated configuration would be applied, it is written to a temporary
 file. Next, the module checks the configuration syntax of this file, and if it is OK,
 it overwrites the real configuration file. So you do not have to worry about
 configuration errors.

### Facts

The fact `syslog_ng_version` contains the installed version string *e.g.* `3.7.1`

### Classes and defined types

For information on the classes and types, see the [REFERENCE.md](https://github.com/ccin2p3/puppet-syslog_ng/blob/master/REFERENCE.md).

## Implementation details

There is a `concat::fragment` resource in every class or defined type which represents a statement. Because statements need to be defined before they are referenced in the configuration, I use an automatic ordering system. Each type has its own order value, which determines its position in the configuration file. The smaller an order value is, the more likely it will be at the beginning of the file. The interval of these values starts with `0` and are `'strings'`. Here is a table, which contains the default order values:
<a name="order_table"></a>

| Name                   | Order |
|------------------------|-------|
| syslog_ng::config      | '5'     |
| syslog_ng::destination | '70'    |
| syslog_ng::filter      | '50'    |
| syslog_ng::log         | '80'    |
| syslog_ng::options     | '10'    |
| syslog_ng::parser      | '40'    |
| syslog_ng::rewrite     | '30'    |
| syslog_ng::source      | '60'    |
| syslog_ng::template    | '20'    |

The config generation is done by the `generate_statement()` function in most
 cases. It is just a wrapper around my `statement.rb` Ruby module, which does
 the hard work. The `require` part may seem quite ugly, but it works well.


## Limitations

The module works well with the following Puppet versions:
  * 2.7.9
  * 2.7.13
  * 2.7.17
  * 3.1.0
  * 3.2.3
  * 3.3.1
  * 3.3.2
  * 3.4.0
  * 3.4.3

Tested Ruby versions:
  * 1.8.7
  * 1.9.2

*NOTE*: The module was tested with Travis with these versions. It may work well
 on other Puppet or Ruby versions. If that's so, please hit me up.

The following platforms are currently tested (in Docker containers):

|              | 1.8.7 | 1.9.1 | 1.9.3 | 2.0.0 |
|--------------|-------|-------|-------|-------|
| CentOS 6     | x     |       |       |       |
| CentOS 7      |       |       |       | x     |
| Ubuntu 12.04 | x     |       |       |       |
| Ubuntu 14.04 |       |       | x     |       |

If you use it on an other platform, please let me know about it!

## Development

### Tests

This module use the Voxpupuli tooling, so the Voxpupuli documentation apply about [how to run the test suite=(https://voxpupuli.org/docs/how_to_run_tests/).

### Other information

I am open to any pull requests, either for bug fixes or feature
 developments. I cannot stress the significance of tests sufficiently, so please,
 write some spec tests and update the documentation as well according to your
 modification.

**Note for commiters:**

The `master` branch is a sacred place, do not commit to it directly, we should touch it only using pull requests.
