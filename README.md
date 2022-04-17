# AppBuilding 

My subjective view on building apps for iOS with swift in Xcode

## Layers 

Layer - fully independent part of program with provide some kind of service 

``` Nerwork ``` 

- repository
- interface of api
- classes which confirm api interface

``` Design ``` 

- colors
- dark/light mode 
- Button, TextFiled etc styles 

``` Navigation ``` 

Main app navigation hierarchy

``` Localisation ``` 

Has files for app localisation 

``` Modules ``` 

Can be created be different arhitectual patterns as Apple MVC, MVP, MVVM, VIPER

Represent small part of program which use Design, Network, Localisation, Utils layers 

``` Utils ```

- Extensions



