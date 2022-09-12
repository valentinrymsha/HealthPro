import SpriteKit

enum MSButtonExitNodeState {
    case MSButtonNodeStateActive, MSButtonNodeStateSelected, MSButtonNodeStateHidden
}

class MSButtonExitNode: SKSpriteNode {
    
    var selectedHandler: () -> Void = { print("No button action set") }
    
    var state: MSButtonNodeState = .MSButtonNodeStateActive {
        didSet {
            switch state {
            case .MSButtonNodeStateActive:
                
                self.isUserInteractionEnabled = true
                self.alpha = 1
                
            case .MSButtonNodeStateSelected:
                
                self.alpha = 0.7
                
            case .MSButtonNodeStateHidden:
                
                self.isUserInteractionEnabled = false
                self.alpha = 0
            
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .MSButtonNodeStateSelected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .MSButtonNodeStateActive
    }
    
}
