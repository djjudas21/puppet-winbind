# winbind_version.rb

Facter.add("winbind_version") do
	setcode do
		%x{wbinfo -V 2>&1 | cut -d ' ' -f 2 | cut -d '-' -f 1}.chomp
	end
end
