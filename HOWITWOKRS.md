# How does it all work?

Fair warning: If you don't want to hear some in-depth information about Linux and X, as well as some quirky, nerdy stories, you are in the wrong place. If that sort of thing is your cup of tea, keep reading...

## A brief history of X

In the beginning, there was only the commandline. And the framebuffer was vast and empty and much space and productivity was wasted.

So the Great Gurus spake among themselves, saying "Let us create a window system that our users may be freed to use the space on the screen each in their own way!"

And so, the Great Gurus created the X11 framework. In those days people were expected to handle bootstrapping it and setting the environment up correctly on their own. That kept most luzers out completely and annoyed even a lot of nerds.

*Between 1984 and 1987, the first practical - for certain values of practical - graphical interface for Unix was developed*

And there was a lot of grumbling. So the nerds went to the Great Gurus and spake unto them thusly: "Using X11 is a great pain in the patootie, and the luserz keep bugging us to set it up for them"

And the Great Gurus showed mercy and wrote xinit, and taught people how to create an .xinitrc or .xsession to easily start their sessions with a single startx command. But people still had to log in on the text console and start their X11 manually. 

*Around the same time in the late 1980s, xinit was developed. startx as a wrapper around it likely came around a little later to further faciliate starting an X environment*

And there was a great gnashing of teeth from the luserz. They went to the Great Gurus and spake unto them thusly: "We hate the ugly text console we don't understand!"

So the Great Gurus showed mercy once more and wrote the first display managers to let people log in without seeing the text console they despised. But there still were only a very few very rudimentary window managers and people were expected to run their applications from the console or an xterm window via CLI.

*In the early 1990, display managers, probably the first of them xdm, allowed a graphical login to the system for the first time*

And there was a great clamoring from the luzers. They went to the Great Gurus and spake unto them thusly: "We still have to use the bloody commandline we hate and remember all those cryptic commands we don't understand. Can't there be simple buttons and switches like simple machines have?"

So the Great Gurus showed mercy a third time and wrote the first desktop environments with launchers and task bars. But the luzers thought they were ugly and unsightly and looked upon them with disgust.

*In the mid 1990s, the first desktop environments appeared on the scene. CDE was the first in 1993, followed by KDE in 1996. Gnome, now one of the most popular DEs, wouldn't be released until 1999*

And there was a great nagging from the luzers. They went to the Great Gurus and spake unto them: "The graphics are still ugly and primitive, can't you make them flashy and pretty like on Windows and Mac?

And the Great Gurus said: "Hell no. That would be a terrible waste of valuable system resources. We won't do it." Having thus spoken, they turned away and went to do more useful and interesting things.

So the luzers turned to the lesser geeks who had plenty of enthusiasm and knowledge, but not the wisdom of the Great Gurus, and when they put their wishes before them, those spake thusly: "Sure, that will be great! We'll have transparency and wobbly windows and desktop cubes and ripples following the pointer and snow flakes! It will be SO cool!" 

And they went and created ever more elaborate and wasteful graphical effects until you needed a $1000 graphics card just to run a simple graphical desktop environment.

*In the early 2000s, window managers like kwin became more and more elaborate and customizable, and the first graphical effects began to appear. Compiz and Beryl appeared in 2006. By the time Windows users marveled at transparent title bars and a shuffle stack window switcher in 2007, bleeding edge Linux users had wobbly windows, desktop cubes, shuffle stacks, rain and water effects, and many, many more. That sturm and drang era of compositing and desktop effects lasted well into the second half of the first decade of the 21st century. From 2010 on, compositing and effects became more mainstream and mundane, and the more extreme expressions of the early Kambrian Explosion of desktop effects all but valished.*

But the faithful few who still minded the Great Gurus and their great wisdom kept careful watch, that none of the old wisdom would be lost. They burried it deep in the distros and package managers and kept it in good working order, never doubting, never faltering in their vigilance.

And so it lies dormant to this very day, ready to be used by those who are pure of heart and have eyes to see, to create beautiful, elegant and simplistic X setups that the Great Gurus once envisioned for their faithful children.

