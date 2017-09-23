# ads_domain.rb

Facter.add("ads_domain") do
	confine :kernel => :Linux
        confine do
                system("which wbinfo > /dev/null 2>&1")
        end
	setcode do
		%x{wbinfo --own-domain 2>&1}.chomp
	end
end
