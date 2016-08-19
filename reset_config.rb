require "json"

config = {
    "objective"     => 2048,
    "initial"       => "empty",
    "insert"        => "24a,rl#;",
    "insert rule"   => "@C0i:0~gSR~SRD0iggE.$s",
    "cell width"    => 6,
    "start amount"  => 2,
    "pretty"        => true,
    "field"         => {
        "width"  => 4,
        "height" => 4,
    },
}

open("config.json", "w").write config.to_json