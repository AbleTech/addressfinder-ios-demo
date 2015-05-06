# AddressFinder iOS Demo
This repo contains an example of how you can use the AddressFinder API in an iOS application.

## Getting Started
A demo application is included in the `AFAutoCompleteDemo` folder.

1. Clone the repo and open the Xcode project.
2. Sign up at https://addressfinder.nz to get a licence key (it's free!).
3. Add your key & secret to the `AddressFinder.plist` file.
4. Run the application!

The demo application should now work providing you have added your AddressFinder credentials to the .plist.

![Screenshot](http://i.imgur.com/qQIiZxk.png)

## Adding AddressFinder to your own application
Adding AddressFinder to your own application is an easy task. Here we have provided `AFAutoComplete` for you to use in your own iOS projects.
You can simply add a `UITextField` to your View, and change the class to `AFAutoComplete`.

To do more with the address data you can implement the following optional method:

`- (void)textField:(AFAutoComplete *)textField didEndEditingWithSelection:(NSDictionary *)result`

Here you are provided with the `Full Address` and `Pxid` (unique identifier) which you can use to call other AddressFinder APIs to get even more information.
To view all available AddressFinder APIs please visit here: https://addressfinder.nz/docs/

In the demo app we have implemented this method and are calling the AddressFinder Address Info API (https://addressfinder.nz/docs/address_info_api/) to retreive line-by-line address information, and extra information such as the latitude and longitude of the address.


## Acknowledgements
The `AFAutoComplete` class uses modified code from th eMPGTextField (https://github.com/gaurvw/MPGTextField) project.
Huge thanks to all contributors in that project ❤️.

## License
This code is licensed under the MIT License.

The MIT License (MIT)

Copyright (c) 2015 Abletech

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
