# deny

```
$ deny "Chess is boring"
"Chess is boring" No.
```

## Installation

```
git clone https://github.com/Jens0512/deny.git 
cd deny
sudo make install INSTALL_LOCATION=/usr/local/bin/deny
```

## Usage

```text
Usage: deny [opts] [args...]
    -o, --or                         Or what? Use alternate end instead of end
    -e, --end                        Specify end (default: '.'
    -a, --alternate-end              Specify alternate end (-o flag) (default: '?'
    -s SURROUND, --surround=SURROUND Sets what to surround the args with (default: ")
    -d DENIAL, --delimeter=DENIAL    Sets how the joined args are denied (default: No)
    -j JOIN, --join=JOIN             Specify what to join the args with (default: ' ')
    -n NOTHING, --on-nothing=NOTHING Specify what to print, when no args are received (default: <Nothing>)
    -q, --question                   Do not print anything, only return the exit code for input
    -h, --help                       Show this help
```

## Contributing

1. Fork it ( https://github.com/[your-github-name]/no/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Jens0512](https://github.com/Jens0512) Jens - creator, maintainer
