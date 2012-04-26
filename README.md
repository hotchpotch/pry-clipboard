# pry-clipboard

[![Build Status](https://secure.travis-ci.org/hotchpotch/pry-clipboard.png?branch=master)](http://travis-ci.org/hotchpotch/pry-clipboard)

Pry clipboard utility.

Copy history/result to clipboard.

## Installation

    $ gem install pry-clipboard

## Recommend setting

Your ~/.pryrc

```ruby
begin
  require 'pry-clipboard'
  # aliases
  Pry.config.commands.alias_command 'ch', 'copy-history'
  Pry.config.commands.alias_command 'cr', 'copy-result'
rescue LoadError => e
  warn "can't load pry-clipboard"
end
```

## Usage

```ruby
require 'pry-clipboard'
copy-history --help
copy-result --help
paste --help
```

### Copy history to clipboard

```ruby
pry(main)> def fib(n)
pry(main)*   n < 2 ? n : fib(n-1) + fib(n-2)
pry(main)* end
> nil
pry(main)> fib(10)
=> 55
pry(main)> copy-history
-*-*- Copy history to clipboard -*-*-
fib(10)
```

### Copy history to clipboard with result

```ruby
[5] pry(main)> fib(10)
=> 55
[6] pry(main)> copy-history -l
-*-*- Copy history to clipboard -*-*-
fib(10)
#=> 55
```

### Copy result

```ruby
pry(main)> 'hello' * 3
=> "hellohellohello"
pry(main)> copy-result
-*-*- Copy result to clipboard -*-*-
hellohellohello
```

### paste

```ruby
pry(main)> Clipboard.copy '3 * 5'
=> "3 * 5"
pry(main)> paste
=> 15
```

### N / --head / --tail options

```ruby
pry(main)> history --tail 10
 4: fib(10)
 5: copy-history
 6: copy-history -l
 7: fib(10)
 8: copy-history -l
 9: 'hello' * 3
10: copy-result
11: history --tail 10
12: copy-result --tail 3
13: copy-history --tail 3
pry(main)> copy-history 9
-*-*- Copy history to clipboard -*-*-
'hello' * 3
pry(main)> copy-history -tail 5
-*-*- Copy history to clipboard -*-*-
copy-result
history --tail 10
copy-result --tail 3
copy-history --tail 3
history --tail 10
```

### --range option

```ruby
pry(main)> history --head 10
 1: def fib(n)
 2:   n < 2 ? n : fib(n-1) + fib(n-2)
 3: end
 4: fib(10)
 5: copy-history
 6: copy-history -l
 7: fib(10)
 8: copy-history -l
 9: 'hello' * 3
10: copy-result
pry(main)> copy-history --range 1..4
-*-*- Copy history to clipboard -*-*-
def fib(n)
  n < 2 ? n : fib(n-1) + fib(n-2)
end
fib(10)
```

### --grep option

```ruby
pry(main)> copy-history --grep def
-*-*- Copy history to clipboard -*-*-
def fib(n)
def hello
```

## Author

* Yuichi Tateno

