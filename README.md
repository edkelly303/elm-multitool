# Elm MultiTool

## What does it do?

This package allows you to compose "tools", where a tool is any Elm package that
exposes an interface similar to `miniBill/elm-codec` and 
`edkelly303/elm-any-type-forms`.

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

You want to use `edkelly303/elm-any-type-forms` to build a form 
that will allow you to create/update values of your `User` type. You also 
want to use `miniBill/elm-codec` to generate JSON encoders and decoders for the 
`User` type.

### Boo! Boilerplate!

Without Elm MultiTool, you have to do everything twice:

```elm
import Codec
import Control

userCodec = 
    Codec.object User
        |> Codec.field "name" .name Codec.string
        |> Codec.field "age" .age Codec.int
        |> Codec.field "role" .role roleCodec
        |> Codec.buildObject

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

userControl = 
    Control.record User
        |> Control.field "name" .name Control.string
        |> Control.field "age" .age Control.int
        |> Control.field "role" .role roleControl
        |> Control.end

roleControl =
    Control.customType
        (\regular adminLevel tag ->
            case tag of 
                Regular -> 
                    regular
               
                AdminLevel level -> 
                    adminLevel level
        )
        |> Control.tag0 "Regular" Regular
        |> Control.tag1 "AdminLevel" AdminLevel Control.int
        |> Control.end
```
If you want to create controls and codecs for many types across your codebase, this could get tedious.

### Yay! Less boilerplate!

With Elm MultiTool, by contrast, you do a little bit of initial setup to define the tools you want to use in your application:

```elm
import Tools.Codec
import Tools.Control

myAppTools =
    MultiTool.define
        (\codec control ->
            { codec = codec
            , control = control
            }
        )
        |> MultiTool.add Tools.Codec.interface
        |> MultiTool.add Tools.Control.interface
        |> MultiTool.end
```

And then you only need to write out the boilerplate once for each of your types:

```elm
userToolsDefinition = 
    myAppTools.record User
        |> myAppTools.field "name" .name myAppTools.string
        |> myAppTools.field "age" .age myAppTools.int
        |> myAppTools.field "role" .role roleToolsDefinition
        |> myAppTools.endRecord

roleToolsDefinition =
    let
        match regular adminLevel tag =
            case tag of 
                Regular -> 
                    regular
                    
                AdminLevel level -> 
                    adminLevel level
    in
    myAppTools.custom 
        -- this part of the API is a bit nasty - we need
        -- to use `MultiTool.matchN`, where `N` is the 
        -- number of tools we've included in myAppTools.
        -- If anyone can figure out a way to make this 
        -- work without relying on let-polymorphism, please
        -- let me know!
        (MultiTool.match2 match match) 
        |> myAppTools.tag0 "Regular" Regular
        |> myAppTools.tag1 "AdminLevel" AdminLevel myAppTools.int
        |> myAppTools.endCustom
```

Now, to use your tools, you can just do:

```elm
userTools = 
    myAppTools.build userToolsDefinition

control = 
    userTools.control -- this is identical to userControl

codec = 
    userTools.codec -- this is identical to userCodec
```

## Is it worth it?

If you only want JSON codecs and form controls for one small type, maybe not. 

But if you also want bytes codecs, test fuzzers, random generators, toStrings, toComparables, and so on for many of the types in your application, it could save a lot of time and trouble.

## Run the examples

```console
foo@bar:~$ cd examples
foo@bar:~$ npm i
foo@bar:~$ . run.sh
```
