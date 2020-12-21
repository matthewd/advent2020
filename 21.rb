# frozen_string_literal: true

pairs = File.read("21.input").lines.map do |line|
  line =~ /(.*) \(contains (.*)\)/

  ingredients = $1.split
  allergens = $2.split(", ")

  [ingredients, allergens]
end

allergen_ingredients = {}

pairs.each do |ingredients, allergens|
  allergens.each do |allergen|
    if allergen_ingredients.key?(allergen)
      allergen_ingredients[allergen] &= ingredients
    else
      allergen_ingredients[allergen] = ingredients
    end
  end
end

resolved_allergens = {}

until allergen_ingredients.empty?
  allergen_ingredients.select { |_, is| is.size == 1 }.each do |allergen, (ingredient)|
    allergen_ingredients.delete allergen
    resolved_allergens[allergen] = ingredient
    allergen_ingredients.values.each { |other_list| other_list.delete(ingredient) }
  end
end

p (pairs.flat_map(&:first) - resolved_allergens.values).size

puts resolved_allergens.sort.map(&:last).join(",")
