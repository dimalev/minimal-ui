minimal-ui
==========

Minimal UI contains base classes for creating User Interface.

Currently consists of:
* Label (uses TextEngine, and _TextLabel_ which uses simple flash.text packet)
* Button (button with image, custom tailored buttons)
* Checkbox
* Containers (Independant layout _BaseContainer_, vertical _VBox_, horizontal _HBox_, clipping screen _ScrollControlBase_)
* Images from static resources

High level entities:
* Screen manager
* Application

Manages Styles of the elements by _Style_ class.

Modular XML + CSS based interface parse/constructor for easier UI construction and maintenance. Also, interface library constructors
may provide custom elements together with custom tailor XML factory to create interfaces.

Demo
----

TODO: construct some demo applications with win- and adobe-style designs. Some other demonstrations, like sci-fi, bio-punk and steam-punk interface libraries may be useful :)

Why?
----

Flex library is too heavy to use it in any application. Small games are usually sensitive, and adding 500kb of UI library does not look nice. Also tasks like ordering elements in the screen or another container are frequent and annoying, so layout controls are here to save the situation.

Externalized styling helps designers to play with design, while developer can stay focused on developing games, without thinking about how does it gonna look.