*X11 never lost any major parts of its toolbox. Many tools from "back when" are even still in use, buried deep in in the stack of modern desktop environments. They all still work, and allow those who have the knowledge to create extremely slim and streamlined configurations.*

## The bare-bones X server

### Why the $%&@ would I want that?

#### My own journey to a minimal X11

I personally have a checkered history with X. I started with KDE3, hated KDE4 for brazenly steamrollering over everything the users had built for themselves over the years, used Gnome for a while, went back to KDE4 after it settled a bit, enthused over the compositing craze of the mid 2000s (Boy did I go over the top, if only to bum out my Windows-enthralled acquaintances("Oh you have *transparent boders* now? Let me show you something...")).

One day, after another update had broken another carefully crafted config, or my graphics card driver conked out again, or whatever, I honestly don't even remember, I went all Diogenes-Eremite-Zen-Buddhist-Ascetic-Berserker on my setup, threw out all the bling and shiny kit and kaboodle, and created the most ascetic, most bare-metal setup you can (or probably can't, most people react positively shell-shocked when they see it for the first time) imagine. That's where my journey into the history and the nuts and bolts of X11 began. I have never looked back.

#### The benefits of a bare-bones install

Desktop environments offer a lot of creature comforts, but they come at a price: If you have a requirement or use case they are not designed for, they fight you tooth and nail. More comfort creates more complexity, and more complexity means more opportunities to do do stuff you don't want or just plain break.

For many fringe use cases, like kiosks, digital signage or, incidentially, MagicMirror, that comfort is not someting you want, need or will ever benefit from, but you will still feel the negative effects in resource usage, complexity and all the problems that brings with it.

Since these specific, tailored setups are quite easy to create once you get the hang of it, they are a great arrow in your quiver for cases like that.

Here's a story about a config I once built, which may serve to illustrate the broad range of use cases one may find for such a setup if one keeps an open mind: My 80-year-old grandfather was an avid writer, but he struggled with computers a lot. He would accidentially minimize, close or move his windows and not remember how to get them back. But he would insist on benefitting from that modern achievement. So I created a minimalist X setup that started an Open Office writer instead of a window manager. Since there was no window manager, he could not move, resize or close the window accidentially, and if he somehow managed to close or crash it, it would just instantly restart.

Remember: The Americans spent years and millions on developing a ball-point pen that could write in zero gravity. The Russians used a crayon.

### How does X work?

#### X

The X server itself, the thing that lives under /usr/bin/X11, is pretty much a one-trick pony. It receives messages from processes that connect to it about which area of the screen they want to be on, and what they want to be put there, keeps track of the z order of client areas and decides which part of each window it should render. There of course is more to it, what with all the drivers and compositing onto virtual surfaces and applying effects and whatnot, but in a nutshell, that is still what it comes down to.

It's perfectly possible to run just a plain X server process on its own, but it's not much fun nor much use unless you put in the work to set up its working environment in such a way that it understands what to do with all the inputs and outputs, and how processes will connect to it and whatnot.

#### xinit

This is where xinit comes in. Xinit is like a personal secretary for X, it provides the diva X with it's habitual surroundings and creature comforts. It also does very rudimentary session handling, making sure the Xserver is disposed of when the user no longer wants it. To that end, after starting the X server, it executes a user-supplied shell script, which it expects to remain alive for the duration of the user's session. One usually starts a persistent process as the last command of that script, normally a window manager or the orchestrator of a desktop environment. As long as that process remains running, the script does not terminate. As long as the script does not terminate, the X server stays alive. Once the shell that ran that script DOES terminate, xinit will terminate the X server and exit.

#### Window managers

Window managers are what gives windows their habitual look and feel with borders, title bars, close and minimize buttons and all that jazz. On their own, X windows are just featureless rectangles that just sit there. They don't react to the mouse in any other way than what their underliying process does with the input events it is handed by the X server. They can't be resized, moved or even closed by mouse interaction at all.

Window managers provide handles to manipulate windows. They attach to each X window, decorate it and react to interactions with their decorations in specific ways, like repositioning or scaling the window when you drag on the border or the title bar - which they render for you. Techically a window manager and a window decorator can be two different things, and in highly customizable environments they usually are, but a simple window manager will usually just do both. Often those window managers will include a way to terminate them, which in turn causes the init script to end and the X session to be finalized - see the paragraph on xinit. In very rudimentary window managers, you simply terminate the process to end your X session.

