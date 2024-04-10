<h1>Lua Threading API (designed for CC:Tweaked/ComputerCraft)</h1>
<h3>This lightweight library designed for Minecraft mod called CC:Tweaked, and allows to run concurrent/pseudo asynchronous threads, using corouitines.</h3>
<h2>How to install it?</h2>
Just place `lib` folder anywhere, and include lib into your project using `require("/path/to/your/lib/folder/lib/thread")`.
Any other folder exept `thread` is not required, you can remove them.

<h2>Why?</h2>
This lib allows you to run many function simultaneously, but unlike parallel, threads can generate new threads and continue running.
Since computers in CC:T/ComputerCraft don't have cores, every thread you run, is running one-by-one, creating <i>pseudo asynchronous tasks</i>
<h4>Demo:</h4>

![Demo](https://github.com/mr-V01d/Treading-CC/assets/47479465/bd1d5383-f692-4df8-b7f3-36f4954930eb)


<h2>How to use:</h2>


```lua
local thread = require "lib.thread"
```

<h4>Warning!</h4>
This library requires to be started anywhere in your code. It is recomended to start master thread in start of your app/os, run your code as a thread.

```lua
thread.start()
```

<h3>TODO:</h3>

<ul>
    <li>Join thread</li>
    <li><b>Your idea</b></li>
</ul>

<h3>Conclusion</h3>

Feel free to open an issue, for bug, idea or something. Ask questions on discord: mrvoid__ or matrix chat: @mr-void:hackliberty.org


> This library under GPL-3.0 licence.
