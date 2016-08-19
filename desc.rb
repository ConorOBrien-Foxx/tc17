# a compact descriptive language that compiles to ruby

$ends = []

##,$,.,:,;,?,@,C,D,E,F,I,R,_,g,i,l,r,s,u,w,~
commands = {
    "," => "stack.push 1 / stack.pop.to_f",
    "#" => "stack.pop if itb[stack.pop]",
    "$" => "stack.pop",
    "." => lambda { $ends.pop || "end" },
    ":" => "stack.push stack.last",
    ";" => "return stack.pop",
    "?" => "if itb[stack.pop]",
    "@" => lambda {
        $ends.push "break if itb[stack.last]\nend"
        "loop do"
    },
    "C" => "stack = []",
    "D" => "stack.concat stack",
    "E" => "stack.push bti[stack.pop.empty?]",
    "F" => "stack.push stack.pop.to_f",
    "I" => "stack.push stack.pop.to_i",
    "R" => "stack.push rand 0...stack.pop",
    "S" => "stack.push stack.pop.size",
    "_" => "stack.push -stack.pop",
    "g" => "stack.push stack.pop[stack.pop]",
    "i" => "stack.push input[stack.pop]",
    "l" => "stack.push bti[stack.pop >= stack.pop]",
    "r" => "stack.push rand",
    "s" => "return stack",
    "u" => "until itb[stack.last]",
    "w" => "while itb[stack.last]",
    "~" => "[stack.pop, stack.pop].each { |e| stack.push e }",
}

(0...16).each { |c|
    commands[c.to_s 36] = "stack.push #{c}"
}

["-", "*", "+", "/", "%"].each { |c|
    commands[c] = "b = stack.pop\na = stack.pop\nstack.push a #{c} b"
}

program = ARGV[0] == "-r" || ARGV[0] == "/r" ? open(ARGV[1], "r").read : ARGV.join(" ")

output = "
lambda { |input = []|
bti = -> (v) { v ? 1 : 0}
itb = -> (v) { v != 0 }
stack = []
"

program.chars.each { |char|
    unless commands.has_key? char
        puts "error: `#{char}` is an invalid instruction."
        exit
    end
    value = commands[char]
    value = value[] if value.class == Proc
    output += value + "\n"
}

output += "}"

# optimization
[
    [/stack\.push\s+(\d+)\r?\n(\w+)\s*=\s*stack\.pop/, '\2 = \1'],
    [/(\w+)\s*=\s*(\d+)\r?\n(\w+)\s*=\s*stack\.pop\r?\nstack.push\s+\3\s+(.+?)\s+\1/, 'stack.push stack.pop \4 \2'],
    [/stack\.push\s*(\d+)\r?\nstack\.push 1 \/ stack\.pop\.to_f/, 'stack.push 1.0 / \1'],
    [/stack\.push\s*(.+?)\r?\nstack\.push\s*(.+?)\r?\nstack\.push bti\[stack\.pop\s*(.+?)\s*stack\.pop\]/, 'stack.push bti[\2 \3 \1]'],
    [/stack.push\s*(.+?)\r?\nstack\.push\s*input\[stack\.pop\]/, 'stack.push input[\1]'] 
].each { |repl|
    output = output.gsub(*repl)
}

puts output.gsub(/(stack\.push[^A-Za-z]+?\r?\n){2,}/) { |lines| "stack.concat [#{lines.gsub(/stack\.push\s+|\r/m, "").split("\n").join(", ")}]\n"}.gsub(/stack = \[\]\r?\nstack.concat/, "stack =")