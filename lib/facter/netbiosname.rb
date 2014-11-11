# Netbios names are limited to 15 chars and must be unique. We can't use
# $hostname or $fqdn because these may be non-unique when truncated. Instead
# we use the first 9 alphanumeric chars of the hostname and then append the 
# last 6 characters of the 8-character $uniqueid
  Facter.add(:netbiosname) do
    setcode do
      uniqueid = Facter.value(:uniqueid)[2..7]
      hostname = Facter.value(:hostname).gsub(/\W/, '')[0..8]
      (hostname+uniqueid).upcase
    end
  end
