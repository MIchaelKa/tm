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

  INITIAL_STATE = 1
  END_STATE     = 0

  INITIAL_POS   = 0

  def initialize

    @state_number = 4;
    @character_number = 3;

    @programm = Array.new(@state_number) {
                Array.new(@character_number) {
                Hash.new()
                }}

    #program
    @programm[INITIAL_STATE][1] = { state: 1, character: 1, direction: RIGHT}
    @programm[INITIAL_STATE][0] = { state: 2, character: 1, direction: RIGHT}
    @programm[2][1] = { state: 2, character: 1, direction: RIGHT}
    @programm[2][2] = { state: 3, character: 2, direction: LEFT}
    @programm[3][1] = { state: 3, character: 2, direction: NONE}
    @programm[3][2] = { state: END_STATE, character: 2, direction: NONE}


    @current_state = INITIAL_STATE
    @position      = INITIAL_POS

    @tape = [1,1,0,1,1,1,2]

    @tape_head
    @control_unit

    @tape
  end

  def run

    while @current_state != END_STATE do
      print_tape
      character  = @tape[@position]
      state      = @current_state
      @current_state = @programm[state][character][:state]
      @tape[@position] = @programm[state][character][:character]
      case @programm[state][character][:direction]
      when RIGHT
        @position += 1
      when LEFT
        @position -= 1
      end
    end
  end

  def print_tape

    @tape.each do |i|
      print i
      print " "
    end
    print "\n"
    @position.times { print "  " }
    print "^"
    print "\n"
  end
end

TuringMachine.new.run()