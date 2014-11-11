# ads_domain.rb

Facter.add("ads_domain") do
	setcode do
		%x{wbinfo --own-domain}.chomp
	end
end
