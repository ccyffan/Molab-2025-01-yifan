let decorations = ["☁️", "🌟", "🎩", "💡", "🦜", "👑", "🍀", "⚡️"]


let eyes = ["o,o", "O,O", "°_°", "-,-", "x_x", "^_^", "@_@", "•_•"]


let beaks = ["{ \" }", "{ - }", "{ * }", "{ ~ }", "{ ^ }", "{ . }", "{ # }", "{ = }"]

// randomly decorate eyes and beak
let randomDecoration = decorations.randomElement() ?? ""
let randomEyes = eyes.randomElement() ?? "o,o"
let randomBeak = beaks.randomElement() ?? "{ \" }"

// bird ascii
let bird = """
      \(randomDecoration)
      \\  /
     (\(randomEyes))
     \(randomBeak)
     -"-"-
"""

print(bird)
