# In defence of tuples

Tuples must be the least-loved of all Elm data structures. Who wants to remember which value is first, and which is second? Why not just use a record, where you get nice labels for your fields? 

In fact, since 0.19, Elm has disallowed arbitrary-length tuples, so we can only use two-tuples and triples anyway. That's a fairly clear indication that we should be using records for anything that contains more than a three-toed sloth's handful of values. And who are we to argue?

Well, there are a couple of things you can do with tuples that you can't do with records or custom types. For example, a tuple of `comparable` values is itself a `comparable`, which is not true of custom types or records whose fields are all comparable. This can be useful for a few things. 

Take sorting, for example. You can use tuples to sort a list of data by multiple properties, by providing `List.sortBy` with a function that turns your data into a tuples of comparables:

```elm
data = 
    [ { name = "Ed", age = 41, pets = 0 }
    , { name = "Tim", age = 56, pets = 1 }
    , { name = "Tom", age = 8, pets = 1 }
    , { name = "Rebecca", age = 32, pets = 0 }
    ]

sorted = 
    -- Sort first by number of pets, then by age (ascending)
    List.sortBy (\record -> (record.pets, record.age)) data

--  [ { name = "Rebecca", age = 32, pets = 0 }
--  , { name = "Ed", age = 41, pets = 0 }
--  , { name = "Tom", age = 8, pets = 1 }
--  , { name = "Tim", age = 56, pets = 1 }
--  ]
```

Useful, but perhaps not very exciting. What else? Well, the big thing that makes tuples different from records that they relate values to positions, not to field names. There's no way in Elm to say "give me the first field of a record", because the field names aren't in any specified order.

By contrast, with tuples, we can _only_ get, set or map a value by referring to its position. This isn't particularly interesting until we start nesting tuples.

```elm
nestedTuple = 
    ( 1, ( "hello", ( 0.5, ( "world", () ) ) ) )
```

How do we get the `1` here? That's easy, it's just `Tuple.first`. But if we want to get the `"hello"`, we need to do `Tuple.second` and _then_ `Tuple.first`.

```elm
one = 
    nestedTuple 
        |> Tuple.first

hello =
    nestedTuple 
        |> Tuple.second 
        |> Tuple.first

zeroPointFive =
    nestedTuple 
        |> Tuple.second 
        |> Tuple.second 
        |> Tuple.first

world = 
    nestedTuple 
        |> Tuple.second 
        |> Tuple.second 
        |> Tuple.second 
        |> Tuple.first
```

A similar pattern applies if we want to set or map a particular item in the tuple. For example, say we want to triple the `0.5` that appears as the third item in `nestedTuple`:

```elm
onePointFive = 
    Tuple.mapSecond 
        (Tuple.mapSecond 
            (Tuple.mapFirst (\float -> 3 * float)
            )
        ) 
        nestedTuple
```

Or to replace the fourth item, `"world"`, with `"dolly"`:

```elm
dolly = 
    Tuple.mapSecond 
        (Tuple.mapSecond 
            (Tuple.mapSecond 
                (Tuple.mapFirst (\string -> "dolly")
                )
            )
        ) 
        nestedTuple
```

Let's pretend we're computers, and use zero-indexed counting. We'll call the first item of a tuple "item 0", the second "item 1", and so on. 

We'll see that if we want to get item 1, we need 1 `Tuple.second`, followed by a `Tuple.first`. To get item 2, we need 2 `Tuple.second`s before our `Tuple.first`. And to get item 0? Well, we need 0 `Tuple.seconds` - just a `Tuple.first` on its own will do.

Similarly, to map an item of a tuple, we need to use the same number of `Tuple.mapSecond`s as the index of the item, followed by a `Tuple.mapFirst`.

Here's another way of writing it:

```elm
get3 =
    ((Tuple.second >> Tuple.second >> Tuple.second)
        >> Tuple.first
    )
        nestedTuple


set2 =
    (Tuple.mapSecond >> Tuple.mapSecond)
        (Tuple.mapFirst (\float -> 3 * float))
        nestedTuple


set3 =
    (Tuple.mapSecond >> Tuple.mapSecond >> Tuple.mapSecond)
        (Tuple.mapFirst (\string -> "dolly"))
        nestedTuple
```
