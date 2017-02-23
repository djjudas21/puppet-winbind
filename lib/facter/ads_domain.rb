# ads_domain.rb

Facter.add("ads_domain") do
	setcode do
		%x{wbinfo --own-domain 2>&1}.chomp
	end
end
