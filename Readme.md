# Dixy 1.0
## A simple data format

Dixy is a very simple data format based on dictionaries.  As a subset of YAML, it is very easy to read and write and, as it doesn’t support the full YAML spec, parsers are extremely easy to build in any language.

Dixy is oriented at transmitting data between applications, servers and clients, data documents, config files, UI definitions, or any situation where data must be declared in a concise and simple manner, putting the developer first when reading and writing sample data allowing faster debug and design time while allowing parsers to be extremely fast in producing and consuming such data.

## Why dictionaries?

All programming languages use dictionaries as their main data collections. Classes and structs can be easily parsed and even arrays can be considered dictionaries with numeric keys, that makes storing everything in dictionaries a logical approach.

## Show me your dixy

Ok, here we have a simple document:

```
# Dixy 1.0

invoice:
    number: 01234
    date: 2016-12-31
    amount: 4902.85

    items:
        0:
            qty: 1
            desc: iMac 27” 32GB RAM
            price: 2950.95
            total: 2950.95
        1:
            qty: 2
            desc: iPhone 6S 64GB Black
            price: 975.95
            total: 1951.90

    notes: Next day delivery.
```

## Rules

There is only one simple rule. In Dixy, everything is a dictionary [string:string] and the content is parsed line by line, then each line is split in two by the first colon ( : ) and each side becomes a key and a value. If there is no value on the right side then the property is considered a new dictionary. For nil values and to avoid converting a scalar into a dictionary we will use the question mark ( ? ) like:

```
RockStar:
    first: Taylor
    middle: ?
    last: Swift
```

There is no need for quotes since all text on the left will be a string key and all text on the right will be a string value, where every consumer can do their own conversion to any type required locally. 

```
Latest observations:
    A galaxy far away: Andromeda
    A giant star: Sirius
    Stars in the universe: 123456E7890
    Date of observation: 2017.12.31 08:30:55
    Alien life discovered: true
```

It could be easily used to transmit comma separated arrays requiring extra parsing on the consumer, like:

```
window:
    frame: 100, 100, 800, 400
    title: Dixy is the coolest format of all
    views:
        label:
            frame: 0, 0, 100, 25
            title: Hello world
        button:
            frame: 10, 0, 100, 25
            title: Send
```

Comments can be placed only at the beginning of a line, using ( # ) as the first non-space character to avoid complex parsing, placing it at the end of a line will be considered part of the string:

```
# This is a nice list:

songs:
    0: 
        title: Where the streets have no name
        band: U2
    1:
	    # This one is the best
        title: Clocks
        band: Coldplay
    2:
        title: Stairway to heaven
        band: Led Zepellin

# End
```

If you need to visually signal the end of file, just use a comment.

White lines and comments will be ignored by the parser.

## Code to parse Dixy

Since the format is so simple, parsing it is as easy as splitting lines and assigning keys and values to the resulting dictionary. Take a look for yourself:

~~TODO: link to a dixy parser~~


## Final notes

This format is intended for data transmission and storage, for mapping objects to text and back, not for text documents where XML is a superior choice.

Thanks for your time.