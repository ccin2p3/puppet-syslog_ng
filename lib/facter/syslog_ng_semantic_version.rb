# frozen_string_literal: true

Facter.add(:syslog_ng_semantic_version) do
  setcode do
    Facter.value(:syslog_ng_version) =~ %r{^(\d+\.\d+\.\d+)}
    Regexp.last_match(1)
  end
end
