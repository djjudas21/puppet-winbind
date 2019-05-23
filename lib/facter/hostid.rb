Facter.add(:hostid) do
  setcode 'hostid'
  confine kernel: ['SunOS', 'Linux', 'AIX', 'GNU/kFreeBSD']
end
