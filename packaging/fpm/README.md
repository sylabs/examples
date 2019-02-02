# FPM

[FPM](https://github.com/jordansissel/fpm) is a tool to easily and quickly build packages such as rpms, debs, etc.

## Requirements

To build this container, you will need the following:
* Singularity installed
* Internet access
* Root access

## Build instructions

To build the container, use:

`sudo singularity build fpm.sif fpm.def`

## Tests

### Application execution

First check if FPM runs:

`singularity exec fpm.sif fpm --version`

### RPM packaging

FPM is capable of creating a RPM package from a directory

```
singularity exec fpm.sif fpm --verbose -s dir -t rpm \
-C /path/to/folder --name $RPM_NAME --version $RPM_VERSION \
--iteration 1 --description "Test RPM"
```
It should output a file named `$RPM_NAME-$RPM_VERSION-1.x86_64.rpm`

### deb packaging

FPM is capable of creating a DEB package from a directory
```
singularity exec fpm.sif fpm --verbose -s dir -t deb \
-C /path/to/folder --name $DEB_NAME --version $DEB_VERSION \
--iteration 1 --description "Test DEB"
```
It should output a file named `$DEB_NAME-$DEB_VERSION-1_amd64.deb`