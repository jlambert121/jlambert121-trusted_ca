[![Puppet Forge](http://img.shields.io/puppetforge/v/evenup/trusted_ca.svg)](https://forge.puppetlabs.com/evenup/trusted_ca)
[![Build Status](https://travis-ci.org/evenup/evenup-trusted_ca.png?branch=master)](https://travis-ci.org/evenup/evenup-trusted_ca)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with trusted_ca](#setup)
    * [What trusted_ca affects](#what-trusted_ca-affects)
    * [Beginning with trusted_ca](#beginning-with-trusted_ca)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Changelog/Contributors](#changelog-contributors)

## Overview

A puppet module to manage the distribution's trusted certificates and install trusted SSL certificates into the system's trusted keystore and java's keystore's.

## Module Description

Many organizations use self-signed SSL certificates for internal services that need to be trusted by other hosts.  This puppet module will install SSL certificates into a host's system-wide trusted CA files (which are used by distribution-provided java packages) as well as a define for installing certificates into java installations not provided by the distribution.

## Setup

### What trusted_ca affects

* Distributin-provided trusted SSL certificates package
* System-wide additional trusted SSL certificates
* SSL certificates installed into java trusted certificate keystore

### Beginning with trusted_ca

To install trusted_ca

```
    puppet module install evenup-trusted_ca
```

Dependencies:

* puppetlabs/stdlib

## Usage

Manage only distribution-specific trusted certificates

```puppet
    class { 'trusted_ca': }
```

Install a self-signed SSL certificate into the system's global trusted keystore

```puppet
    class { 'trusted_ca': }
    trusted_ca::ca { 'mycompany.org':
      source => 'puppet:///ssl/mycompany.org.crt',
    }
```

Install a self-signed SSL certificate into a java keystore

```puppet
    class { 'trusted_ca': }
    trusted_ca::java { 'mycompany.org':
      source => 'puppet:///ssl/mycompany.org/crt',
      java_keystore => '/usr/local/java/lib/security/cacerts',
    }
```

## Reference

### Public classes

#### `trusted_ca`

##### `certificates_version`

String.  Version of the distribution-specific trusted certificates.  Examples would be 'latest' or a specific version.

##### `path`

String/Array of String.  List of paths for the `update_command`.

##### `install_path`

String.  Location to install the trusted certificates.

##### `update_command`

String.  Command to rebuild the system-trusted certificates.

### Public defines

#### `trusted_ca::ca`

##### `source`

String.  Source of the certificate to include.  Must be in PEM format with crt extension.

##### `install_path`

String.  Destination of the certificate file for processing.  Defaults to the install_path from the class, but can be overridden per certificate.

#### `trusted_ca::java`

##### `source`

String.  Source of the certificate to include.  Must be in PEM format.

##### `java_keystore`

String.  Location of of the java cacerts keystore file.

### Private classes

* trusted_ca::params: Defaults for the trusted_ca module

## Limitations

Tested on:
* CentOS 6, 7
* Ubuntu Server 10.04, 12.04, 14.04

## Development

Improvements and bug fixes are greatly appreciated.  See the [contributing guide](https://github.com/evenup/evenup-trusted_ca/blob/master/CONTRIBUTING.md) for
information on adding and validating tests for PRs.

## Changelog / Contributors

[Changelog](https://github.com/evenup/evenup-trusted_ca/blob/master/CHANGELOG)
[Contributors](https://github.com/evenup/trusted_ca/graphs/contributors)