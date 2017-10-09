# ads_domain.rb

Facter.add("ads_domain") do
	confine :kernel => :Linux
	confine { Facter::Core::Execution.which('wbinfo') }
	setcode do
		%x{wbinfo --own-domain 2>&1}.chomp
	end
end
