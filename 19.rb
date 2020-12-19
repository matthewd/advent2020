# frozen_string_literal: true

rules, inputs = File.read("19.input").split("\n\n")

rule_map = {}
static_rules = {}

rules.each_line do |line|
  number, rule = line.split(": ")

  if rule =~ /"(.*)"/
    static_rules[number.to_i] = /#{$1}/
  else
    rule_map[number.to_i] = rule.split(" | ").map do |alt|
      alt.split.map(&:to_i)
    end
  end
end


def expand_rules(static_rules, rule_map, overrides = {})
  final_rules = static_rules.dup
  rule_map = rule_map.dup

  until rule_map.empty?
    rule_map.keys.each do |rule_num|
      if overrides[rule_num]
        requirements, replacement = overrides[rule_num]
        if requirements.all? { |k| final_rules[k] }
          rule_map.delete rule_num
          final_rules[rule_num] = replacement.call(*requirements.map { |k| final_rules[k] })
        end
      else
        if rule_map[rule_num].all? { |alt| alt.all? { |num| final_rules.key?(num) } }
          alternates = rule_map.delete(rule_num)
          final_rules[rule_num] = Regexp.union(alternates.map { |alt| alt.map { |num| final_rules[num] }.reduce { |a, e| /#{a}#{e}/ } })
        end
      end
    end
  end

  final_rules
end


expanded_rules = expand_rules(static_rules, rule_map)

p inputs.lines.grep(/\A#{expanded_rules[0]}\Z/).size


new_expanded_rules = expand_rules(static_rules, rule_map, {
  8 => [[42], -> repeatable { /#{repeatable}+/ }],
  11 => [[42, 31], -> before, after { /(#{before}\g<1>?#{after})/ }],
})

p inputs.lines.grep(/\A#{new_expanded_rules[0]}\Z/).size

