# Elm MultiTool

## What does it do?

This package allows you to compose "tools", where a tool is any Elm package with an API similar to `miniBill/elm-codec` 
and `edkelly303/elm-any-type-forms`.

## Why is this useful?

Imagine you have some complex type, like:

```elm
type alias User = 
    { name : String
    , age : Int
    , role : Role
    }

type Role 
    = Regular
    | AdminLevel Int
```

You want to use `edkelly303/elm-any-type-forms` to build a form that will allow you to create/update values of your 
`User` type. You also want to use `miniBill/elm-codec` to generate JSON encoders and decoders for the `User` type.

### Boo! Boilerplate!

Without Elm MultiTool, you have to define your codec and form control separately, which means writing almost exactly the 
same code twice:

```elm
import Codec
import Control

userCodec = 
    Codec.object User
        |> Codec.field "name" .name Codec.string
        |> Codec.field "age" .age Codec.int
        |> Codec.field "role" .role roleCodec
        |> Codec.buildObject

userControl = 
    Control.record User
        |> Control.field .name Control.string
        |> Control.field .age Control.int
        |> Control.field .role roleControl
        |> Control.endRecord

roleCodec =
    Codec.custom 
        (\regular adminLevel tag ->
            case tag of 
                Regular -> 
                    regular
                
                AdminLevel level -> 
                    adminLevel level
        )
        |> Codec.variant0 "Regular" Regular
        |> Codec.variant1 "AdminLevel" AdminLevel Codec.int
        |> Codec.buildCustom

roleControl =
    Control.customType
        (\regular adminLevel tag ->
            case tag of 
                Regular -> 
                    regular
               
                AdminLevel level -> 
                    adminLevel level
        )
        |> Control.variant0 "Regular" Regular
        |> Control.variant1 "AdminLevel" AdminLevel Control.int
        |> Control.endCustomType
```
If you want to create controls and codecs for many types across your codebase, this could get tedious.

### Yay! Less boilerplate!

With Elm MultiTool, by contrast, you do a little bit of initial setup to define the tools you want to use in your 
application:

```elm
import Tools.Codec
import Tools.Control

type alias Tools codec control = 
    { codec : codec, control : control }

tools =
    -- The next line is not a typo - you *do* need to 
    -- pass `Tools` twice. If anyone can figure out 
    -- a way to make this work by only passing it once, 
    -- please let me know!
    MultiTool.define Tools Tools 
        |> MultiTool.add .codec Tools.Codec.interface
        |> MultiTool.add .control Tools.Control.interface
        |> MultiTool.end
```

And then you only need to write out the boilerplate once to create tool specifications (`ToolSpec`s) for each of your 
types:

```elm
userToolSpec = 
    tools.record User
        |> tools.field "name" .name tools.string
        |> tools.field "age" .age tools.int
        |> tools.field "role" .role roleToolSpec
        |> tools.endRecord

roleToolSpec =
    let
        match regular adminLevel tag =
            case tag of 
                Regular -> 
                    regular
                    
                AdminLevel level -> 
                    adminLevel level
    in
    tools.customType
        -- We need to define the `match` function using 
        -- let-polymorphism and then pass it to each of our tools 
        -- separately. If anyone can figure out a way to make 
        -- this work without having to pass the function multiple 
        -- times, please let me know!
        { codec = match, control = match } 
        |> tools.variant0 "Regular" Regular
        |> tools.variant1 "AdminLevel" AdminLevel tools.int
        |> tools.endCustomType
```

Now, to use your tools, you can just do:

```elm
userTools = 
    tools.build userToolSpec

control = 
    userTools.control -- this is identical to userControl

codec = 
    userTools.codec -- this is identical to userCodec
```

## Is it worth it?

If you only want JSON codecs and form controls for one small type, maybe not. 

But if you also want bytes codecs, test fuzzers, random generators, toStrings, toComparables, and so on for many of the 
types in your application, it could save a lot of time and trouble.

## Can I see some examples?

Sure! I've implemented basic (possibly quite buggy) versions of interfaces for a variety of tools: 

* `Tools.ToString` will convert your Elm value to a `String`
* `Tools.ToComparable` will convert your Elm value to a `comparable` (specifically, a `List String`)
* `Tools.Fuzz` creates a fuzzer for use with `elm-explorations/test`
* `Tools.Random` creates a random generator for use with `elm/random`

From the root folder, you can run the examples like this, using Simon Lydell's wonderful `elm-watch` tool:

```console
$ cd examples
$ npm i
$ . run.sh
```

## Notes

### How do I do advanced stuff, like configure form controls?

If you were using `elm-any-type-forms` directly, you could do something like this to customise a string control:

```elm
myStringControl = 
    Control.string
        |> Control.debounce 1000
        |> Control.failIf 
            String.isEmpty 
            "Field can't be blank"
```

With Elm MultiTool, you can achieve the same thing using the handy `tweak` functions:

```elm
myStringSpec = 
    tools.string
        |> tools.tweak.control 
            (Control.debounce 1000)
        |> tools.tweak.control 
            (Control.failIf 
                String.isEmpty 
                "Field can't be blank"
            )
```
It's similar to a `map` function, so you can use it to transform (or even replace) individual tools within a `ToolSpec`:

```elm
myStringSpec = 
    tools.string
        |> tools.tweak.control 
            (\_ -> 
                -- throw away whatever control we 
                -- had in tools.string, and use 
                -- this instead:
                Control.string
                    |> Control.debounce 1000
            )
```
