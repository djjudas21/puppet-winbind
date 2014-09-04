# ads_domain.rb

Facter.add("ads_domain") do
	setcode do
		%x{wbinfo -t 2>&1 | cut -d ' ' -f 7 | tail -n 1}.chomp
	end
end
