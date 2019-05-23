## Changelog

### 0.5.1

 * Make sure createcomputerarg always has a value
 * Update tests
 * Add CI via PDK

Thanks to @bjvrielink

### 0.5.0

 * Support for Puppet 6

### 0.4.2

 * Fix bug with `createcomputer` parameter default

### 0.4.1

 * Confine custom facts to run on Linux, as they conflict on Windows
 * Only run custom facts if `wbinfo` is present
 * Thanks to @jhonny-oliveira

### 0.4.0

 * Remove `nagioschecks` option as the checks wouldn't have worked properly for anyone, and they belong in a profile
