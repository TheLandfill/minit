# cpp_init
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Creates a bare project for cpp files with a Makefile included.

## Installation

```
git clone https://github.com/TheLandfill/cpp_init.git
cd cpp_init
./install.sh
```

If you want, you can change the name of the command. Read the install.sh script for more info.

## Usage
```
cpp_init project_name executable_name
```

This command will

-  Create a new directory for your project named `project_name`
-  Create subdirectories inside `project_name`
    -  Create `bin`, where your Makefile and executable will end up
    -  Create `obj`, where your .obj and .d (dependency files) are stored
    -  Create `src`, where you should put your cpp files.
    -  Create `includes`, where you should put your .h files.
    -  Create `libs`, where you should put external libraries or links to external libraries
-  Copy the Makefile you downloaded into the `bin` folder and change the product name

## Extensions

Right now, the Makefile assumes that you're using `g++` and a bunch of flags that you might want to change. If this gets enough interest, I could probably rewrite `install.sh` to automatically set a compiler. Regardless, you can do it manually if you want.

You can also create other directories and modify your project's Makefile to include/compile them. For instance, I generally create an `external_includes` directory.

## License

This project uses the MIT license.
