# -*- encoding: utf-8 -*-
# stub: jekyll-asciinema 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-asciinema".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthias N\u00FC\u00DFler".freeze]
  s.bindir = "exe".freeze
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQUFADA+MRMwEQYDVQQDDAptLm51\nZXNzbGVyMRMwEQYKCZImiZPyLGQBGRYDd2ViMRIwEAYKCZImiZPyLGQBGRYCZGUw\nHhcNMTUxMTI5MjEwNjQ4WhcNMTYxMTI4MjEwNjQ4WjA+MRMwEQYDVQQDDAptLm51\nZXNzbGVyMRMwEQYKCZImiZPyLGQBGRYDd2ViMRIwEAYKCZImiZPyLGQBGRYCZGUw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVwEy18KL+Ok5MZcKAFFZ7\naZqaPAjPIdA3M66ZXBtC+7uQ7QQ1HkfDwbCcKr6xSrgZHJ8ihPuYY/52pfx1Go7o\nSOig3YircS8Vme8V7wZinEKax78vf1+eH91ZSRzb1UBqp/7xZKVSWpxj9t8dz3Ic\nsRayHmnLz76QKUC7ULq14123haEV0sdA7LO0uET0phEjgjNS5OiNu9TFcfY3ZDsM\nCU9ZmWmseGrAVo+Yfnd9BQvSK1+oKO/DFp0/e/SOY+cXceLGM4i1NU+Ws1D5HQMP\n7Qk2LvsQBDnooQjZB8W4Ld0MH/iUFZ/uBtm//Udui3RRiDLP01MB0ZUMhLtUqmAB\nAgMBAAGjdTBzMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQWBBTg6ZtP\nZCRslilSTFeJXj2fk9mzGTAcBgNVHREEFTATgRFtLm51ZXNzbGVyQHdlYi5kZTAc\nBgNVHRIEFTATgRFtLm51ZXNzbGVyQHdlYi5kZTANBgkqhkiG9w0BAQUFAAOCAQEA\nfzOGAh0enoAL2PTMmWSvAkDOCJcKD7smdKPi4cewxR5HgrXAwKGKsVrLMV3hD0Ve\nEptqLWAYfP0rTyNxZMvJNwwXERcZxdhx4lD0hUqPdCwRemuuZW1u5/f4VSBblNNy\nWyyBdemPEcghp8e9TbE5OXYQlueNlJPgkZcsIdXTnY+2LOMvmt85dnhYa7ZOxcWj\nkM+5Asfd6eElzCKVgB9z8NV+3HZ81owov3UtYMNv0W3QLpTFWYuof/LJ2Oo5CJTZ\nTl5nw9bomS8bIbvxbJQtwWLZKxswmsaoFMGrm7oPRveT6dt0go+3uj8yYmO3AzwI\nGnGYLl7nD8BooOLzhXzPkQ==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2015-11-29"
  s.description = "Provides a Liquid tag for embedding asciicasts recorded with asciinema for use in Jekyll sites.".freeze
  s.email = ["m.nuessler@web.de".freeze]
  s.homepage = "https://github.com/mnuessler/jekyll-asciinema".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "Liquid tag for embedding asciicasts in Jekyll sites.".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll>.freeze, [">= 2.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.9"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0"])
    else
      s.add_dependency(%q<jekyll>.freeze, [">= 2.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.9"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_dependency(%q<pry>.freeze, ["~> 0"])
    end
  else
    s.add_dependency(%q<jekyll>.freeze, [">= 2.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.9"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
    s.add_dependency(%q<pry>.freeze, ["~> 0"])
  end
end
