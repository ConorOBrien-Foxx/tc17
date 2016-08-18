require "io/console"
require "json"

def get_char
    val = STDIN.getch
    exit(1) if val === "\x03"
    val
end

def choice(prompt, opts)
    print prompt
    opt = ""
    loop do
        opt = get_char
        break if opts.include? opt
    end
    print opt
    puts
    opt
end

def clear
    system "clear" or system "cls"
end

class Cell
    def initialize(val)
        @value = val
        @marked = false
    end
    
    attr_accessor :value
    attr_accessor :marked
    
    def mark
        @marked = true
    end
    
    def unmark
        @marked = false
    end
    
    def empty?
        @value == :empty
    end
    
    def clone
        Cell.new @value
    end
end

def vals_of(row)
    row.map { |e| e.value }
end

def vals_of_grid(grid)
    grid.map { |row| vals_of row }
end

def same_grid(gridA, gridB)
    vals_of_grid(gridA) == vals_of_grid(gridB)
end

def disp(grid)
    grid.each { |row|
        row.each { |cell|
            if cell.value == :empty
                print " " * ($cell_width - 1)
            else
                print cell.value.to_s.rjust $cell_width - 1
            end
            print " |" unless cell == row.last
        }
        print "\n" + (("-" * $cell_width + "+") * $field_width).chop unless row == grid.last
        print "\n"
    }
end

def rotate_right(grid)
    grid.clone.transpose.map &:reverse
end

def rotate_left(grid)
    grid.clone.map(&:reverse).transpose
end

def collapse(i_row)
    row = i_row.map { |e| e.clone }
    loop do
        p_row = row.clone
        ind = row.length - 1
        while ind > 0
            ind -= 1
            cell = row[ind]
            n_cell = row[ind + 1]
            if n_cell.empty?
                row[ind], row[ind + 1] = row[ind + 1], row[ind]
            elsif !cell.empty? && cell.value == n_cell.value && !cell.marked && !n_cell.marked
                row[ind] = Cell.new :empty
                row[ind + 1].value *= 2
                row[ind + 1].mark
            end
        end
        break if vals_of(row) == vals_of(p_row)
    end
    row.each { |e| e.unmark }
    row
end

def collapse_right(grid)
    grid.map { |row| collapse row }
end

def collapse_up(grid)
    rotate_left collapse_right rotate_right grid
end

def collapse_down(grid)
    rotate_right collapse_right rotate_left grid
end

def collapse_left(grid)
    collapse_right(grid.map(&:reverse)).map &:reverse
end

def insert_rand_cell(grid)
    return grid if grid.all? { |row| row.none? &:empty? }
    r_x = 0
    r_y = 0
    loop do
        r_x = rand 0..3
        r_y = rand 0..3
        break if grid[r_y][r_x].empty?
    end
    
    grid[r_y][r_x] = Cell.new $insert[]
    grid
end

config_file = open(ARGV[0] || "config.json")
config = JSON.parse config_file.read

initial = config["initial"]
initial = :empty if initial == "empty"

$insert = eval %x(ruby desc.rb "#{config["insert"]}")
$cell_width = config["cell width"]
$field_width = config["field"]["width"]
$field_height = config["field"]["height"]

field = Array.new($field_height) { Array.new($field_width) { Cell.new initial } }

(config["start amount"] - 1).times {
    field = insert_rand_cell field
}

objective = config["objective"]
# objective = ARGV[0] ? ARGV[0].to_i : 2048

loop do
    clear
    puts "Objective: #{objective}"
    field = insert_rand_cell field
    disp field
    if field.any? { |row| row.any? { |e| e.value == objective } }
        puts "Congratulations! You win!"
        continue = choice "Play again? [yn] ", "yn"
        exit 1 if continue == "n"
        objective *= 2
        redo
    end
    
    w_field = collapse_up field.clone
    a_field = collapse_left field.clone
    s_field = collapse_down field.clone
    d_field = collapse_right field.clone
    
    keys = ""
    keys += "w" unless same_grid(w_field, field)
    keys += "a" unless same_grid(a_field, field)
    keys += "s" unless same_grid(s_field, field)
    keys += "d" unless same_grid(d_field, field)
    
    if keys.empty?
        puts "No more moves available! Game over."
        continue = choice "Try again? [yn] ", "yn"
        exit 1 if continue == "n"
        field = Array.new($field_height) { Array.new($field_width) { Cell.new initial } }
        redo
    end
    
    input = choice "", keys
    
    field = w_field if input == "w"
    field = a_field if input == "a"
    field = s_field if input == "s"
    field = d_field if input == "d"
end