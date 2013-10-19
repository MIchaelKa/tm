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
      if File.exist? program_file_name
        print "Using program - " + program_file_name + "\n"
        if ARGV.size > 1 && ARGV[1].eql?("-tr")
          base_name = File.basename(program_file_name, File.extname(program_file_name))
          print "Trace file - #{base_name}_trace.txt\n"
          STDOUT.reopen(File.open("programs/#{base_name}_trace.txt",'w'))
        end
      else
        program_file_name = "programs/addition.txt"
        print "File does not exist, using default program - " + program_file_name + "\n"
      end
    else
      program_file_name = "programs/addition.txt"
      print "No args passed, using default program - " + program_file_name + "\n"
    end

    @program_file = File.open( program_file_name, "r" )
    @program = Array.new { Array.new { Hash.new }}

    #index -> character or state
    @character_alphabet = Array.new
    @state_alphabet     = Array.new

    @current_state = 0
    @final_state   = 0

    @position = INITIAL_POS
  end

  def run
    print "\nTrace of the machine's execution:\n\n"
    while @current_state != @final_state do
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
    if @program_file.readline.strip.eql? "initial state:"
      @current_state = push_in_alphabet(@state_alphabet,
                                        @program_file.readline.strip)
    else
      print "Error: could not find an initial state description. \n"
      return
    end
    #get final state
    if @program_file.readline.strip.eql? "final state:"
      @final_state = push_in_alphabet(@state_alphabet,
                                      @program_file.readline.strip)
    else
      print "Error: could not find a final state description. \n"
      return
    end
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

        character_alph_index     = push_in_alphabet(@character_alphabet,
                                                    instruction[OLD_CHARACTER_INDEX])
        state_alph_index         = push_in_alphabet(@state_alphabet,
                                                    instruction[OLD_STATE_INDEX])
        new_character_alph_index = push_in_alphabet(@character_alphabet,
                                                    instruction[NEW_CHARACTER_INDEX])
        new_state_alph_index     = push_in_alphabet(@state_alphabet,
                                                    instruction[NEW_STATE_INDEX])

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
      print "Parsing program for TM was successfully ended\n"
      print "State alphabet: "
      p @state_alphabet
      print "Character alphabet: "
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