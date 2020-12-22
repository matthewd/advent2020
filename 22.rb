# frozen_string_literal: true

start_decks = File.read("22.input").split("\n\n").map { |deck| deck.split.drop(2).map(&:to_i) }

decks = start_decks.map(&:dup)
until decks.any?(&:empty?)
  cards = decks.map(&:shift)

  winner = cards.index(cards.max)

  decks[winner] << cards[winner]
  decks[winner] << cards[1 - winner]
end

p decks.flatten.reverse.enum_for(:sum).with_index(1) { |card, counter| card * counter }


def play_game(decks)
  seen_decks = Set.new

  until decks.any?(&:empty?)
    return [0, decks] if seen_decks.include?(decks)

    seen_decks << decks.map(&:dup)

    cards = decks.map(&:shift)

    sub_decks = decks.zip(cards).map { |deck, card| deck.size >= card && deck.first(card) }

    if sub_decks.all?
      winner, = play_game(sub_decks)
    else
      winner = cards.index(cards.max)
    end

    decks[winner] << cards[winner]
    decks[winner] << cards[1 - winner]
  end

  [1 - decks.index([]), decks]
end

_, final_decks = play_game(start_decks)

p final_decks.flatten.reverse.enum_for(:sum).with_index(1) { |card, counter| card * counter }

