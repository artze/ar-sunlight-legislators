require_relative '../db/config'
require_relative './models/legislator'

def legislator_by_state(state)
	puts 'Senators:'
	Legislator.where(state: state, title: 'Sen').order(:lastname).each do |result|
		puts result.firstname + ' ' + result.lastname + ' ' + '(' + result.party + ')'
	end
	puts ' '
	puts 'Representatives:'
	Legislator.where(state: state, title: 'Rep').order(:lastname).each do |result|
		puts result.firstname + ' ' + result.lastname + ' ' + '(' + result.party + ')'
	end
end

# legislator_by_state('TX')

def gender_split(gender)
	gender == 'M' ? gender_text = 'Male' : gender_text = 'Female'
	total_senators = Legislator.where(title: 'Sen').where.not(in_office: 0).count
	senators_gender_count = Legislator.where(title: 'Sen', gender: gender).where.not(in_office: 0).count
	puts "#{gender_text} Senators: #{senators_gender_count} (#{(senators_gender_count.fdiv(total_senators) * 100).round}%)"

	total_reps = Legislator.where(title: 'Rep').where.not(in_office: 0).count
	reps_gender_count = Legislator.where(title: 'Rep', gender: gender).where.not(in_office: 0).count
	puts "#{gender_text} Representatives: #{reps_gender_count} (#{(reps_gender_count.fdiv(total_reps) * 100).round}%)"
end

# gender_split('M')

def legislators_by_states
	Legislator.group(:state).order('count_id desc').count(:id).each do |k, v|
		puts "#{k}: #{Legislator.where(title: 'Sen', state: k).where.not(in_office: 0).count} Senators, #{Legislator.where(title: 'Rep', state: k).where.not(in_office: 0).count} Representative(s)"
	end
end

# legislators_by_states

def total_legislators
	puts "Senators: #{Legislator.where(title: 'Sen').count}"
	puts "Representatives: #{Legislator.where(title: 'Rep').count}"
end

total_legislators

def delete_inactive
	Legislator.where(in_office: 0).destroy_all
	puts 'Inactive legislators removed from records.'
end

# delete_inactive
