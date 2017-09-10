# UIAlertView-HideAnyWhere
Hide currently visible UIAlertView objects without having direct references to them.

## Installation

Just drag the `.h` and `.m` files to your project source.

## Usage

For most use cases, `UIAlertView` objects are shown with a cancel button. The methods `avhaw_hideAll` and `avhaw_hideAllAnimated:` make use of this, and thus can be convenient to use instead of `avhaw_enumerateAlertViewsWithBlock:`.

You can use `avhaw_enumerateAlertViewsWithBlock:` if you want to dismiss `UIAlertView` objects your way.

## Why

Although deprecated, there are still projects that have `UIAlertView` objects scattered across the source. I had a friend who was in need for dismissing `UIAlertView` objects, but he didn't have references to them, nor could be traced from the view hierarchy. It was a tedious job to trace all the usages and expose those references.

## How it works

The `UIAlertView`'s `show` method is swizzled to add a weak reference to a map saved in the main thread's dictionary. The hide methods then enumerates that map to dismiss each `UIAlertView`.

## Credits

[NSHipster - Swizzling](http://nshipster.com/method-swizzling/)
