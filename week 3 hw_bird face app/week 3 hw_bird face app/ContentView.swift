import SwiftUI

struct ContentView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let numberOfFaces = 8//bird number

    @State private var fingerPosition: CGPoint = .zero
    @State private var birdPositions: [CGPoint] = []
    @State private var birdColors: [Color] = [] // bird colors
    @State private var grassPattern = UUID() // grass moving

    var body: some View {
        ZStack {
            // grass background,print10
            Print10Maze(rows: 100, columns: 50, cellSize: 10)
                .id(grassPattern)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                        grassPattern = UUID() //grass changing speed
                    }
                }
                .edgesIgnoringSafeArea(.all)

            // BIRDIE
            ForEach(0..<birdPositions.count, id: \.self) { index in
                BirdFace(
                    headColor: birdColors[index], // face color, random
                    beakColor: .orange, // orange mouth
                    fingerPosition: $fingerPosition,
                    birdPosition: birdPositions[index]
                )
                .position(birdPositions[index])
            }
            
            // a transparent, full-screen layer that captures touch gestures over the entire screen
            Color.clear
                .contentShape(Rectangle()) // Make sure the whole area responds to gestures
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            fingerPosition = value.location
                        }
                )
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            generateBirds()
        }
    }

    // generating birdies
    private func generateBirds() {
        var positions: [CGPoint] = []
        var colors: [Color] = []
        let birdSize: CGFloat = 60
        let grassStartY = 100 // start from middle

        for _ in 0..<numberOfFaces {
            var newPosition: CGPoint
            var attempts = 0
            let maxAttempts = 100

            repeat {
                newPosition = CGPoint(
                    x: CGFloat.random(in: 0..<screenWidth),
                    y: CGFloat.random(in: CGFloat(grassStartY)...screenHeight)
                )
                attempts += 1
            } while positions.contains(where: { position in
                abs(position.x - newPosition.x) < birdSize && abs(position.y - newPosition.y) < birdSize
            }) && attempts < maxAttempts

            positions.append(newPosition)
            colors.append(Color(hue: Double.random(in: 0...1), saturation: 0.7, brightness: 1.0)) // random colors
        }

        birdPositions = positions
        birdColors = colors
    }
}

// grass/print10
struct Print10Maze: View {
    let rows: Int
    let columns: Int
    let cellSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { col in
                        let grassSymbols = ["|", "/", "\\", "~", "／", "＼"]
                        let selectedSymbol = grassSymbols.randomElement()!

                        Text(selectedSymbol)
                            .font(.system(size: cellSize * 20, weight: .bold))
                            .foregroundColor(Color.green.opacity(0.4))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


// bird face
struct BirdFace: View {
    let headColor: Color
    let beakColor: Color
    
    @Binding var fingerPosition: CGPoint
    let birdPosition: CGPoint // birdie position!
    let beakRotation: Double = Double.random(in: -30...30)

    var body: some View {
        ZStack {
            // birdies' legs
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: 3, height: 20)
                    .rotationEffect(.degrees(-10))
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: 3, height: 20)
                    .rotationEffect(.degrees(10))
            }
            .offset(y: 30) // **location

            // bodies
            Circle()
                .fill(headColor)
                .frame(width: 60, height: 50)

            Triangle()
                .fill(beakColor)
                .frame(width: 20, height: 15)
                .offset(x: 25, y: 0)
                .rotationEffect(.degrees(beakRotation))

            // eyes looking at finger position
            HStack(spacing: 10) {
                Eye(fingerPosition: $fingerPosition, birdPosition: birdPosition, offsetX: -10)
                Eye(fingerPosition: $fingerPosition, birdPosition: birdPosition, offsetX: 10)
            }
            .offset(y: -10)
        }
    }
}

// eyes
struct Eye: View {
    @Binding var fingerPosition: CGPoint
    let birdPosition: CGPoint
    let offsetX: CGFloat //

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 15, height: 15)

            Circle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .offset(eyeOffset()) //
                //.animation(.easeOut(duration: 0.01), value: fingerPosition) //
        }
    }

    // Let the pupil follow finger
    private func eyeOffset() -> CGSize {
        // Calculate the coordinates of the center of the eye with respect to the screen
        let eyeCenterX = birdPosition.x + offsetX
        let eyeCenterY = birdPosition.y - 10
        
        let deltaX = fingerPosition.x - eyeCenterX
        let deltaY = fingerPosition.y - eyeCenterY

        // counting angles
        let angle = atan2(deltaY, deltaX)
        let maxOffset: CGFloat = 6

        let offsetX = cos(angle) * maxOffset
        let offsetY = sin(angle) * maxOffset

        return CGSize(width: offsetX, height: offsetY)
    }
}

// mouse
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

@main
struct BirdFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
