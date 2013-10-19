tm
==
#####Simulation of Turing Machine
>A Turing machine is a hypothetical device that manipulates symbols on a strip of tape according to a table of rules.  
>[For more information, see wiki page](http://en.wikipedia.org/wiki/Turing_machine) 

#####Programs for tm
Every instruction of the program is a quintuple consisting of a state, a character, another state, another character, 
and a direction to move the tape. 
An instruction cycle begins as the control unit compares the current state and the tape character under the tapehead 
with the first two members of every instruction quintuple. 
By the rules of Turing machine programming, there is at most one quintuple with any particular state-character 
initial pair (and there may be none).  
Description from "Etudes for programmers" by Charles Wetherell.  
Every program must contain an initial tape description, initial state, final state and set of quintuple.  
*Example:*
```
tape:
*** **xxxx
initial state:
1
final state:
4
program:
1,*,1,*,right
1, ,2,*,right
2,*,2,*,right
2,x,3,x,left
3,*,4,x,none
```
See more examples in /programs foulder

#####Using
Pass to comand line a file name with program and you will see a trace of the machine's execution 
and the final value on the output tape.  
You can also print -tr after file name to write all results to file.  
File with results will be create with "_trace.txt" postfix.  
*Example:*
```
test_tm.rb programs/multiplication.txt -tr
```
#####Sample of tm trace (programs/multiplication.txt)
```
Parsing program for TM was successfully ended
State alphabet: ["q0", "end_state", "q1", "q2", "q3", "q4", "q6", "q5", "q7", "q8"]
Character alphabet: ["*", "1", "x", "a", "=", " "]

Trace of the machine's execution:

-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
 ^
 q0
-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
   ^
   q0
-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
     ^
     q0
-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
       ^
       q0
-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
         ^
         q0
-------------------------------------------
|*|1|1|1|x|1|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
           ^
           q1
 ...
 -------------------------------------------
|*|1|1|a|x|a|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
               ^
               q4
-------------------------------------------
|*|1|1|a|x|a|1|=|*| | | | | | | | | |*|*|*|
-------------------------------------------
                 ^
                 q4
-------------------------------------------
|*|1|1|a|x|a|1|=|1| | | | | | | | | |*|*|*|
-------------------------------------------
                   ^
                   q5
-------------------------------------------
|*|1|1|a|x|a|1|=|1|*| | | | | | | | |*|*|*|
-------------------------------------------
                 ^
                 q2
-------------------------------------------
|*|1|1|a|x|a|1|=|1|*| | | | | | | | |*|*|*|
-------------------------------------------
...
-------------------------------------------
|*|1|1|1|x|a|a|=|1|1|1|1|1|1|*| | | |*|*|*|
-------------------------------------------
               ^
               q7
-------------------------------------------
|*|1|1|1|x|a|a|=|1|1|1|1|1|1|*| | | |*|*|*|
-------------------------------------------
             ^
             q8
-------------------------------------------
|*|1|1|1|x|a|1|=|1|1|1|1|1|1|*| | | |*|*|*|
-------------------------------------------
           ^
           q8
-------------------------------------------
|*|1|1|1|x|1|1|=|1|1|1|1|1|1|*| | | |*|*|*|
-------------------------------------------
         ^
         q8
-------------------------------------------
|*|1|1|1|x|1|1|=|1|1|1|1|1|1|*| | | |*|*|*|
-------------------------------------------
         ^
         end_state
```
#####Using in other projects:
```ruby
require './tm.rb'
tm = TuringMachine.new
tm.parse_tm_program
tm.run
```
