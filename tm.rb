# Touring Turing
# or...
# simulation of
# Turing Machine
# 
# based on
# Charles Wetherell - "Etudes for programmers"
# 
# code by
# Michael Kalinin
# 2013

class TuringMachine

  RIGHT = :right
  LEFT  = :left
  NONE  = :none

  INITIAL_STATE = 0
  END_STATE     = 3

  INITIAL_POS   = 0

  #indexes in one instruction
  #every instruction must be a quintuple
  OLD_CHARACTER_INDEX = 1
  NEW_CHARACTER_INDEX = 3

  OLD_STATE_INDEX = 0
  NEW_STATE_INDEX = 2

  DIRECTION_INDEX = 4

  def initialize

    if ARGV.size > 0
      program_file_name = ARGV[0]
      print "Using program - " + program_file_name + "\n"
    else
      program_file_name = "test_pr.txt"
      print "No args passed, using default program - " + program_file_name + "\n"
    end
    @program_file = File.open( program_file_name, "r" )
    @program = Array.new { Array.new { Hash.new }}

    #index -> character or state
    @state_alphabet = Array.new
    @character_alphabet = Array.new

    @current_state = INITIAL_STATE
    @position      = INITIAL_POS
  end

  def run
    while @current_state != END_STATE do
      print_tape

      character  = @character_alphabet.index @tape[@position]
      state      = @current_state

      @tape[@position] = @character_alphabet[@program[state][character][:character]]
      @current_state   = @program[state][character][:state]

      case @program[state][character][:direction]
      when RIGHT
        @position += 1
      when LEFT
        @position -= 1
      end

      if @position < 0
        print "Error: current head position out of bounds. \n"
        return
      end
    end
    print_tape
  end

  def print_tape
    #up line
    @tape.size.times { print "--" }
    print "-\n"
    #tape
    print "|"
    @tape.each do |i|
      print i
      print "|"
    end
    print "\n"
    #bottom line
    @tape.size.times { print "--" }
    print "-\n"
    #head position
    @position.times { print "  " }
    print " ^\n"
    #head state
    @position.times { print "  " }
    print " #{@state_alphabet[@current_state]}\n"
  end

  def parse_tm_program
    #get tape
    if @program_file.readline.strip.eql? "tape:"
      @tape = @program_file.readline.strip.split(//)
    else
      print "Error: could not find a tape description. \n"
      return
    end
    #get initial state

    #parse program
    if @program_file.readline.strip.eql? "program:"
      while !@program_file.eof do
      	#get a quintuple
        instruction = @program_file.readline.strip.split(",")
        if instruction.size != 5
          print "Error: every instruction must be a quintuple and " +
                "all characters must be devided by ','.\n"
          return
        end

        state_alph_index = push_in_alphabet(@state_alphabet, instruction[OLD_STATE_INDEX])
        character_alph_index = push_in_alphabet(@character_alphabet, instruction[OLD_CHARACTER_INDEX])

        new_state_alph_index = push_in_alphabet(@state_alphabet, instruction[NEW_STATE_INDEX])
        new_character_alph_index = push_in_alphabet(@character_alphabet, instruction[NEW_CHARACTER_INDEX])

        direction = instruction[DIRECTION_INDEX].to_sym
        if ( direction != RIGHT &&
        	 direction != LEFT  &&
        	 direction != NONE )
          print "Error: invalid direction.\n"
          return
        end

        next_instruction = Hash.new
        next_instruction[:state]     = new_state_alph_index
        next_instruction[:character] = new_character_alph_index
        next_instruction[:direction] = direction

        while state_alph_index >= @program.size do #need to refactor it
          @program.push Array.new
        end

        while character_alph_index >= @program[state_alph_index].size do
          @program[state_alph_index].push Hash.new
        end

        @program[state_alph_index][character_alph_index] = next_instruction        
      end #while !@program_file.eof
      p @program
      p @state_alphabet
      p @character_alphabet
    else
      print "Error: could not find a program description.\n"
      return
    end

  rescue EOFError => error
    print "Error: could not parse program - unexpected EOF.\n"
    print error.message
    print error.backtrace    
  end
  
  #return item's index in alphabet
  def push_in_alphabet(alphabet, item)
    index = alphabet.index item
    if index.nil?
      alphabet.push item
      index = alphabet.size - 1
    end
    return index
  end

end

#TuringMachine.new.run()
tm = TuringMachine.new

tm.parse_tm_program
tm.run