import SwiftUI

struct CurvedArrowShape: Shape {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let start = CGPoint(x: rect.minX + 20, y: rect.maxY - 30)
        let control = CGPoint(x: rect.midX, y: rect.minY + 10)
        let end = CGPoint(x: rect.maxX - 20, y: rect.midY)
        
        let currentEnd = quadBezierPoint(
            t: min(max(progress, 0), 1),
            start: start,
            control: control,
            end: end
        )
        
        path.move(to: start)
        path.addQuadCurve(to: currentEnd, control: control)
        
        if progress > 0.92 {
            let arrowSize: CGFloat = 10
            path.move(to: currentEnd)
            path.addLine(to: CGPoint(x: currentEnd.x - arrowSize, y: currentEnd.y - 4))
            path.move(to: currentEnd)
            path.addLine(to: CGPoint(x: currentEnd.x - 3, y: currentEnd.y + arrowSize))
        }
        
        return path
    }
    
    private func quadBezierPoint(t: CGFloat, start: CGPoint, control: CGPoint, end: CGPoint) -> CGPoint {
        let x = pow(1 - t, 2) * start.x + 2 * (1 - t) * t * control.x + pow(t, 2) * end.x
        let y = pow(1 - t, 2) * start.y + 2 * (1 - t) * t * control.y + pow(t, 2) * end.y
        
        return CGPoint(x: x, y: y)
    }
}
