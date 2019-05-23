# Netbios names are limited to 15 chars and must be unique. We can't use
# $hostname or $fqdn because these may be non-unique when truncated. Instead
# we use the first 9 alphanumeric chars of the hostname and then append the
# last 6 characters of the 8-character $hostid
require 'facter'
Facter.add(:netbiosname) do
  confine kernel: :Linux
  setcode do
    hostid = Facter.value(:hostid)[2..7]
    hostname = Facter.value(:hostname).gsub(%r{\W}, '')[0..8]
    (hostname + hostid).upcase
  end
end
