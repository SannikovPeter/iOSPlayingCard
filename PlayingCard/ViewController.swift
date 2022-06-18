//
//  ViewController.swift
//  PlayingCard
//
//  Created by Пётр Санников on 29.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PalayingCardDeck()
    
    private let cardSize = CGSize(width: 100, height: 160)
    
    private lazy var playingCardPositions: [CGPoint] = getThreeCardPointsRow(withAbovePadding: 40)
    
    private lazy var cardsInDeck: [PlayingCardView]  = createCardDeckView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsInDeck.shuffle()
    }
    
    private func getThreeCardPointsRow(withAbovePadding y: CGFloat) -> [CGPoint] {
        var result = [CGPoint]()
        let firstPoint = CGPoint(x: 20, y: y)
        let thirdPoint = CGPoint(x: (view.frame.width - 20 - cardSize.width), y: y)
        let spaceBetwenFirstAndThird = thirdPoint.x - (firstPoint.x + cardSize.width)
        let spaceBetwenFirstAndSecond = (spaceBetwenFirstAndThird - cardSize.width)/2
        let secondPoint = CGPoint(x: firstPoint.x + cardSize.width + spaceBetwenFirstAndSecond, y: y)
        result.append(firstPoint)
        result.append(secondPoint)
        result.append(thirdPoint)
        return result
    }
    
    private func createCardDeckView() -> [PlayingCardView] {
        var result = [PlayingCardView]()
        for card in deck.cards {
            let playingCard = PlayingCardView()
            let deckPointPosition = CGPoint(
                x: view.frame.width/2 - cardSize.width/2,
                y: view.frame.height - 40 - cardSize.height)
            playingCard.frame = CGRect(origin: deckPointPosition, size: CGSize(width: 100, height: 160))
            playingCard.rank = card.rank.order
            playingCard.suit = card.suit.rawValue
            playingCard.isFaceUp = false
            playingCard.backgroundColor = .clear
            view.addSubview(playingCard)
            result.append(playingCard)
            result.shuffle()
        }
        return result
    }
    
    @IBAction func dealCards(_ sender: Any) {
        var cards = [PlayingCardView]()
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/1.5, animations: {
                let card = self.cardsInDeck.removeFirst()
                cards.append(card)
                card.frame.origin.x = self.playingCardPositions[0].x
                card.frame.origin.y = self.playingCardPositions[0].y
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5/1.5, relativeDuration: 0.5/1.5, animations: {
                let card = self.cardsInDeck.removeFirst()
                cards.append(card)
                card.frame.origin.x = self.playingCardPositions[1].x
                card.frame.origin.y = self.playingCardPositions[1].y
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0/1.5, relativeDuration: 0.5/1.5, animations: {
                let card = self.cardsInDeck.removeFirst()
                cards.append(card)
                card.frame.origin.x = self.playingCardPositions[2].x
                card.frame.origin.y = self.playingCardPositions[2].y
            })
        }, completion:{ _ in
            for card in cards {
                self.flipCardAnimation(card: card)
                card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.flipCard(_:))))
            }
        })
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCard = recognizer.view as? PlayingCardView {
               flipCardAnimation(card: chosenCard)
            }
        default: break
        }
    }
    
    private func flipCardAnimation(card: PlayingCardView) {
        UIView.transition(
            with: card,
            duration: 0.6,
            options: [.transitionFlipFromLeft],
            animations: {
                card.isFaceUp = !card.isFaceUp
            }
        )
    }
}