It should be noted that while using an X window setup without any window manager in daily life is for all practical purposes next to impossible, a window manager is by no means a *technical* necessity. After all, all they do is send commands to the X server which does the actual work. There are tools to scale, reposition or otherwise manipulate windows by CLI commands alone.

#### startx

Startx is simply a thin wrapper around xinit. It mainly decides how user config is handled in the session and also makes sure that, depending on order of presence, some variant of an xinitrc file is selected to be used. If nothing else is provided, /etc/X11/xinitrc is usually the fallback.

#### Desktop environments

DEs are usually complicated conglomerates of processes, busses, tools and configurations that together make up the seamless experience of the DE. They normally come with a to mere mortals totally incomprehensible baggage train of daemons, configuration registries and tools to make all that chaos manageable. It's very interesting to dive into them and explore to what lengths they have to go to provide that incredibly smooth, polished user experience, but for the purpose of setting up a minimal X server, their bloated, incomprehensible, generalist, one-size-fits-all architecture is precisely the opposite of what we want

### How to set up a minimal X configuration

For the purpose of this discussion, let's define a "minimal X configuration" as one that achieves the required task at or near the peak of diminishing returns. You could always get more elaborate, more specific, more minimal if you are prepared put in the required extra work, but there is no benefit in going more minimal than the situation requires just because it's possible. For instance, it would certainly be possible to re-write the X server to only accept a single, full screen window, but it would be a tremendous effort to do so, eat up lots of maintenance, and frankly, I haven't the slightest idea what loony requirement might force you to do so.

Usually, the purpose of creating a minimal X setup is to run a very specific set of graphical applications with either reduced resource consumption, increased stability, increased control, or a combination thereof. The precise details then depend on the specific situation.

As an example, when I created the setup for my grandfather, I had the X server run as an user process in a fairly standard autologin configuration. I was not constrained by memory, runtime or disk usage, so going more bare-metal than I had to would not have yielded any additional benefit. My main concern was constraining the user's actions to what I wanted him to be able to do.

When I created mm-install however, I chose to omit the autologin and run both the X server and the magic mirror as system processes. For technical reasons I won't get into here, that meant the X server had to be run as root. I did not however want the magicmirror processes to run as root, so I chose to set it up not as part of the X configuration proper, but as a separate service that merely connects to the X server.

## What the script does

### What packages and why?

Besides the node.js packages, the script installs the following:

#### xserver-xorg-core

This contains the basic X server, the Xorg binary, as well as some drivers and other stuff to get a minimal X server running. The setup It arguably be slimmed down a little more if one sifted through the dependency list of xserver-xorg-core and selected only those packages absolutely necessary.

#### xinit

The xinit binary handles the bootstrapping and management of the X server. Getting and keeping an X server running without it is definitely possible, but getting all the rights management and environment right is an *extremely* difficult and tedious process.

#### xserver-xorg-legacy

Recently, xorg changed some of the authentication and bootstrapping stuff that makes it basically impossible to do the stuff this script does. This package contains some config for backwards compatibility which allows you to do the kind of shenanignas I do once more.

#### x11-xserver-utils

This contains utilities like xrandr, xsetroot and other goodies left over from the early days of X, when what we are doing here now was the norm and not the crazy tomfoolery of a quirky old nerd

#### git

Duh! If you can't figure **that** one out by now...

#### ca-certificates curl gnupg

This stuff is needed to set up nodesource. Actually, most of it comes installed stock, but we want to make it clear that we want to keep it in case somebody decides to slim down their image even more

#### libatk1.0-0 libatk-bridge2.0-0 libcups2 libgtk-3-0

This stuff is needed to run electron

#### python3-pip

Quite a few modules require python, so it's propably not a bad thing to have it

#### xli

A minimal X image viewer capable of rendering an image onto the root window, useful for setting up a custom background image in case somebody isn't happy with a plain black background. I like having an image that displays the message "MagicMirror2 isn't running"
