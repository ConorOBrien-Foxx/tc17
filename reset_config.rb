require "json"

config = {
    "objective"     => 2048,
    "initial"       => "empty",
    "insert"        => "24a,rl#;",
    "cell width"    => 6,
    "start amount"  => 2,
    "field"         => {
        "width"  => 4,
        "height" => 4,
    },
}

open("config.json", "w").write config.to_json