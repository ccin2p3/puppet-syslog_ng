Facter.add(:syslog_ng) do
  setcode do
    if Facter::Util::Resolution.which('syslog-ng')
      output = Facter::Util::Resolution.exec('syslog-ng --version').lines
      facts = {}
      output.each do |e|
        next unless e =~ /^([^:]*):\s*(.*)/
        k = Regexp.last_match(1)
        v = Regexp.last_match(2)
        facts[k] = v
        facts[k] = v.split(',') if v.match?(/,/)
      end
      facts
    end
  end
end
