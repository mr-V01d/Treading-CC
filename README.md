<h1>Lua Threading API (designed for CC:Tweaked/ComputerCraft)</h1>
<h3>This small api designed for Minecraft mod called CC:Tweaked, and allows to run concurrent threads, using corouitines.</h3>
<h2>How to install it?</h2>
Just place `lib` folder anywhere, and include api into your project using `require("/path/to/your/lib/folder/lib/Thread")`.
Any other folder exept `Thread` is not required, you can remove them.

<h4>Demo:</h4>

![Craftos](https://github.com/mr-V01d/Treading-CC/assets/47479465/13b8ab14-5074-4655-a2c9-6d76e47184f9)

<h2>Why?</h2>
This lib allows you to run many function simultaneously, but unlike parallel, threads can generate new threads and continue running.
<h4>Demo:</h4>

![Demo](https://github.com/mr-V01d/Treading-CC/assets/47479465/bd1d5383-f692-4df8-b7f3-36f4954930eb)


<h2>How to use:</h2>


```lua

thread = require "lib.mr_void.Thread"


function async_func()
    for i = 1, 5 do
        thread.add(async_for_i)
        sleep(30)
    end
end

function async_for_i()
    for i = 1, 10 do
        print("Some work, idk")
        sleep(1)
    end
end

thread.add(async_func)
thread.start()
```

<h3>Conclusion</h3>

Feel free to open an issue, for bug, idea or something. Ask questions on discord: mrvoid__ or at my [server](https://discord.gg/kKjeMJdkE8) <sub>if you care</sub>.


> This "project" under GPL-3.0 licence.
