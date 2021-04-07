## Why am I sharing this>

* Its good to tinker with things.
* Explore ideas, do comparisons.
* Just fool around with no true end goal.

### This first started with me wanting to build a question / answer game in Ruby game to teach my play with my son. 

* As well my continued Ruby refresh. (After x years of writing Elixir)


`$> ruby bas3.rb` to start simple server - Ruby.

`$> nc localhost 1337` to connect.

### Then in evolved into a small deep dive into connecting apps via Erlang :gen_tcp

* The goal was to talk to the Ruby process via the Elixir app.
* Right now  unsuccessful in getting the responses back from the Ruby processes to propobate back to the Elixir netcat after first launch.
* I think it has to do with undersanding connection configurations 

`elixir elixir-vsn/server.ex`

`nc localhost 1339` 

### Findings

* Loops and Servers Ruby are much simpler to get up and running.
* Keeping connections alive are are much more robust in Erlang/Elixir.
* Having to setup isolated processes with specific use cases in Elixir - helps you identify what could be potentially wrong in the elixir client.

* Harder to identify on the Ruby side without getting into threads, fibers, etc. ( I maybe way off ont this - becuase its been a while paid attention to how ruby handles sockets)



