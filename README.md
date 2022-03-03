# STM8 Blink

<span style="color:red"> Specifially setup to test issues with debugging, needs [this repo](https://gitea.twilkie.nz/STM8/STM8_Headers) to be cloned into the same directory to build. In its current state a single line in main needs to be un-commented to break debugging.</span>
## Intro
This is a baseline for STM8 projects on windows using SDCC, STVP, and OpenOCD on VSCode. It is the distillation of my work getting a toolchain set up from scratch where I feel like I have a good understanding of all the parts. Everything has been done to be as straighforward and beginner friendly as possible, after downloading the required software and adding things to PATH everything should just build right out of the box.
It simply blinks two pins out of phase, basically to confirm that the toolchain is working.

This is intended to be cloned and used as a base for future projects, reducing setup and making it as easy as possible for others to start using STM8 microcontrollers with largely open source software and absolutely minimal setup.

At this point multiple `.c` source and `.h` header files are supported. Just add any `.h` files to the `\inc` directory and `.c` files to `\src` and they will automatically be included at compile time. It would be simple enough to get files included from other loactions but for now this is enough (in the same way that all the SPL files are included from outside the project folder).
SPL headers will also be included both for Intellisense and compilation. They are expected to be in a directory at the same level as the project directory, essentially just clone the header repo in the same folder as the project repo.

There will ideally be capability to add libraries in the future but this will probably be dependant on getting dead code elimination (not supported by SDCC) working, for now just copying the source and header files into the project directory is good enough.

## Pre-reqs
Need to install:
- SDCC	    -	Download the latest win64 build from [HERE](https://sourceforge.net/projects/sdcc/files/)
- STVP	    -	Download from the STM site, [HERE](https://www.st.com/en/development-tools/stvp-stm32.html)
- Make	    -	Download [HERE](http://gnuwin32.sourceforge.net/packages/make.htm)
- OpenOCD   -   Download precompiled Windows binaries from [HERE](https://gnutoolchains.com/arm-eabi/openocd/)
- VSCode    -   Found [HERE](https://code.visualstudio.com/download), you will also need the "STM8 Debugging" extension for VSCode, found either through searching extensions within VSCode or from [HERE](https://marketplace.visualstudio.com/items?itemName=CL.stm8-debug)

Install all of these and add al of them to the system PATH. 

Then add STVP to path; Windows key -> "path" -> Edit the system environment variables -> Environment variables -> Path -> edit -> New -> Put in the path to you STVP install, this will be something like `C:\Program Files (x86)\STMicroelectronics\st_toolset\stvp`. Then press ok on all the boxes to exit. Do the same for SDCC, Make and OpenOCD (Make should offer this during installation but can be done manually).
Confirm they have been added to your path by opening powershell and typing in `sdcc`, `make`, `openocd`, and `stvp_cmdline`. All should give a help output or similar, it doesn't really matter what as long as it isn't red text saying "The term ... is not recognised ..." If this comes up then you haven't added it correctly and need to go back and confirm you've done the above.

The final step is getting the SPL headers from [HERE](https://gitea.twilkie.nz/STM8/STM8_Headers). Note that these are NOT the same as the SPL libraries directly from STM, they have been edited slightly to work with the SDCC compiler but are largely identical. Simply clone the repo into the same folder as your project folder.

The Makefile will need some edits to suit your particular part, specifically `OUTNAME`, `PROG_DEVICE`, and `PARTFAMILY` and possibly `PROGRAMMER` and `PROG_INTERFACE`.

## Building
The Makefile as currently setup has a few different tasks; `all`, `release`, `debug`, `clean`, and `flash`.
These all do different things. Each can be called in terminal with, for example `make flash`, with the exception of `all` which is the default and can be called with just `make`. 

### Build 
There are two build versions, *release* and *debug*. They can be seperately built using `make release` and `make debug` respectively. 

### Clean
Deletes all files in the release and debug directories. This seems to be necessary otherwise there are problems with SDCC failing to open files etc., ideally I'd get rid of it at some point but have not yet figured out how.
This only takes a few seconds and needs to be done before building, if you are still getting file opening or access errors then try extending the sleep time at the bottom of the Makefile to 2-4 seconds or even more.

### Flash
Calls the ST Visual Programmer over command line, `STVP_CmdLine`, and flashes the *release* build to the device described by `PROG_DEVICE`. Release must have been compiled before this point or it will fail. This has a few configuration options but as setup will work. The only tricky thing can be getting the right thing for `PROG_DEVICE`. The easiest way to do it is to open the actual STVP program (if it is added to path then just go to powershell and type in "stvp") and find your device in the 'Device' list under configure (with the correct hardware, port and programming mode selected).

### All
Does everything needed (and some things not necessary); cleans the build directory to ensure a complete rebuild, builds a release and debug version, and then flashes the built release firmware. This is just to reduce repetition of tasks. This could be easily streamlined by getting rid of the debug task.

## Debugging
The setup for debugging is minimal and all handled by the `launch.json` file in `/.vscode`. You will need to change the `cpu` and `target` to suit your device but this is straightforward. Putting an invalid option in to `cpu` will give you an error and on hover show a list of possible values for you to chose from. Equally the appropriate target file can be found by going to the install directory of OpenOCD, then `share\openocd\scripts\target` and inputting the appropriate file name for your device.
Once you have the STM8 Debugging extension installed and setup and have built the *debug* version, (`make clean` followed by `make debug`) simply press F5 or go Run->Start Debugging to launch the debugger. 
It isn't an incredible experience but it works and making it better is beyond my skills.