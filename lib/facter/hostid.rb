Facter.add(:hostid) do
  setcode 'hostid'
  confine :kernel => %w{SunOS Linux AIX GNU/kFreeBSD}
end
