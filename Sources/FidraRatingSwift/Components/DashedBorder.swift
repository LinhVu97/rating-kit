import SwiftUI

struct DashedBorder: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let pattern: [CGFloat] = [6, 3] // [line length, gap length]
        
        // Top
        path.addPath(createDashedPath(from: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
                                    to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY),
                                    pattern: pattern))
        
        // Right
        path.addPath(createDashedPath(from: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                                    to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius),
                                    pattern: pattern))
        
        // Bottom
        path.addPath(createDashedPath(from: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
                                    to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY),
                                    pattern: pattern))
        
        // Left
        path.addPath(createDashedPath(from: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
                                    to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius),
                                    pattern: pattern))
        
        // Corners
        let cornerPath = Path { path in
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
            
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(270),
                       endAngle: .degrees(0),
                       clockwise: false)
            
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(0),
                       endAngle: .degrees(90),
                       clockwise: false)
            
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                       radius: cornerRadius,
                       startAngle: .degrees(90),
                       endAngle: .degrees(180),
                       clockwise: false)
        }
        path.addPath(cornerPath)
        return path
    }
    
    private func createDashedPath(from startPoint: CGPoint, to endPoint: CGPoint, pattern: [CGFloat]) -> Path {
        let path = Path { path in
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        return path.strokedPath(StrokeStyle(lineWidth: 1, dash: pattern))
    }
} 