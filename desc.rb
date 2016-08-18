# a compact descriptive language that compiles to ruby

commands = {
    "r" => "stack.push rand",
    "," => "stack.push 1 / stack.pop.to_f",
    "l" => "stack.push bti stack.pop >= stack.pop",
    "#" => "stack.pop unless itb stack.pop",
    ";" => "return stack.pop",
    "." => "end",
    "?" => "if itb stack.pop",
    ":" => "stack.push stack.last",
    "_" => "stack.push -stack.pop",
    "i" => "stack.push input[stack.pop]",
    "I" => "stack.push stack.pop.to_i",
    "F" => "stack.push stack.pop.to_f",
}

(0...16).each { |c|
    commands[c.to_s 36] = "stack.push #{c}"
}

["-", "*", "+", "/", "**", "%"].each { |c|
    commands[c] = "b = stack.pop\na = stack.pop\nstack.push a #{c} b"
}

program = ARGV[0] == "-r" || ARGV[0] == "/r" ? open(ARGV[1], "r").read : ARGV.join(" ")

output = "
lambda { |input = []|
def bti(v)
    v ? 1 : 0
end
def itb(v)
    v == 0
end
stack = []
"

program.chars.each { |char|
    output += 'raise "command `#{char}` is invalid."\n' unless commands.has_key? char
    output += commands[char] + "\n"
}

output += "}"

puts output